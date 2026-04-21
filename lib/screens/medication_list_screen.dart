import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'medication_form_screen.dart';
import 'reminder_list_screen.dart';
import 'reminder_form_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() => _isLoading = true);
    _medications = await DatabaseService.instance.getAllMedications();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('药物列表'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _medications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('暂无药物，点击右下角添加', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _medications.length,
                  itemBuilder: (context, index) => _buildMedicationCard(_medications[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMedication(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showMedicationOptions(medication),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    medication.isActive ? Icons.medication : Icons.warning,
                    color: medication.isActive ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      medication.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    medication.dosage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              if (medication.instructions != null) ...[
                const SizedBox(height: 8),
                Text(
                  medication.instructions!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (medication.hasFollowUpDate && medication.followUpDate != null)
                    Expanded(
                      child: Text(
                        '复诊: ${_formatDate(medication.followUpDate!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange),
                      ),
                    ),
                  if (!medication.hasFollowUpDate && medication.endDate != null)
                    Expanded(
                      child: Text(
                        '截止: ${_formatDate(medication.endDate!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                      ),
                    ),
                  if (!medication.hasFollowUpDate && medication.endDate == null)
                    const Expanded(child: Text('长期用药', style: TextStyle(color: Colors.green))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showMedicationOptions(Medication medication) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('查看提醒'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReminderListScreen(medicationId: medication.id),
                  ),
                ).then((_) => _loadMedications());
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('编辑药物'),
              onTap: () {
                Navigator.pop(context);
                _editMedication(medication);
              },
            ),
            ListTile(
              leading: Icon(medication.isActive ? Icons.pause : Icons.play_arrow),
              title: Text(medication.isActive ? '暂停用药' : '恢复用药'),
              onTap: () {
                Navigator.pop(context);
                _toggleMedicationActive(medication);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除药物', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMedication(medication);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMedication() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MedicationFormScreen()),
    );

    if (result == true) {
      _loadMedications();
    } else if (result is Map && result['needReminder'] == true) {
      _loadMedications();
      await _showAddReminderDialog(result['medicationId']);
    }
  }

  Future<void> _showAddReminderDialog(int medicationId) async {
    final medications = await DatabaseService.instance.getActiveMedications();
    final remindersByMed = await DatabaseService.instance.getRemindersByMedication();
    final newMedication = medications.firstWhere((m) => m.id == medicationId,
      orElse: () => Medication(name: '新药物', dosage: '', createdAt: DateTime.now()));

    // 过滤出有提醒的药物（排除刚添加的这个）
    final medicationsWithReminders = medications.where((m) =>
      m.id != medicationId && remindersByMed.containsKey(m.id) && remindersByMed[m.id]!.isNotEmpty
    ).toList();

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text('为「${newMedication.name}」添加提醒'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (medicationsWithReminders.isNotEmpty) ...[
                  const Text('与已有药物共用提醒时间：', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...medicationsWithReminders.map((m) => ListTile(
                    dense: true,
                    title: Text(m.name),
                    subtitle: Text('${remindersByMed[m.id]!.length} 个提醒'),
                    trailing: const Icon(Icons.copy, size: 20),
                    onTap: () async {
                      // 复制提醒到新药物
                      for (final reminder in remindersByMed[m.id]!) {
                        final newReminder = Reminder(
                          medicationId: medicationId,
                          time: reminder.time,
                          frequency: reminder.frequency,
                          frequencyDetails: reminder.frequencyDetails,
                          message: reminder.message,
                          isActive: true,
                          createdAt: DateTime.now(),
                        );
                        await DatabaseService.instance.saveReminder(newReminder);
                      }
                      // dialog context 在 async 后使用对于 dialog pop 是安全的
                      // ignore: use_build_context_synchronously
                      Navigator.pop(dialogContext);
                    },
                  )),
                  const Divider(),
                ],
                if (medicationsWithReminders.isEmpty)
                  const Text('暂无其他药物的提醒可供共用'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('稍后添加'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (!mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReminderFormScreen(medicationId: medicationId)),
              );
              if (!mounted) return;
              _loadMedications();
            },
            child: const Text('添加新提醒'),
          ),
        ],
      ),
    );
  }

  Future<void> _editMedication(Medication medication) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicationFormScreen(medication: medication),
      ),
    );
    if (result == true) _loadMedications();
  }

  Future<void> _toggleMedicationActive(Medication medication) async {
    medication.isActive = !medication.isActive;
    await DatabaseService.instance.saveMedication(medication);

    if (!medication.isActive) {
      await ReminderScheduler.instance.cancelAllRemindersForMedication(medication.id);
    } else {
      final reminders = await DatabaseService.instance.getRemindersForMedication(medication.id);
      for (final reminder in reminders) {
        if (reminder.isActive) {
          await ReminderScheduler.instance.scheduleReminderNotification(reminder, medication);
        }
      }
    }

    _loadMedications();
  }

  Future<void> _deleteMedication(Medication medication) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 "${medication.name}" 及其所有相关提醒和记录吗？'),
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
      await ReminderScheduler.instance.cancelAllRemindersForMedication(medication.id);
      await DatabaseService.instance.deleteMedication(medication.id);
      _loadMedications();
    }
  }
}