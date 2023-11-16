import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<String> locale() async {
    return Platform.localeName;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {}

  Future<void> updateLocale(String locale) async {
    UserModel user = RouteView.model;
    user.language = locale;
    await user.update();
  }
}
