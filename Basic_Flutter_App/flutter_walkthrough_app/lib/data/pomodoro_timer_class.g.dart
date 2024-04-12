// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_timer_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroTimerAdapter extends TypeAdapter<PomodoroTimer> {
  @override
  final int typeId = 4;

  @override
  PomodoroTimer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroTimer(
      duration: fields[0] as Duration,
    )
      .._timerIsRunning = fields[1] as bool
      .._timerStartTime = fields[2] as DateTime?
      .._timerEndTime = fields[3] as DateTime?
      ..remaningTime = fields[4] as Duration;
  }

  @override
  void write(BinaryWriter writer, PomodoroTimer obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(1)
      ..write(obj._timerIsRunning)
      ..writeByte(2)
      ..write(obj._timerStartTime)
      ..writeByte(3)
      ..write(obj._timerEndTime)
      ..writeByte(4)
      ..write(obj.remaningTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroTimerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}