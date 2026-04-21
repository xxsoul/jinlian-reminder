import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class ReminderFormScreen extends StatefulWidget {
  final int medicationId;
  final Reminder? reminder;

  const ReminderFormScreen({
    super.key,
    required this.medicationId,
    this.reminder,
  });

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _messageController;

  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  ReminderFrequency _frequency = ReminderFrequency.daily;
  List<int> _selectedWeekdays = [];
  List<int> _selectedMonthDays = [];
  int _intervalDays = 1;
  int _intervalHours = 1;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.reminder != null;

    _messageController = TextEditingController(text: widget.reminder?.message ?? '请按时服药');

    if (widget.reminder != null) {
      final timeParts = widget.reminder!.time.split(':');
      _time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      _frequency = widget.reminder!.frequency;

      if (widget.reminder!.frequencyDetails != null) {
        switch (_frequency) {
          case ReminderFrequency.weekly:
            _selectedWeekdays = widget.reminder!.frequencyDetails!.split(',').map(int.parse).toList();
            break;
          case ReminderFrequency.monthly:
            _selectedMonthDays = widget.reminder!.frequencyDetails!.split(',').map(int.parse).toList();
            break;
          case ReminderFrequency.interval:
            _intervalDays = int.parse(widget.reminder!.frequencyDetails!);
            break;
          case ReminderFrequency.intervalHours:
            _intervalHours = int.parse(widget.reminder!.frequencyDetails!);
            break;
          case ReminderFrequency.daily:
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑提醒' : '添加提醒'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: const Text('提醒时间'),
              subtitle: Text(_formatTime(_time)),
              trailing: const Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ReminderFrequency>(
              initialValue: _frequency,
              decoration: const InputDecoration(
                labelText: '提醒频率',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: ReminderFrequency.daily, child: Text('每天')),
                DropdownMenuItem(value: ReminderFrequency.weekly, child: Text('每周')),
                DropdownMenuItem(value: ReminderFrequency.monthly, child: Text('每月')),
                DropdownMenuItem(value: ReminderFrequency.interval, child: Text('间隔天数')),
                DropdownMenuItem(value: ReminderFrequency.intervalHours, child: Text('间隔小时数')),
              ],
              onChanged: (value) {
                setState(() => _frequency = value ?? ReminderFrequency.daily);
              },
            ),
            const SizedBox(height: 16),
            if (_frequency == ReminderFrequency.weekly) _buildWeekdaySelector(),
            if (_frequency == ReminderFrequency.monthly) _buildMonthDaySelector(),
            if (_frequency == ReminderFrequency.interval) _buildIntervalSelector(),
            if (_frequency == ReminderFrequency.intervalHours) _buildIntervalHoursSelector(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: '提醒消息',
                hintText: '如：请按时服药',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入提醒消息';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveReminder,
              child: Text(_isEditing ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (time != null) {
      setState(() => _time = time);
    }
  }

  Widget _buildWeekdaySelector() {
    final dayNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('选择星期'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            final weekday = index + 1;
            final selected = _selectedWeekdays.contains(weekday);
            return FilterChip(
              label: Text(dayNames[index]),
              selected: selected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    _selectedWeekdays.add(weekday);
                  } else {
                    _selectedWeekdays.remove(weekday);
                  }
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMonthDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('选择日期（1-31）'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(31, (index) {
            final day = index + 1;
            final selected = _selectedMonthDays.contains(day);
            return FilterChip(
              label: Text('$day'),
              selected: selected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    _selectedMonthDays.add(day);
                  } else {
                    _selectedMonthDays.remove(day);
                  }
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildIntervalSelector() {
    return Row(
      children: [
        const Text('间隔'),
        const SizedBox(width: 16),
        Expanded(
          child: Slider(
            value: _intervalDays.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            label: '$_intervalDays 天',
            onChanged: (value) {
              setState(() => _intervalDays = value.toInt());
            },
          ),
        ),
        Text('$_intervalDays 天'),
      ],
    );
  }

  Widget _buildIntervalHoursSelector() {
    return Row(
      children: [
        const Text('间隔'),
        const SizedBox(width: 16),
        Expanded(
          child: Slider(
            value: _intervalHours.toDouble(),
            min: 1,
            max: 168,
            divisions: 167,
            label: '$_intervalHours 小时',
            onChanged: (value) {
              setState(() => _intervalHours = value.toInt());
            },
          ),
        ),
        Text('$_intervalHours 小时'),
      ],
    );
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_frequency == ReminderFrequency.weekly && _selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择至少一个星期')),
      );
      return;
    }

    if (_frequency == ReminderFrequency.monthly && _selectedMonthDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择至少一个日期')),
      );
      return;
    }

    String? frequencyDetails;
    switch (_frequency) {
      case ReminderFrequency.weekly:
        frequencyDetails = _selectedWeekdays.join(',');
        break;
      case ReminderFrequency.monthly:
        frequencyDetails = _selectedMonthDays.join(',');
        break;
      case ReminderFrequency.interval:
        frequencyDetails = _intervalDays.toString();
        break;
      case ReminderFrequency.intervalHours:
        frequencyDetails = _intervalHours.toString();
        break;
      case ReminderFrequency.daily:
        frequencyDetails = null;
        break;
    }

    final reminder = Reminder(
      id: widget.reminder?.id ?? Isar.autoIncrement,
      medicationId: widget.medicationId,
      time: _formatTime(_time),
      frequency: _frequency,
      frequencyDetails: frequencyDetails,
      message: _messageController.text.trim(),
      nextTriggerTime: widget.reminder?.nextTriggerTime,
      isActive: widget.reminder?.isActive ?? true,
      createdAt: widget.reminder?.createdAt ?? DateTime.now(),
    );

    await DatabaseService.instance.saveReminder(reminder);

    // 获取药物并调度提醒
    final medication = await DatabaseService.instance.getMedication(widget.medicationId);
    if (medication != null && medication.isActive && reminder.isActive) {
      await ReminderScheduler.instance.scheduleReminderNotification(reminder, medication);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }
}