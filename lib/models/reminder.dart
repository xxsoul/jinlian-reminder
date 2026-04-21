import 'package:isar/isar.dart';

part 'reminder.g.dart';

enum ReminderFrequency {
  daily,
  weekly,
  monthly,
  interval,
  intervalHours,
}

@collection
class Reminder {
  Id id = Isar.autoIncrement;

  int medicationId;
  String time;
  @enumerated
  ReminderFrequency frequency;
  String? frequencyDetails;
  String message;
  DateTime? nextTriggerTime;
  bool isActive;
  DateTime createdAt;

  Reminder({
    this.id = Isar.autoIncrement,
    required this.medicationId,
    required this.time,
    required this.frequency,
    this.frequencyDetails,
    required this.message,
    this.nextTriggerTime,
    this.isActive = true,
    required this.createdAt,
  });
}