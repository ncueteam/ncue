import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/devices/ac_panel.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:ncue.aiot_app/src/features/basic/data_item.dart';
import 'package:ncue.aiot_app/src/features/notify_system/notify_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/add_room_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_detail_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_list_view.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';

import '../../auth_system/password_reset_view.dart';
import '../../auth_system/phone_input_view.dart';
import '../../auth_system/profile_view.dart';
import '../../auth_system/sign_in_view.dart';
import '../../auth_system/sms_view.dart';
import '../../bluetooth/flutterblueapp.dart';
import '../../devices/add_device_view.dart';
import '../../devices/device_detail_view.dart';
import '../../settings/settings_controller.dart';
import '../../settings/settings_service.dart';
import '../../settings/settings_view.dart';
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
    await loadAccount();
    user = await getUser();
  }

  static Future<void> loadAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      model = await UserModel().load(user);
    } else {
      debugPrint("error loading user!");
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
    // items.add(DataItem("mqtt", []));
    items.add(DataItem("removable", [
      DataItem("addRoom", [const AddRoomView(), RouteView.model], name: "註冊房間")
    ]));
    items.add(DataItem(
        "extend",
        [
          DataItem("route", [const ACPanel()], name: "冷氣遙控"),
          DataItem("route", [const RoomListView()], name: "房間列表"),
          DataItem("route", [const IRDeviceControlPanel()], name: "紅外線控制器"),
          DataItem("dht11", ["8458774c-3a09-40ab-bb61-c4f541a29d84"]),
          DataItem("dht11", []),
          // DataItem("route", [const NotifyView()], "提醒列表"),
        ],
        name: "捷徑"));
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
    SettingsView(),
    AddDeviceView(
      roomID: '????',
    ),
    IRDeviceControlPanel(),
    NotifyView(),
    RoomListView(),
    RoomDetailsView(),
    AddRoomView(),
    ACPanel(),
  ];
}
