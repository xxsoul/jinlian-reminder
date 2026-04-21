import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'medication_form_screen.dart';
import 'reminder_list_screen.dart';

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
    if (result == true) _loadMedications();
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