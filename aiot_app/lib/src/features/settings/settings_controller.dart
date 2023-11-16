import 'package:flutter/material.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);
  final SettingsService _settingsService;
  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  late String _locale;
  String get locale => _locale;
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _locale = await _settingsService.locale();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
    notifyListeners();
  }

  Future<void> updateLocale(String? newLocale) async {
    if (newLocale == null) {
      // newLocale =
      //     Platform.localeName == "zh_Hant_tw" ? "zh_TW" : Platform.localeName;
      return;
    }
    if (newLocale == _locale) return;
    _locale = newLocale;
    notifyListeners();
    await _settingsService.updateLocale(newLocale);
    notifyListeners();
  }
}
