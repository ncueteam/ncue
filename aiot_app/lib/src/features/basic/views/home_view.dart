import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/views/file_upload_view.dart';
import 'package:ncue.aiot_app/src/features/devices/ac_panel.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:ncue.aiot_app/src/features/room_system/add_room_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_list_view.dart';
import '../../auth_system/profile_view.dart';
import '../../bluetooth/flutterblueapp.dart';
import '../../settings/settings_view.dart';
import '../data_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'route_view.dart';
import '../units/unit.dart';

class Home extends RouteView {
  const Home({super.key}) : super(routeName: '/home', routeIcon: Icons.home);

  // static BuildContext homeContext;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DataItem> items = [];

  @override
  void initState() {
    reload();
    super.initState();
  }

  Future<List<DataItem>> loadUnits() async {
    items.clear();
    items.add(DataItem(
        "extend",
        [
          DataItem("addRoom", [const AddRoomView(), RouteView.model],
              name: "註冊房間"),
          const ACPanel().getDataItemRoute(customName: '冷氣遙控'),
          const FileUploadView().getDataItemRoute(customName: '上傳檔案'),
          const RoomListView().getDataItemRoute(customName: '房間列表'),
          const IRDeviceControlPanel().getDataItemRoute(customName: '紅外線控制器'),
          DataItem("dht11", ["8458774c-3a09-40ab-bb61-c4f541a29d84"]),
          DataItem("auto", [])
        ],
        name: "捷徑"));
    return items;
  }

  Future<void> reload() async {
    items = await loadUnits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          const SettingsView().getIconButton(context),
          const BluetoothView().getIconButton(context),
        ],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: RefreshIndicator(
        onRefresh: () => reload(),
        child: ListView.builder(
          restorationId: 'homeView',
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            DataItem item = items[index];
            return Unit(item: item);
          },
        ),
      ),
    );
  }
}
