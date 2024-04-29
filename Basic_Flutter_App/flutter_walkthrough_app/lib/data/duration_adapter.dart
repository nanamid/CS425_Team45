import 'package:hive/hive.dart';

// copied from https://github.com/isar/hive/issues/794
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 7; // or whatever free id you have

  @override
  Duration read(BinaryReader reader) {
    return Duration(seconds: reader.read());
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.write(obj.inSeconds);
  }
}
