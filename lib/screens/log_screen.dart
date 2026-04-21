import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  DateTime _selectedDate = DateTime.now();
  List<MedicationLog> _logs = [];
  Map<int, Medication> _medications = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _logs = await DatabaseService.instance.getLogsForDate(_selectedDate);
    final allMedications = await DatabaseService.instance.getAllMedications();
    _medications = {for (var m in allMedications) m.id: m};

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服药记录'),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('${_formatDate(_selectedDate)} 无记录', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _logs.length,
                        itemBuilder: (context, index) => _buildLogCard(_logs[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
              _loadData();
            },
          ),
          InkWell(
            onTap: _selectDate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _formatDate(_selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
              _loadData();
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
      _loadData();
    }
  }

  Widget _buildLogCard(MedicationLog log) {
    final medication = _medications[log.medicationId];
    final statusIcon = _getStatusIcon(log.status);
    final statusColor = _getStatusColor(log.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(medication?.name ?? '未知药物'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('计划时间: ${_formatTime(log.scheduledTime)}'),
            if (log.actualTime != null)
              Text('实际时间: ${_formatTime(log.actualTime!)}'),
            Text(_getStatusText(log.status)),
            if (log.notes != null)
              Text('备注: ${log.notes}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  IconData _getStatusIcon(MedicationLogStatus status) {
    switch (status) {
      case MedicationLogStatus.taken:
        return Icons.check_circle;
      case MedicationLogStatus.skipped:
        return Icons.cancel;
      case MedicationLogStatus.missed:
        return Icons.warning;
    }
  }

  Color _getStatusColor(MedicationLogStatus status) {
    switch (status) {
      case MedicationLogStatus.taken:
        return Colors.green;
      case MedicationLogStatus.skipped:
        return Colors.grey;
      case MedicationLogStatus.missed:
        return Colors.orange;
    }
  }

  String _getStatusText(MedicationLogStatus status) {
    switch (status) {
      case MedicationLogStatus.taken:
        return '已服药';
      case MedicationLogStatus.skipped:
        return '已跳过';
      case MedicationLogStatus.missed:
        return '待处理';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}