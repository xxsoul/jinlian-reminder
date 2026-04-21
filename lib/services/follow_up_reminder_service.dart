import '../models/models.dart';
import 'database_service.dart';
import 'notification_service.dart';
import 'reminder_scheduler.dart';

/// 复诊提醒服务
/// 负责管理复诊提醒的生成、调度和确认
class FollowUpReminderService {
  static final FollowUpReminderService instance = FollowUpReminderService._();
  FollowUpReminderService._();

  /// 初始化：检查所有有复诊日期的药物，创建复诊提醒
  Future<void> initializeFollowUpReminders() async {
    final medications = await DatabaseService.instance.getActiveMedications();

    for (final medication in medications) {
      if (medication.hasFollowUpDate && medication.followUpDate != null) {
        await _checkAndCreateFollowUpAlert(medication);
      }
    }
  }

  /// 检查并创建复诊提醒
  Future<void> _checkAndCreateFollowUpAlert(Medication medication) async {
    if (!medication.hasFollowUpDate || medication.followUpDate == null) {
      return;
    }

    final followUpDate = medication.followUpDate!;
    final now = DateTime.now();

    // 如果已经过了复诊日期，不需要创建提醒
    if (now.isAfter(followUpDate)) {
      return;
    }

    // 检查是否已经存在未确认的复诊提醒
    final existingAlerts = await DatabaseService.instance.getPendingFollowUpAlerts();
    final existingAlert = existingAlerts.where(
      (alert) => alert.medicationId == medication.id,
    ).firstOrNull;

    if (existingAlert != null) {
      return;
    }

    // 创建复诊提醒（提前 7 天提醒）
    final alertDate = followUpDate.subtract(const Duration(days: 7));

    // 如果提醒日期已经过去，立即发送提醒
    if (alertDate.isBefore(now)) {
      await _sendFollowUpNotification(medication, followUpDate);
    } else {
      // 调度未来的提醒
      await _scheduleFollowUpAlert(medication, alertDate);
    }
  }

  /// 调度复诊提醒
  Future<void> _scheduleFollowUpAlert(Medication medication, DateTime alertDate) async {
    final alert = FollowUpAlert(
      medicationId: medication.id,
      followUpDate: medication.followUpDate!,
      alertDate: alertDate,
      message: '您将在 ${_formatDate(medication.followUpDate!)} 复诊，请提前安排时间',
      createdAt: DateTime.now(),
    );

    await DatabaseService.instance.saveFollowUpAlert(alert);

    // 调度通知
    await NotificationService.instance.scheduleNotification(
      id: _getFollowUpAlertId(medication.id),
      title: '复诊提醒',
      body: alert.message,
      scheduledTime: alertDate,
      payload: 'follow_up:${medication.id}',
    );
  }

  /// 发送复诊通知
  Future<void> _sendFollowUpNotification(Medication medication, DateTime followUpDate) async {
    final daysUntil = followUpDate.difference(DateTime.now()).inDays;
    final message = daysUntil <= 0
        ? '您需要在 ${_formatDate(followUpDate)} 复诊，请尽快安排时间'
        : '距离复诊还有 $daysUntil 天，复诊日期：${_formatDate(followUpDate)}';

    await NotificationService.instance.showNotification(
      id: _getFollowUpAlertId(medication.id),
      title: '复诊提醒',
      body: message,
      payload: 'follow_up:${medication.id}',
    );

    // 更新提醒状态
    final alerts = await DatabaseService.instance.getPendingFollowUpAlerts();
    final alert = alerts.where((a) => a.medicationId == medication.id).firstOrNull;
    if (alert != null) {
      alert.hasAlerted = true;
      await DatabaseService.instance.saveFollowUpAlert(alert);
    }
  }

  /// 确认复诊完成
  /// 确认后会：
  /// 1. 标记复诊提醒为已确认
  /// 2. 根据复诊日期重新计算新的用药周期（如果需要继续用药）
  Future<void> confirmFollowUpCompleted(int medicationId) async {
    final medication = await DatabaseService.instance.getMedication(medicationId);
    if (medication == null) return;

    // 标记提醒为已确认
    final alerts = await DatabaseService.instance.getAllFollowUpAlerts();
    final alert = alerts.where((a) => a.medicationId == medicationId).firstOrNull;
    if (alert != null) {
      alert.isConfirmed = true;
      await DatabaseService.instance.saveFollowUpAlert(alert);
    }
  }

  /// 检查并处理到期的复诊提醒
  Future<void> checkDueFollowUpAlerts() async {
    final now = DateTime.now();
    final alerts = await DatabaseService.instance.getPendingFollowUpAlerts();

    for (final alert in alerts) {
      // 检查是否到了提醒日期
      if (alert.alertDate.isBefore(now) || alert.alertDate.isAtSameMomentAs(now)) {
        if (!alert.hasAlerted) {
          final medication = await DatabaseService.instance.getMedication(alert.medicationId);
          if (medication != null && medication.isActive) {
            await _sendFollowUpNotification(medication, alert.followUpDate);
          }
        }
      }
    }
  }

  /// 检查非复诊模式的截止日期
  /// 如果当前时间超过截止日期，停用药物和提醒
  Future<void> checkEndDateForNonFollowUpMedications() async {
    final medications = await DatabaseService.instance.getActiveMedications();

    for (final medication in medications) {
      if (!medication.hasFollowUpDate && medication.endDate != null) {
        if (DateTime.now().isAfter(medication.endDate!)) {
          // 停用药物
          medication.isActive = false;
          await DatabaseService.instance.saveMedication(medication);

          // 取消所有提醒
          await ReminderScheduler.instance.cancelAllRemindersForMedication(medication.id);

          // 发送通知
          await NotificationService.instance.showNotification(
            id: medication.id + 10000, // 使用不同的 ID 范围
            title: '用药已结束',
            body: '${medication.name} 已达到截止日期 (${_formatDate(medication.endDate!)}), 请停药',
          );
        }
      }
    }
  }

  /// 更新药物的复诊信息
  /// 当用户修改复诊日期时调用
  Future<void> updateFollowUpDate(Medication medication, DateTime? newFollowUpDate) async {
    // 删除旧的提醒
    final alerts = await DatabaseService.instance.getAllFollowUpAlerts();
    for (final alert in alerts.where((a) => a.medicationId == medication.id)) {
      await NotificationService.instance.cancelNotification(_getFollowUpAlertId(alert.id));
      await DatabaseService.instance.deleteFollowUpAlert(alert.id);
    }

    // 如果设置了新的复诊日期，创建新提醒
    if (newFollowUpDate != null) {
      medication.followUpDate = newFollowUpDate;
      medication.hasFollowUpDate = true;
      await _checkAndCreateFollowUpAlert(medication);
    }
  }

  /// 生成复诊提醒 ID（使用药物 ID 避免冲突）
  int _getFollowUpAlertId(int medicationId) {
    return medicationId + 10000;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}