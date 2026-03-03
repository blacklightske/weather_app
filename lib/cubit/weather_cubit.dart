import 'package:cubit_weather_app/cubit/weather_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/weather_repository.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;

  CancelToken? _cancelToken; // ✅ track current request

  WeatherCubit({required this.repository}) : super(const WeatherState());

  Future<void> fetchWeather(String city) async {
    // ✅ Cancel previous request (if any)
    _cancelToken?.cancel('New search started');
    _cancelToken = CancelToken();

    try {
      emit(state.copyWith(status: WeatherStatus.loading, errorMessage: null));

      final weather = await repository.getWeather(
        city,
        cancelToken: _cancelToken, // ✅ pass token
      );

      emit(state.copyWith(status: WeatherStatus.loaded, data: weather));
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

  @override
  Future<void> close() {
    _cancelToken?.cancel('Cubit closed');
    return super.close();
  }
}
