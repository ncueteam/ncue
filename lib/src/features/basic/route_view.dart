import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/settings/settings_controller.dart';

import '../settings/settings_service.dart';

abstract class RouteView extends StatefulWidget {
  final String routeName;
  final IconData routeIcon;
  static final SettingsController settingsController =
      SettingsController(SettingsService());
  static Future<void> loadRouteViewSettings() async {
    await settingsController.loadSettings();
  }

  const RouteView({Key? key, required this.routeName, required this.routeIcon})
      : super(key: key);
}
