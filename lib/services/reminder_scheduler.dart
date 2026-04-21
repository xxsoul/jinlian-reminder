import '../models/models.dart';
import 'database_service.dart';
import 'notification_service.dart';

class ReminderScheduler {
  static final ReminderScheduler instance = ReminderScheduler._();
  ReminderScheduler._();

  /// 计算下次触发时间
  DateTime? calculateNextTriggerTime(Reminder reminder) {
    final now = DateTime.now();
    final timeParts = reminder.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    DateTime baseTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (baseTime.isBefore(now)) {
      baseTime = baseTime.add(const Duration(days: 1));
    }

    switch (reminder.frequency) {
      case ReminderFrequency.daily:
        return _findNextDailyTime(baseTime, now);
      case ReminderFrequency.weekly:
        return _findNextWeeklyTime(reminder, baseTime, now);
      case ReminderFrequency.monthly:
        return _findNextMonthlyTime(reminder, baseTime, now);
      case ReminderFrequency.interval:
        return _findNextIntervalTime(reminder, baseTime, now);
    }
  }

  DateTime? _findNextDailyTime(DateTime baseTime, DateTime now) {
    if (baseTime.isAfter(now)) {
      return baseTime;
    }
    return baseTime.add(const Duration(days: 1));
  }

  DateTime? _findNextWeeklyTime(Reminder reminder, DateTime baseTime, DateTime now) {
    if (reminder.frequencyDetails == null) return null;

    final weekdays = reminder.frequencyDetails!.split(',').map(int.parse).toList();
    // Dart 中周一是 1，周日是 7
    int currentWeekday = now.weekday;

    // 从今天开始找下一个匹配的星期
    for (int i = 0; i <= 7; i++) {
      int checkDay = currentWeekday + i;
      if (checkDay > 7) checkDay -= 7;

      if (weekdays.contains(checkDay)) {
        DateTime candidate = now.add(Duration(days: i));
        candidate = DateTime(candidate.year, candidate.month, candidate.day, baseTime.hour, baseTime.minute);
        if (candidate.isAfter(now)) {
          return candidate;
        }
      }
    }
    return null;
  }

  DateTime? _findNextMonthlyTime(Reminder reminder, DateTime baseTime, DateTime now) {
    if (reminder.frequencyDetails == null) return null;

    final days = reminder.frequencyDetails!.split(',').map(int.parse).toList();

    // 检查本月剩余的日期
    for (int day in days) {
      if (day > 31 || day < 1) continue;

      DateTime candidate = DateTime(now.year, now.month, day, baseTime.hour, baseTime.minute);
      if (candidate.isAfter(now)) {
        return candidate;
      }
    }

    // 检查下个月的日期
    int nextMonth = now.month + 1;
    int nextYear = now.year;
    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear++;
    }

    for (int day in days) {
      if (day > 31 || day < 1) continue;

      // 确保日期在下个月有效
      int lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
      int validDay = day > lastDayOfNextMonth ? lastDayOfNextMonth : day;

      DateTime candidate = DateTime(nextYear, nextMonth, validDay, baseTime.hour, baseTime.minute);
      if (candidate.isAfter(now)) {
        return candidate;
      }
    }

    return null;
  }

  DateTime? _findNextIntervalTime(Reminder reminder, DateTime baseTime, DateTime now) {
    if (reminder.frequencyDetails == null) return null;

    final intervalDays = int.parse(reminder.frequencyDetails!);
    if (intervalDays <= 0) return null;

    // 从上次触发时间或创建时间计算
    DateTime startTime = reminder.nextTriggerTime ?? reminder.createdAt;
    DateTime candidate = startTime;

    while (candidate.isBefore(now) || candidate.isAtSameMomentAs(now)) {
      candidate = candidate.add(Duration(days: intervalDays));
    }

    // 设置正确的小时和分钟
    candidate = DateTime(candidate.year, candidate.month, candidate.day, baseTime.hour, baseTime.minute);
    if (candidate.isBefore(now)) {
      candidate = candidate.add(Duration(days: intervalDays));
    }

    return candidate;
  }

  /// 为提醒调度通知
  Future<void> scheduleReminderNotification(Reminder reminder, Medication medication) async {
    if (!reminder.isActive) return;

    final nextTrigger = calculateNextTriggerTime(reminder);
    if (nextTrigger == null) return;

    // 更新下次触发时间
    reminder.nextTriggerTime = nextTrigger;
    await DatabaseService.instance.saveReminder(reminder);

    // 调度通知
    await NotificationService.instance.scheduleNotification(
      id: reminder.id,
      title: '药物提醒',
      body: '${medication.name} - ${reminder.message}',
      scheduledTime: nextTrigger,
      payload: '${reminder.id}',
    );
  }

  /// 初始化所有活跃提醒
  Future<void> initializeAllReminders() async {
    final reminders = await DatabaseService.instance.getActiveReminders();
    final medications = await DatabaseService.instance.getActiveMedications();

    for (final reminder in reminders) {
      final medication = medications.firstWhere(
        (m) => m.id == reminder.medicationId,
        orElse: () => throw Exception('Medication not found'),
      );

      if (reminder.nextTriggerTime == null ||
          reminder.nextTriggerTime!.isBefore(DateTime.now())) {
        await scheduleReminderNotification(reminder, medication);
      }
    }
  }

  /// 处理提醒触发后的回调（创建服药记录、更新下次触发时间）
  Future<void> handleReminderTriggered(int reminderId) async {
    final reminder = await DatabaseService.instance.getReminder(reminderId);
    if (reminder == null) return;

    final medication = await DatabaseService.instance.getMedication(reminder.medicationId);
    if (medication == null || !medication.isActive) return;

    // 检查是否需要停止（非复诊模式且有截止日期）
    if (!medication.hasFollowUpDate && medication.endDate != null) {
      if (DateTime.now().isAfter(medication.endDate!)) {
        reminder.isActive = false;
        await DatabaseService.instance.saveReminder(reminder);
        return;
      }
    }

    // 创建服药记录
    final log = MedicationLog(
      medicationId: medication.id,
      reminderId: reminder.id,
      scheduledTime: reminder.nextTriggerTime ?? DateTime.now(),
      status: MedicationLogStatus.missed,
      createdAt: DateTime.now(),
    );
    await DatabaseService.instance.saveLog(log);

    // 计算并调度下次提醒
    await scheduleReminderNotification(reminder, medication);
  }

  /// 取消提醒通知
  Future<void> cancelReminderNotification(int reminderId) async {
    await NotificationService.instance.cancelNotification(reminderId);
  }

  /// 取消药物的所有提醒
  Future<void> cancelAllRemindersForMedication(int medicationId) async {
    final reminders = await DatabaseService.instance.getRemindersForMedication(medicationId);
    for (final reminder in reminders) {
      await cancelReminderNotification(reminder.id);
    }
  }
}