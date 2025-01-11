// Guardé este archivo en: D:\06MASW-A1\en_mi_ciudad\lib\utils\shared_prefs_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String keyLastCity = 'lastCity';
  static const String keyDarkMode = 'darkMode';

  /// Guardé la última ciudad consultada en SharedPreferences
  static Future<void> saveLastCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastCity, cityName);
  }

  /// Recuperé la última ciudad (o null si no estaba definida)
  static Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLastCity);
  }

  /// Guardé el flag de modo oscuro (true/false)
  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkMode, isDark);
  }

  /// Recuperé el modo oscuro (por defecto configuré false)
  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDarkMode) ?? false;
  }
}
