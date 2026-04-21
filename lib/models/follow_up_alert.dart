import 'package:isar/isar.dart';

part 'follow_up_alert.g.dart';

@collection
class FollowUpAlert {
  Id id = Isar.autoIncrement;

  int medicationId;
  DateTime followUpDate;
  DateTime alertDate;
  String message;
  bool hasAlerted;
  bool isConfirmed;
  DateTime createdAt;

  FollowUpAlert({
    required this.medicationId,
    required this.followUpDate,
    required this.alertDate,
    required this.message,
    this.hasAlerted = false,
    this.isConfirmed = false,
    required this.createdAt,
  });
}