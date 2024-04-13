// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminders_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderManagerAdapter extends TypeAdapter<ReminderManager> {
  @override
  final int typeId = 5;

  @override
  ReminderManager read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderManager()
      .._allReminders = (fields[2] as List).cast<Reminder>()
      .._remindersWithPersistentNotifications =
          (fields[3] as List).cast<Reminder>()
      .._remindersWithEndNotifications = (fields[4] as List).cast<Reminder>()
      .._remindersWithAlarms = (fields[5] as List).cast<Reminder>()
      .._taskReminderMap = (fields[6] as Map).cast<Reminder, Task>();
  }

  @override
  void write(BinaryWriter writer, ReminderManager obj) {
    writer
      ..writeByte(5)
      ..writeByte(2)
      ..write(obj._allReminders)
      ..writeByte(3)
      ..write(obj._remindersWithPersistentNotifications)
      ..writeByte(4)
      ..write(obj._remindersWithEndNotifications)
      ..writeByte(5)
      ..write(obj._remindersWithAlarms)
      ..writeByte(6)
      ..write(obj._taskReminderMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderManagerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 6;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      fields[0] as DateTime,
      fields[1] as DateTime,
    ).._reminderUUID = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._timerStartTime)
      ..writeByte(1)
      ..write(obj._timerEndTime)
      ..writeByte(2)
      ..write(obj._reminderUUID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
