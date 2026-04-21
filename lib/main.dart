import 'package:flutter/material.dart';
import 'models/models.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/reminder_scheduler.dart';
import 'services/follow_up_reminder_service.dart';
import 'screens/medication_list_screen.dart';
import 'screens/log_screen.dart';
import 'screens/follow_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.instance.init();
  await NotificationService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '金莲提醒',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const MedicationListScreen(),
    const FollowUpScreen(),
    const LogScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 请求通知权限
    await NotificationService.instance.requestPermission();
    // 初始化所有活跃提醒
    await ReminderScheduler.instance.initializeAllReminders();
    // 初始化复诊提醒
    await FollowUpReminderService.instance.initializeFollowUpReminders();
    // 检查到期的复诊提醒
    await FollowUpReminderService.instance.checkDueFollowUpAlerts();
    // 检查非复诊模式的截止日期
    await FollowUpReminderService.instance.checkEndDateForNonFollowUpMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '今日'),
          NavigationDestination(icon: Icon(Icons.medication), label: '药物'),
          NavigationDestination(icon: Icon(Icons.event), label: '复诊'),
          NavigationDestination(icon: Icon(Icons.history), label: '记录'),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  List<MedicationLog> _todayLogs = [];
  List<Medication> _medications = [];
  List<FollowUpAlert> _pendingFollowUps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _todayLogs = await DatabaseService.instance.getTodayLogs();
    _medications = await DatabaseService.instance.getActiveMedications();
    _pendingFollowUps = await DatabaseService.instance.getPendingFollowUpAlerts();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('金莲提醒'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 16),
        if (_pendingFollowUps.isNotEmpty) ...[
          _buildFollowUpSection(),
          const SizedBox(height: 16),
        ],
        _buildTodayMedicationSection(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final pendingCount = _todayLogs.where((l) => l.status == MedicationLogStatus.missed).length;
    final completedCount = _todayLogs.where((l) => l.status == MedicationLogStatus.taken).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今日概览', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  Icons.pending,
                  '$pendingCount',
                  '待服药',
                  Colors.orange,
                ),
                _buildSummaryItem(
                  Icons.check_circle,
                  '$completedCount',
                  '已完成',
                  Colors.green,
                ),
                _buildSummaryItem(
                  Icons.medication,
                  '${_medications.length}',
                  '药物',
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildFollowUpSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('复诊提醒', style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  onPressed: () {
                    // 切换到复诊页面需要通过回调或者其他方式
                    // 暂时不实现导航
                  },
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._pendingFollowUps.take(3).map((alert) => _buildFollowUpItem(alert)),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpItem(FollowUpAlert alert) {
    final medication = _medications.firstWhere(
      (m) => m.id == alert.medicationId,
      orElse: () => Medication(name: '未知药物', dosage: '', createdAt: DateTime.now()),
    );

    final daysUntil = alert.followUpDate.difference(DateTime.now()).inDays;

    return ListTile(
      leading: Icon(
        daysUntil < 0 ? Icons.warning : Icons.calendar_today,
        color: daysUntil < 0 ? Colors.red : Colors.orange,
      ),
      title: Text(medication.name),
      subtitle: Text('复诊：${_formatDate(alert.followUpDate)} - 剩余 $daysUntil 天'),
    );
  }

  Widget _buildTodayMedicationSection() {
    final pendingLogs = _todayLogs.where((l) => l.status == MedicationLogStatus.missed).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今日待服药', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (pendingLogs.isEmpty)
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('所有药物已服用'),
              )
            else
              ...pendingLogs.map((log) => _buildLogCard(log)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(MedicationLog log) {
    final medication = _medications.firstWhere(
      (m) => m.id == log.medicationId,
      orElse: () => Medication(name: '未知药物', dosage: '', createdAt: DateTime.now()),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(medication.name),
        subtitle: Text('${medication.dosage} - ${_formatTime(log.scheduledTime)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _markTaken(log),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _markSkipped(log),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _markTaken(MedicationLog log) async {
    await DatabaseService.instance.markLogTaken(log.id, DateTime.now());
    _loadData();
  }

  Future<void> _markSkipped(MedicationLog log) async {
    await DatabaseService.instance.markLogSkipped(log.id, null);
    _loadData();
  }
}