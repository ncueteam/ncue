import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/data_item.dart';
import 'package:ncue.aiot_app/src/features/basic/views/file_upload_view.dart';
import 'package:ncue.aiot_app/src/features/devices/ac_panel.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
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

  DataItem getDataItemRoute({String customName = ""}) {
    return DataItem("route", [this],
        name: customName == "" ? routeName : customName);

    // return ListTile(
    //     key: ValueKey(this),
    //     isThreeLine: true,
    //     title: Text("前往頁面 : ${customName == "" ? routeName : customName}"),
    //     subtitle: Text(routeName),
    //     leading: Icon(routeIcon),
    //     onTap: () {
    //       // Navigator.pushNamed(, routeName);
    //     });
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

  static const List<RouteView> pages = [
    Home(),
    SignInView(),
    ProfileView(),
    DeviceDetailsView(),
    PasswordResetView(),
    PhoneView(),
    SmsView(),
    BluetoothView(),
    SettingsView(),
    AddDeviceView(),
    IRDeviceControlPanel(),
    NotifyView(),
    RoomListView(),
    RoomDetailsView(),
    AddRoomView(),
    ACPanel(),
    FileUploadView(),
  ];
}
