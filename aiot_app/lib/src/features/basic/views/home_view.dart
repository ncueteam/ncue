import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/units/dht11_unit.dart';
import 'package:ncue.aiot_app/src/features/basic/units/mqtt_unit.dart';
import 'package:ncue.aiot_app/src/features/basic/units/type_tile.dart';
import 'package:ncue.aiot_app/src/features/basic/views/file_upload_view.dart';
import 'package:ncue.aiot_app/src/features/devices/ac_panel.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:ncue.aiot_app/src/features/room_system/add_room_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_list_view.dart';
import '../../auth_system/profile_view.dart';
import '../../bluetooth/flutterblueapp.dart';
import '../../settings/settings_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'route_view.dart';

class Home extends RouteView {
  const Home({super.key}) : super(routeName: '/home', routeIcon: Icons.home);

  // static BuildContext homeContext;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> grids = [];
  @override
  void initState() {
    reload();
    super.initState();
  }

  Future<List<Widget>> loadUnits() async {
    grids.clear();
    grids.add(TypeTile(name: "捷徑", children: [
      const MqttUnit(uuid: "302"),
      const AddRoomView().getDataItemRoute(context, customName: "註冊房間"),
      const ACPanel().getDataItemRoute(context, customName: '冷氣遙控'),
      const FileUploadView().getDataItemRoute(context, customName: '上傳檔案'),
      const RoomListView().getDataItemRoute(context, customName: '房間列表'),
      const IRDeviceControlPanel()
          .getDataItemRoute(context, customName: '紅外線控制器'),
      const Dht11Unit(),
    ]));
    return grids;
  }

  Future<void> reload() async {
    grids = await loadUnits();
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
          itemCount: grids.length,
          itemBuilder: (BuildContext context, int index) {
            return grids[index];
          },
        ),
      ),
    );
  }
}
