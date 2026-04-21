import 'package:isar/isar.dart';

part 'medication.g.dart';

/// 药物模型
@collection
class Medication {
  Id id = Isar.autoIncrement;

  String name;
  String dosage;
  String? instructions;
  bool hasFollowUpDate;
  DateTime? followUpDate;
  DateTime? endDate;
  DateTime createdAt;
  bool isActive;

  Medication({
    required this.name,
    required this.dosage,
    this.instructions,
    this.hasFollowUpDate = false,
    this.followUpDate,
    this.endDate,
    required this.createdAt,
    this.isActive = true,
  });
}