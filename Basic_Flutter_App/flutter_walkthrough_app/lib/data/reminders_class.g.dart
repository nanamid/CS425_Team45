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
    return ReminderManager();
  }

  @override
  void write(BinaryWriter writer, ReminderManager obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._alarmIDToReminder)
      ..writeByte(1)
      ..write(obj._notificationIDToReminder)
      ..writeByte(2)
      ..write(obj._allReminders)
      ..writeByte(3)
      ..write(obj._remindersWithPersistentNotifications)
      ..writeByte(4)
      ..write(obj._remindersWithEndNotifications)
      ..writeByte(5)
      ..write(obj._remindersWithAlarms);
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
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._timerStartTime)
      ..writeByte(1)
      ..write(obj._timerEndTime);
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
