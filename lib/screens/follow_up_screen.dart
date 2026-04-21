import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

/// 复诊提醒页面
/// 显示待确认的复诊提醒列表，允许用户确认复诊完成
class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  List<FollowUpAlert> _alerts = [];
  Map<int, Medication> _medications = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _alerts = await DatabaseService.instance.getPendingFollowUpAlerts();
    final allMedications = await DatabaseService.instance.getAllMedications();
    _medications = {for (var m in allMedications) m.id: m};

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('复诊提醒'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alerts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _alerts.length,
                  itemBuilder: (context, index) => _buildAlertCard(_alerts[index]),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            '暂无待确认的复诊提醒',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            '当药物设置复诊日期后，将在这里显示提醒',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(FollowUpAlert alert) {
    final medication = _medications[alert.medicationId];
    if (medication == null) return const SizedBox.shrink();

    final daysUntil = alert.followUpDate.difference(DateTime.now()).inDays;
    final isOverdue = daysUntil < 0;
    final isToday = daysUntil == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOverdue
                      ? Icons.warning
                      : isToday
                          ? Icons.event
                          : Icons.calendar_today,
                  color: isOverdue
                      ? Colors.red
                      : isToday
                          ? Colors.orange
                          : Colors.green,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '复诊日期：${_formatDate(alert.followUpDate)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isOverdue
                                  ? Colors.red
                                  : isToday
                                      ? Colors.orange
                                      : Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusChip(alert, daysUntil),
            if (!alert.hasAlerted && !isOverdue) ...[
              const SizedBox(height: 12),
              Text(
                '将在 ${_formatDate(alert.alertDate)} 提醒您',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!alert.isConfirmed)
                  ElevatedButton.icon(
                    onPressed: () => _confirmFollowUp(alert, medication),
                    icon: const Icon(Icons.check),
                    label: const Text('确认复诊'),
                  ),
                if (isOverdue && !alert.isConfirmed) ...[
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _rescheduleFollowUp(alert, medication),
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text('改期'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(FollowUpAlert alert, int daysUntil) {
    String statusText;
    Color statusColor;

    if (daysUntil < 0) {
      statusText = '已过期 ${-daysUntil} 天';
      statusColor = Colors.red;
    } else if (daysUntil == 0) {
      statusText = '今天复诊';
      statusColor = Colors.orange;
    } else if (daysUntil <= 3) {
      statusText = '剩余 $daysUntil 天';
      statusColor = Colors.orange;
    } else {
      statusText = '剩余 $daysUntil 天';
      statusColor = Colors.green;
    }

    return Chip(
      label: Text(statusText),
      backgroundColor: statusColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: statusColor),
    );
  }

  Future<void> _confirmFollowUp(FollowUpAlert alert, Medication medication) async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认复诊'),
        content: Text('确认您已完成 "${medication.name}" 的复诊吗？\n\n复诊日期：${_formatDate(alert.followUpDate)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FollowUpReminderService.instance.confirmFollowUpCompleted(medication.id);

      if (!mounted) return;

      // 询问是否需要继续用药
      final continueMedication = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('继续用药？'),
          content: const Text('是否需要继续服用此药物？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('停药'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('继续'),
            ),
          ],
        ),
      );

      if (continueMedication == true) {
        if (!mounted) return;

        // 重新设置复诊日期
        final newDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (newDate != null) {
          medication.followUpDate = newDate;
          medication.hasFollowUpDate = true;
          await DatabaseService.instance.saveMedication(medication);
          await FollowUpReminderService.instance.updateFollowUpDate(medication, newDate);
        }
      } else {
        // 停药
        medication.isActive = false;
        await DatabaseService.instance.saveMedication(medication);
        await ReminderScheduler.instance.cancelAllRemindersForMedication(medication.id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('复诊已确认')),
        );
        _loadData();
      }
    }
  }

  Future<void> _rescheduleFollowUp(FollowUpAlert alert, Medication medication) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDate != null) {
      medication.followUpDate = newDate;
      await DatabaseService.instance.saveMedication(medication);
      await FollowUpReminderService.instance.updateFollowUpDate(medication, newDate);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('复诊日期已更新')),
        );
        _loadData();
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}