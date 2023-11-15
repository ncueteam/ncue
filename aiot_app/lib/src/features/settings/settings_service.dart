import 'dart:io';
import 'package:flutter/material.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<String> locale() async => Platform.localeName;

  Future<void> updateThemeMode(ThemeMode theme) async {}

  Future<void> updateLocale(String locale) async {}
}
