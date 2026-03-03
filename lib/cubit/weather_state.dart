import '../models/weather_data.dart';

enum WeatherStatus { loading, initial, loaded, error }

class WeatherState {
  final WeatherStatus status;
  final WeatherData? data; //hold api response
  final String? errorMessage;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.data,
    this.errorMessage,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherData? data,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
