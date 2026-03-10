import 'package:cubit_weather_app/services/app_preferences.dart';
import 'package:cubit_weather_app/theme/theme_cubit.dart';
import 'package:cubit_weather_app/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/weather_cubit.dart';
import 'models/weather_data.dart';
import 'repository/weather_repository.dart';
import 'screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final appPreferences = AppPreferences(prefs);
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();

  Hive.registerAdapter(WeatherDataAdapter());

  await Hive.openBox<WeatherData>('weatherBox');

  runApp(MyApp(appPreferences: appPreferences));
}

class MyApp extends StatelessWidget {
  final AppPreferences appPreferences;

  const MyApp({super.key, required this.appPreferences});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(appPreferences)..loadTheme(),
        ),
        BlocProvider<WeatherCubit>(
          create: (_) => WeatherCubit(
            repository: WeatherRepository(),
            preferences: appPreferences,
          )..loadLastCity(),
        ),
      ],

      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const WeatherScreen(),
          );
        },
      ),
    );
  }
}
