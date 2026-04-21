import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'reminder_form_screen.dart';

class ReminderListScreen extends StatefulWidget {
  final int medicationId;

  const ReminderListScreen({super.key, required this.medicationId});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  Medication? _medication;
  List<Reminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _medication = await DatabaseService.instance.getMedication(widget.medicationId);
    _reminders = await DatabaseService.instance.getRemindersForMedication(widget.medicationId);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_medication?.name ?? '提醒列表'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reminders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.alarm_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('暂无提醒，点击右下角添加', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _reminders.length,
                  itemBuilder: (context, index) => _buildReminderCard(_reminders[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    final frequencyText = _getFrequencyText(reminder);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          reminder.isActive ? Icons.alarm : Icons.alarm_off,
          color: reminder.isActive ? Colors.green : Colors.grey,
        ),
        title: Text(reminder.time),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(frequencyText),
            if (reminder.nextTriggerTime != null)
              Text(
                '下次: ${_formatDateTime(reminder.nextTriggerTime!)}',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('编辑')),
            const PopupMenuItem(value: 'toggle', child: Text('暂停/恢复')),
            const PopupMenuItem(value: 'delete', child: Text('删除')),
          ],
          onSelected: (value) {
            if (value == 'edit') _editReminder(reminder);
            if (value == 'toggle') _toggleReminder(reminder);
            if (value == 'delete') _deleteReminder(reminder);
          },
        ),
      ),
    );
  }

  String _getFrequencyText(Reminder reminder) {
    switch (reminder.frequency) {
      case ReminderFrequency.daily:
        return '每天';
      case ReminderFrequency.weekly:
        final days = reminder.frequencyDetails?.split(',') ?? [];
        final dayNames = ['一', '二', '三', '四', '五', '六', '日'];
        final names = days.map((d) => '周${dayNames[int.parse(d) - 1]}').join(', ');
        return '每周 $names';
      case ReminderFrequency.monthly:
        return '每月 ${reminder.frequencyDetails} 号';
      case ReminderFrequency.interval:
        return '每 ${reminder.frequencyDetails} 天';
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _addReminder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReminderFormScreen(medicationId: widget.medicationId),
      ),
    );
    if (result == true) _loadData();
  }

  Future<void> _editReminder(Reminder reminder) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReminderFormScreen(
          medicationId: widget.medicationId,
          reminder: reminder,
        ),
      ),
    );
    if (result == true) _loadData();
  }

  Future<void> _toggleReminder(Reminder reminder) async {
    reminder.isActive = !reminder.isActive;
    await DatabaseService.instance.saveReminder(reminder);

    if (_medication != null) {
      if (reminder.isActive) {
        await ReminderScheduler.instance.scheduleReminderNotification(reminder, _medication!);
      } else {
        await ReminderScheduler.instance.cancelReminderNotification(reminder.id);
      }
    }

    _loadData();
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个提醒吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ReminderScheduler.instance.cancelReminderNotification(reminder.id);
      await DatabaseService.instance.deleteReminder(reminder.id);
      _loadData();
    }
  }
}