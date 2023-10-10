import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:ncue.aiot_app/src/features/item_system/data_item.dart';
import 'package:ncue.aiot_app/src/features/notify_system/notify_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_detail_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_list_view.dart';
import 'package:ncue.aiot_app/src/features/sensors/sensorsapp.dart';
import 'package:ncue.aiot_app/src/features/user/user_model.dart';
import 'package:ncue.aiot_app/src/features/web_view/webview.dart';
import 'package:ncue.aiot_app/src/features/web_view/room.dart';

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
  static User? user = FirebaseAuth.instance.currentUser;
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
    user = await getUser();
  }

  static Future<UserModel> loadAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await UserService().loadUserData(user);
    } else {
      return UserModel("error", "error");
    }
  }

  static Future<User?> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    } else {
      return FirebaseAuth.instance.currentUser;
    }
  }

  static Future<List<DataItem>> loadUnits() async {
    List<DataItem> items = [];
    items.clear();
    // items.add(DataItem("mqtt", [], "mqtt"));
    items.add(DataItem(
        "extend",
        [
          DataItem("route", [const RoomListView()], "房間列表"),
          DataItem(
              "addDevice", [const AddDeviceView(), RouteView.model], "註冊裝置"),
          DataItem("route", [const MqttPage()], "MQTT測試"),
          DataItem("route", [const SensorsPage()], "感應器資料版"),
          DataItem("route", [const WebViewTest()], "網站版"),
          DataItem("route", [const RoomSelect()], "選擇房間"),
          DataItem("route", [const IRDeviceControlPanel()], "紅外線控制器"),
          DataItem("route", [const NotifyView()], "提醒列表"),
        ],
        "捷徑"));
    List x = [];
    for (DeviceModel device in await DeviceService().loadDeviceDataList()) {
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
    IRDeviceControlPanel(),
    NotifyView(),
    RoomListView(),
    RoomDetailsView(),
    RoomSelect()
  ];
}
