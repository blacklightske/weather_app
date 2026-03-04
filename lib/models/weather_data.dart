import 'package:hive/hive.dart';

part 'weather_data.g.dart';

@HiveType(typeId: 0)
class WeatherData extends HiveObject {
  @HiveField(0)
  final String city;

  @HiveField(1)
  final double temperature;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int humidity;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.description,
    required this.humidity,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
    );
  }
}
