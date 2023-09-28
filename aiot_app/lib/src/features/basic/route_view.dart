import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:ncue.aiot_app/src/features/item_system/data_item.dart';
import 'package:ncue.aiot_app/src/features/sensors/sensorsapp.dart';
import 'package:ncue.aiot_app/src/features/user/user_model.dart';
import 'package:ncue.aiot_app/src/features/web_view/webview.dart';

import '../auth_system/password_reset_view.dart';
import '../auth_system/phone_input_view.dart';
import '../auth_system/profile_view.dart';
import '../auth_system/sign_in_view.dart';
import '../auth_system/sms_view.dart';
import '../bluetooth/flutterblueapp.dart';
import '../devices/add_device_view.dart';
import '../devices/device_detail_view.dart';
import '../devices/device_model.dart';
import '../devices/device_service.dart';
import '../item_system/item_details_view.dart';
import '../mqtt/mqttapp.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_service.dart';
import '../settings/settings_view.dart';
import '../user/user_service.dart';
import 'home_view.dart';

abstract class RouteView extends StatefulWidget {
  final String routeName;
  final IconData routeIcon;
  static UserModel model = RouteView.model;
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
    model = await loadAccount();
  }

  static Future<UserModel> loadAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await UserService().loadUserData(user);
    } else {
      return UserModel("error", "erroe");
    }
  }

  static Future<List<DataItem>> loadUnits() async {
    List<DataItem> items = [];
    items.clear();
    List rts = [];
    rts.add(DataItem(
        "addDevice", [const AddDeviceView(), RouteView.model], "註冊裝置"));
    rts.add(DataItem("route", [const MqttPage()], "MQTT測試"));
    rts.add(DataItem("route", [const MqttService()], "MQTT測試2"));
    rts.add(DataItem("route", [const SensorsPage()], "感應器資料版"));
    rts.add(DataItem("route", [const WebViewTest()], "網站版"));
    rts.add(DataItem("route", [const IRDeviceControlPanel()], "紅外線控制器"));

    items.add(DataItem("extend", rts, "捷徑"));

    items.add(DataItem("mqtt", [], "mqtt"));
    List x = [];
    for (DeviceModel device in await DeviceService().loadDeviceData()) {
      if (RouteView.model.devices.contains(device.uuid)) {
        x.add(device.toDataItem());
      }
    }

    items.add(DataItem("extend", x, "集合"));
    return items;
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
