import 'package:cubit_weather_app/models/weather_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'cubit/weather_cubit.dart';
import 'models/weather_data_adapter.dart';
import 'repository/weather_repository.dart';
import 'screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(WeatherDataAdapter());

  await Hive.openBox<WeatherData>('weatherBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(repository: WeatherRepository()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WeatherScreen(),
      ),
    );
  }
}
