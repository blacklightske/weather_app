import 'package:hive/hive.dart';

import 'weather_data.dart';

class WeatherDataAdapter extends TypeAdapter<WeatherData> {
  @override
  final int typeId = 0;

  @override
  WeatherData read(BinaryReader reader) {
    final temperature = reader.readDouble();
    final description = reader.readString();
    final timestamp = reader.readString();

    return WeatherData(
      temperature: temperature,
      description: description,
      timestamp: timestamp,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherData obj) {
    writer.writeDouble(obj.temperature);
    writer.writeString(obj.description);
    writer.writeInt(obj.timestamp as int);
  }
}
