import '../models/weather_data.dart';

enum WeatherStatus { loading, initial, loaded, error }

class WeatherState {
  final WeatherStatus status;
  final WeatherData? data; //hold api response
  final List<WeatherData> items;
  final String? errorMessage;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.data,
    this.items = const [], // VERY IMPORTANT default
    this.errorMessage,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherData? data,
    List<WeatherData>? items, // NEW
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      data: data ?? this.data,
      items: items ?? this.items, // NEW
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
