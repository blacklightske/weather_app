import 'package:cubit_weather_app/cubit/weather_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/weather_data.dart';
import '../repository/weather_repository.dart';
import '../services/app_preferences.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  final AppPreferences preferences;
  final List<String> counties = [
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Nakuru',
    'Eldoret',
  ];

  CancelToken? _cancelToken; // ✅ track current request

  WeatherCubit({required this.repository, required this.preferences})
    : super(const WeatherState());

  Future<void> fetchWeather(String city) async {
    await preferences.saveLastCity(city);
    // ✅ Cancel previous request (if any)
    _cancelToken?.cancel('New search started');
    _cancelToken = CancelToken();

    try {
      emit(state.copyWith(status: WeatherStatus.loading, errorMessage: null));

      final weather = await repository.getWeather(
        city,
        cancelToken: _cancelToken, // ✅ pass token
      );

      await repository.cacheWeather(weather);

      final updated = List<WeatherData>.from(state.items);
      final index = updated.indexWhere(
        (item) => item.city.toLowerCase() == city.toLowerCase(),
      );
      if (index == -1) {
        updated.add(weather);
        print('not found ');
      } else {
        updated[index] = weather;
      }
      emit(
        state.copyWith(
          status: WeatherStatus.loaded,
          data: weather,
          items: updated,
        ),
      );
    } on DioException catch (e) {
      print('DIO ERROR TYPE: ${e.type}');
      print('DIO CANCEL? ${CancelToken.isCancel(e)}');
      print('DIO MESSAGE: ${e.message}');
      // ✅ If this error is from cancellation, ignore it (no error UI)
      if (CancelToken.isCancel(e)) return;
      emit(
        state.copyWith(status: WeatherStatus.error, errorMessage: e.toString()),
      );
    } catch (e) {
      emit(
        state.copyWith(status: WeatherStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> loadCounties() async {
    emit(state.copyWith(status: WeatherStatus.loading, errorMessage: null));

    final List<WeatherData> results = [];

    for (final city in counties) {
      try {
        // 1) try cache
        final cached = repository.getCachedCity(city);
        if (cached != null) {
          results.add(cached);
          continue;
        }

        // 2) fetch if missing
        final fresh = await repository.getWeather(city);

        // 3) cache it
        await repository.cacheWeather(fresh);

        results.add(fresh);
      } catch (_) {
        // ✅ ignore failures for this city only
      }
    }

    emit(state.copyWith(status: WeatherStatus.loaded, items: results));
  }

  void showCounties() {
    emit(
      state.copyWith(
        status: WeatherStatus.loaded,
        clearData: true,
        // keep items as-is
      ),
    );
  }

  Future<void> refreshCity(String city) async {
    final fresh = await repository.getWeather(city);
    await repository.cacheWeather(fresh);
    final updated = List<WeatherData>.from(state.items);
    final index = updated.indexWhere(
      (item) => item.city.toLowerCase() == city.toLowerCase(),
    );
    if (index == -1) {
      updated.add(fresh);
      print('not found ');
    } else {
      updated[index] = fresh;
    }
    emit(state.copyWith(status: WeatherStatus.loaded, items: updated));
  }

  Future<void> loadLastCity() async {
    final city = await preferences.getLastCity();

    if (city != null) {
      await fetchWeather(city);
    }
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel('Cubit closed');
    return super.close();
  }
}
