import 'package:hive/hive.dart';

/*// part 'weather_data.g.dart';*/

@HiveType(typeId: 0)
class WeatherData {
  @HiveField(0)
  final double temperature;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String timestamp;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.timestamp,
  });

  // factory constructor to convert json from api into weatherdata
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      timestamp: DateTime.now().toString(),
    );
  }
}
