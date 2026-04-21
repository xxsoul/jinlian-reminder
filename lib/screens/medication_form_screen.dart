import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class MedicationFormScreen extends StatefulWidget {
  final Medication? medication;

  const MedicationFormScreen({super.key, this.medication});

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _instructionsController;

  bool _hasFollowUpDate = false;
  DateTime? _followUpDate;
  bool _hasEndDate = false;
  DateTime? _endDate;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.medication != null;

    _nameController = TextEditingController(text: widget.medication?.name ?? '');
    _dosageController = TextEditingController(text: widget.medication?.dosage ?? '');
    _instructionsController = TextEditingController(text: widget.medication?.instructions ?? '');

    if (widget.medication != null) {
      _hasFollowUpDate = widget.medication!.hasFollowUpDate;
      _followUpDate = widget.medication!.followUpDate;
      if (!widget.medication!.hasFollowUpDate && widget.medication!.endDate != null) {
        _hasEndDate = true;
        _endDate = widget.medication!.endDate;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑药物' : '添加药物'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '药物名称',
                hintText: '如：阿司匹林',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入药物名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: '剂量',
                hintText: '如：1片、10mg',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入剂量';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: '用药说明（可选）',
                hintText: '如：饭后服用',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text('用药周期设置', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('有复诊日期'),
              subtitle: const Text('设置复诊日期，到期时提醒'),
              value: _hasFollowUpDate,
              onChanged: (value) {
                setState(() {
                  _hasFollowUpDate = value;
                  if (value) {
                    _hasEndDate = false;
                    _endDate = null;
                  }
                });
              },
            ),
            if (_hasFollowUpDate) ...[
              ListTile(
                title: Text(_followUpDate == null
                    ? '选择复诊日期'
                    : '复诊日期: ${_formatDate(_followUpDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectFollowUpDate,
              ),
            ],
            if (!_hasFollowUpDate) ...[
              SwitchListTile(
                title: const Text('设置截止日期'),
                subtitle: const Text('非复诊模式，设置用药截止时间'),
                value: _hasEndDate,
                onChanged: (value) {
                  setState(() {
                    _hasEndDate = value;
                  });
                },
              ),
              if (_hasEndDate) ...[
                ListTile(
                  title: Text(_endDate == null
                      ? '选择截止日期'
                      : '截止日期: ${_formatDate(_endDate!)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _selectEndDate,
                ),
              ],
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveMedication,
              child: Text(_isEditing ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectFollowUpDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _followUpDate = date);
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;

    if (_hasFollowUpDate && _followUpDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择复诊日期')),
      );
      return;
    }

    if (_hasEndDate && _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择截止日期')),
      );
      return;
    }

    final medication = Medication(
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      instructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
      hasFollowUpDate: _hasFollowUpDate,
      followUpDate: _hasFollowUpDate ? _followUpDate : null,
      endDate: _hasEndDate ? _endDate : null,
      createdAt: widget.medication?.createdAt ?? DateTime.now(),
      isActive: widget.medication?.isActive ?? true,
    );

    final medicationId = await DatabaseService.instance.saveMedication(medication);

    if (!mounted) return;

    // 如果是编辑模式，直接返回
    if (_isEditing) {
      Navigator.pop(context, true);
      return;
    }

    // 新增模式：返回并携带药物ID，让药物列表页面处理提醒添加
    Navigator.pop(context, {'medicationId': medicationId, 'needReminder': true});
  }
}