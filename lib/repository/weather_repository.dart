// weather_repository.dart
import 'package:dio/dio.dart';

import '../models/weather_data.dart';

class WeatherRepository {
  final Dio dio;

  WeatherRepository({Dio? dioClient}) : dio = dioClient ?? Dio();

  Future<WeatherData> getWeather(
    String city, {
    CancelToken? cancelToken,
  }) async {
    final apiKey = 'a7f1d20deb149d91037703e62a8dee14';
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
