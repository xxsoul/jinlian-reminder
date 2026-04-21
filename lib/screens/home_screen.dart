import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'medication_list_screen.dart';
import 'log_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MedicationLog> _todayLogs = [];
  List<Medication> _medications = [];
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

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('暖暖瓜心'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _buildContent(),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MedicationListScreen()),
            ).then((_) => _loadData());
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogScreen()),
            ).then((_) => _loadData());
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '今日'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: '药物'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '记录'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_todayLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('今日暂无服药提醒', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final pendingLogs = _todayLogs.where((l) => l.status == MedicationLogStatus.missed).toList();
    final completedLogs = _todayLogs.where((l) =>
      l.status == MedicationLogStatus.taken || l.status == MedicationLogStatus.skipped
    ).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pendingLogs.isNotEmpty) ...[
          Text('待服药 (${pendingLogs.length})', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...pendingLogs.map((log) => _buildPendingLogCard(log)),
        ],
        if (completedLogs.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('已完成 (${completedLogs.length})', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...completedLogs.map((log) => _buildCompletedLogCard(log)),
        ],
      ],
    );
  }

  Widget _buildPendingLogCard(MedicationLog log) {
    final medication = _medications.firstWhere(
      (m) => m.id == log.medicationId,
      orElse: () => Medication(name: '未知药物', dosage: '', createdAt: DateTime.now()),
    );

    return Card(
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

  Widget _buildCompletedLogCard(MedicationLog log) {
    final medication = _medications.firstWhere(
      (m) => m.id == log.medicationId,
      orElse: () => Medication(name: '未知药物', dosage: '', createdAt: DateTime.now()),
    );

    final icon = log.status == MedicationLogStatus.taken
        ? Icons.check_circle
        : Icons.cancel;
    final color = log.status == MedicationLogStatus.taken
        ? Colors.green
        : Colors.grey;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(medication.name),
        subtitle: Text('${medication.dosage} - ${_formatTime(log.scheduledTime)}'),
      ),
    );
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