import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences prefs;

  AppPreferences(this.prefs);

  static const String lastCityKey = 'last_city';
  static const String isDarkModeKey = 'is_dark_mode';

  Future<void> saveLastCity(String city) async {
    await prefs.setString(lastCityKey, city);
  }

  Future<String?> getLastCity() async {
    return prefs.getString(lastCityKey);
  }

  Future<void> saveTheme(bool isDark) async {
    await prefs.setBool(isDarkModeKey, isDark);
  }

  Future<bool> getTheme() async {
    return prefs.getBool(isDarkModeKey) ?? false;
  }
}
