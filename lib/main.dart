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
    // 请求精确闹钟权限（Android 12+ 需要）
    await NotificationService.instance.requestExactAlarmPermission();
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
  List<Reminder> _todayReminders = [];
  List<Medication> _medications = [];
  List<FollowUpAlert> _pendingFollowUps = [];
  bool _isLoading = true;
  bool _notificationsEnabled = true;
  bool _exactAlarmsEnabled = true;
  bool _batteryOptimizationIgnored = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    _notificationsEnabled = await NotificationService.instance.areNotificationsEnabled();
    _exactAlarmsEnabled = await NotificationService.instance.canScheduleExactAlarms();
    _batteryOptimizationIgnored = await NotificationService.instance.isIgnoringBatteryOptimizations();
    setState(() {});
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // 先检查并创建已触发但无记录的服药记录
    await _syncTriggeredReminders();

    _todayLogs = await DatabaseService.instance.getTodayLogs();
    _todayReminders = await DatabaseService.instance.getTodayReminders();
    _medications = await DatabaseService.instance.getActiveMedications();
    _pendingFollowUps = await DatabaseService.instance.getPendingFollowUpAlerts();

    setState(() => _isLoading = false);
  }

  /// 同步已触发但无服药记录的提醒
  Future<void> _syncTriggeredReminders() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // 获取今天所有活跃提醒
    final todayReminders = await DatabaseService.instance.getTodayReminders();

    for (final reminder in todayReminders) {
      final nextTrigger = reminder.nextTriggerTime;
      if (nextTrigger == null) continue;

      // 如果提醒时间已过且没有创建记录，则创建一条 missed 记录
      if (nextTrigger.isBefore(now) || nextTrigger.isAtSameMomentAs(now)) {
        final hasLog = await DatabaseService.instance.hasLogForReminderToday(reminder.id);
        if (!hasLog) {
          final log = MedicationLog(
            medicationId: reminder.medicationId,
            reminderId: reminder.id,
            scheduledTime: nextTrigger,
            status: MedicationLogStatus.missed,
            createdAt: now,
          );
          await DatabaseService.instance.saveLog(log);
        }
      }
    }
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
        if (!_notificationsEnabled || !_exactAlarmsEnabled || !_batteryOptimizationIgnored) ...[
          _buildPermissionWarningCard(),
          const SizedBox(height: 16),
        ],
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

  Widget _buildPermissionWarningCard() {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text('提醒设置', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.orange.shade700)),
              ],
            ),
            const SizedBox(height: 12),
            if (!_notificationsEnabled)
              const Text('• 通知权限未开启，将无法收到服药提醒'),
            if (!_exactAlarmsEnabled)
              const Text('• 精确闹钟权限未开启，提醒可能无法准时触发'),
            if (!_batteryOptimizationIgnored)
              const Text('• 电池优化未关闭，系统可能会延迟提醒通知'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (!_notificationsEnabled) {
                  await NotificationService.instance.requestPermission();
                }
                if (!_exactAlarmsEnabled) {
                  await NotificationService.instance.requestExactAlarmPermission();
                }
                if (!_batteryOptimizationIgnored) {
                  await NotificationService.instance.requestIgnoreBatteryOptimizations();
                }
                _checkPermissions();
              },
              child: const Text('设置权限'),
            ),
          ],
        ),
      ),
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
    final now = DateTime.now();
    final upcomingReminders = _todayReminders.where((r) => r.nextTriggerTime != null && r.nextTriggerTime!.isAfter(now)).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pendingLogs.isNotEmpty) ...[
              Text('已到时间待服药', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...pendingLogs.map((log) => _buildLogCard(log)),
              const SizedBox(height: 16),
            ],
            if (upcomingReminders.isNotEmpty) ...[
              Text('今日即将服药', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...upcomingReminders.map((reminder) => _buildUpcomingReminderCard(reminder)),
            ],
            if (pendingLogs.isEmpty && upcomingReminders.isEmpty)
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('今日暂无服药安排'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingReminderCard(Reminder reminder) {
    final medication = _medications.firstWhere(
      (m) => m.id == reminder.medicationId,
      orElse: () => Medication(name: '未知药物', dosage: '', createdAt: DateTime.now()),
    );

    final triggerTime = reminder.nextTriggerTime!;
    final timeStr = _formatTime(triggerTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.schedule, color: Colors.white),
        ),
        title: Text(medication.name),
        subtitle: Text('${medication.dosage} - $timeStr'),
        trailing: Text(
          triggerTime.difference(DateTime.now()).inMinutes < 60
              ? '${triggerTime.difference(DateTime.now()).inMinutes}分钟后'
              : '${triggerTime.difference(DateTime.now()).inHours}小时后',
          style: TextStyle(color: Colors.blue, fontSize: 12),
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