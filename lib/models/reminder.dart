import 'package:isar/isar.dart';

part 'reminder.g.dart';

enum ReminderFrequency {
  daily,
  weekly,
  monthly,
  interval,
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