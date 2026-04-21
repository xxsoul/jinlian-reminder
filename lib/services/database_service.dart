import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MedicationSchema, ReminderSchema, FollowUpAlertSchema, MedicationLogSchema],
      directory: dir.path,
    );
  }

  // Medication operations
  Future<List<Medication>> getAllMedications() async {
    return await isar.medications.where().findAll();
  }

  Future<List<Medication>> getActiveMedications() async {
    return await isar.medications.where().filter().isActiveEqualTo(true).findAll();
  }

  Future<Medication?> getMedication(int id) async {
    return await isar.medications.get(id);
  }

  Future<int> saveMedication(Medication medication) async {
    return await isar.writeTxn(() async {
      return await isar.medications.put(medication);
    });
  }

  Future<bool> deleteMedication(int id) async {
    return await isar.writeTxn(() async {
      await isar.reminders.filter().medicationIdEqualTo(id).deleteAll();
      await isar.followUpAlerts.filter().medicationIdEqualTo(id).deleteAll();
      await isar.medicationLogs.filter().medicationIdEqualTo(id).deleteAll();
      return await isar.medications.delete(id);
    });
  }

  // Reminder operations
  Future<List<Reminder>> getAllReminders() async {
    return await isar.reminders.where().findAll();
  }

  Future<List<Reminder>> getActiveReminders() async {
    return await isar.reminders.where().filter().isActiveEqualTo(true).findAll();
  }

  Future<List<Reminder>> getRemindersForMedication(int medicationId) async {
    return await isar.reminders.where().filter().medicationIdEqualTo(medicationId).findAll();
  }

  Future<Reminder?> getReminder(int id) async {
    return await isar.reminders.get(id);
  }

  Future<int> saveReminder(Reminder reminder) async {
    return await isar.writeTxn(() async {
      return await isar.reminders.put(reminder);
    });
  }

  Future<bool> deleteReminder(int id) async {
    return await isar.writeTxn(() async {
      return await isar.reminders.delete(id);
    });
  }

  Future<void> updateReminderNextTrigger(int id, DateTime? nextTrigger) async {
    await isar.writeTxn(() async {
      final reminder = await isar.reminders.get(id);
      if (reminder != null) {
        reminder.nextTriggerTime = nextTrigger;
        await isar.reminders.put(reminder);
      }
    });
  }

  // FollowUpAlert operations
  Future<List<FollowUpAlert>> getAllFollowUpAlerts() async {
    return await isar.followUpAlerts.where().findAll();
  }

  Future<List<FollowUpAlert>> getPendingFollowUpAlerts() async {
    return await isar.followUpAlerts.where()
      .filter()
      .hasAlertedEqualTo(false)
      .and()
      .isConfirmedEqualTo(false)
      .findAll();
  }

  Future<FollowUpAlert?> getFollowUpAlert(int id) async {
    return await isar.followUpAlerts.get(id);
  }

  Future<int> saveFollowUpAlert(FollowUpAlert alert) async {
    return await isar.writeTxn(() async {
      return await isar.followUpAlerts.put(alert);
    });
  }

  Future<bool> deleteFollowUpAlert(int id) async {
    return await isar.writeTxn(() async {
      return await isar.followUpAlerts.delete(id);
    });
  }

  Future<void> markFollowUpAlerted(int id) async {
    await isar.writeTxn(() async {
      final alert = await isar.followUpAlerts.get(id);
      if (alert != null) {
        alert.hasAlerted = true;
        await isar.followUpAlerts.put(alert);
      }
    });
  }

  Future<void> confirmFollowUp(int id) async {
    await isar.writeTxn(() async {
      final alert = await isar.followUpAlerts.get(id);
      if (alert != null) {
        alert.isConfirmed = true;
        await isar.followUpAlerts.put(alert);
      }
    });
  }

  // MedicationLog operations
  Future<List<MedicationLog>> getAllLogs() async {
    return await isar.medicationLogs.where().findAll();
  }

  Future<List<MedicationLog>> getLogsForMedication(int medicationId) async {
    return await isar.medicationLogs.where().filter().medicationIdEqualTo(medicationId).findAll();
  }

  Future<List<MedicationLog>> getLogsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return await isar.medicationLogs.where()
      .filter()
      .scheduledTimeBetween(start, end)
      .findAll();
  }

  Future<List<MedicationLog>> getTodayLogs() async {
    return await getLogsForDate(DateTime.now());
  }

  Future<int> saveLog(MedicationLog log) async {
    return await isar.writeTxn(() async {
      return await isar.medicationLogs.put(log);
    });
  }

  Future<void> markLogTaken(int id, DateTime? actualTime) async {
    await isar.writeTxn(() async {
      final log = await isar.medicationLogs.get(id);
      if (log != null) {
        log.status = MedicationLogStatus.taken;
        log.actualTime = actualTime ?? DateTime.now();
        await isar.medicationLogs.put(log);
      }
    });
  }

  Future<void> markLogSkipped(int id, String? notes) async {
    await isar.writeTxn(() async {
      final log = await isar.medicationLogs.get(id);
      if (log != null) {
        log.status = MedicationLogStatus.skipped;
        log.notes = notes;
        await isar.medicationLogs.put(log);
      }
    });
  }
}