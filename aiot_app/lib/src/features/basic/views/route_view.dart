import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/app.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:ncue.aiot_app/src/features/bluetooth/flutter_blue_app.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:ncue.aiot_app/src/features/notify_system/notify_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/add_room_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_detail_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_list_view.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../auth_system/password_reset_view.dart';
import '../../auth_system/phone_input_view.dart';
import '../../auth_system/profile_view.dart';
import '../../auth_system/sign_in_view.dart';
import '../../auth_system/sms_view.dart';
import '../../devices/add_device_view.dart';
import '../../devices/device_detail_view.dart';
import '../../settings/settings_controller.dart';
import '../../settings/settings_service.dart';
import '../../settings/settings_view.dart';

abstract class RouteView extends StatefulWidget {
  final String routeName;
  final IconData routeIcon;
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static UserModel model = RouteView.model;
  static User? user = FirebaseAuth.instance.currentUser;
  static AppLocalizations language =
      AppLocalizations.of(navigatorKey.currentContext!)!;

  const RouteView(Key? key, {required this.routeName, required this.routeIcon})
      : super(key: key);

  IconButton getIconButton() {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(navigatorKey.currentContext!, routeName,
            arguments: const RoomListView().routeName);
      },
      icon: Icon(routeIcon),
    );
  }

  UnitTile getUnit(BuildContext context,
      {String customName = "", Map<String, dynamic> data = const {}}) {
    return UnitTile(
        key: ValueKey(this),
        isThreeLine: true,
        title: Text("前往頁面 : ${customName == "" ? routeName : customName}"),
        subtitle: Text(routeName),
        leading: Icon(routeIcon),
        onTap: () {
          Navigator.pushNamed(context, routeName, arguments: data);
        });
  }

  static final SettingsController settingsController =
      SettingsController(SettingsService());
  static Future<void> loadRouteViewSettings() async {
    await settingsController.loadSettings();
    await loadAccount();
  }

  static Future<void> loadAccount() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      model = await UserModel().read();
    } else {
      debugPrint("error loading user!");
    }
  }

  static const List<RouteView> pages = [
    SignInView(),
    ProfileView(),
    DeviceDetailsView(),
    PasswordResetView(),
    PhoneView(),
    SmsView(),
    SettingsView(),
    AddDeviceView(),
    IRDeviceControlPanel(),
    NotifyView(),
    RoomListView(),
    RoomDetailsView(),
    AddRoomView(),
    BlueToothView(),
  ];
}
