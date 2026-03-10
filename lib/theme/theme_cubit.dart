import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/app_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final AppPreferences preferences;

  ThemeCubit(this.preferences) : super(const ThemeState(isDarkMode: false));

  Future<void> loadTheme() async {
    final isDark = await preferences.getTheme();

    emit(ThemeState(isDarkMode: isDark));
  }

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;

    await preferences.saveTheme(newValue);

    emit(ThemeState(isDarkMode: newValue));
  }
}
