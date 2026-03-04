// weather_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

import '../models/weather_data.dart';

class WeatherRepository {
  final Dio dio;
  final Box<WeatherData> box = Hive.box<WeatherData>('weatherBox');

  WeatherRepository({Dio? dioClient}) : dio = dioClient ?? Dio();

  Future<void> cacheWeather(WeatherData data) async {
    // key = city name (lowercase) to avoid duplicates like "Nairobi" vs "nairobi"
    await box.put(data.city.toLowerCase(), data);
  }

  WeatherData? getCachedCity(String city) {
    return box.get(city.toLowerCase());
  }

  List<WeatherData> getAllCached() {
    return box.values.toList();
  }

  Future<void> deleteCity(String city) async {
    await box.delete(city.toLowerCase());
  }

  Future<WeatherData> getWeather(
    String city, {
    CancelToken? cancelToken,
  }) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await dio.get(
        url,
        cancelToken: cancelToken, // ✅ add this
      );
      return WeatherData.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }
}
