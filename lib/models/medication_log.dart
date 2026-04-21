import 'package:isar/isar.dart';

part 'medication_log.g.dart';

enum MedicationLogStatus {
  taken,
  skipped,
  missed,
}

@collection
class MedicationLog {
  Id id = Isar.autoIncrement;

  int medicationId;
  int? reminderId;
  DateTime scheduledTime;
  DateTime? actualTime;
  @enumerated
  MedicationLogStatus status;
  String? notes;
  DateTime createdAt;

  MedicationLog({
    required this.medicationId,
    this.reminderId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    this.notes,
    required this.createdAt,
  });
}