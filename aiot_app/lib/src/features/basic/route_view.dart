import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:ncue.aiot_app/src/features/sensors/sensorsapp.dart';
import 'package:ncue.aiot_app/src/features/web_view/webview.dart';

import '../auth_system/password_reset_view.dart';
import '../auth_system/phone_input_view.dart';
import '../auth_system/profile_view.dart';
import '../auth_system/sign_in_view.dart';
import '../auth_system/sms_view.dart';
import '../bluetooth/flutterblueapp.dart';
import '../devices/add_device_view.dart';
import '../devices/device_detail_view.dart';
import '../item_system/item_details_view.dart';
import '../mqtt/mqttapp.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_service.dart';
import '../settings/settings_view.dart';
import 'home_view.dart';

abstract class RouteView extends StatefulWidget {
  final String routeName;
  final IconData routeIcon;
  const RouteView({Key? key, required this.routeName, required this.routeIcon})
      : super(key: key);

  IconButton getIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName,
            arguments: const Home().routeName);
      },
      icon: Icon(routeIcon),
    );
  }

  static final SettingsController settingsController =
      SettingsController(SettingsService());
  static Future<void> loadRouteViewSettings() async {
    await settingsController.loadSettings();
  }

  static List<RouteView> pages = const [
    Home(),
    SignInView(),
    ProfileView(),
    DeviceDetailsView(),
    PasswordResetView(),
    PhoneView(),
    SmsView(),
    BluetoothView(),
    MqttPage(),
    SensorsPage(),
    SettingsView(),
    ItemDetailsView(),
    AddDeviceView(),
    WebViewTest(),
    IRDeviceControlPanel()
  ];
}
