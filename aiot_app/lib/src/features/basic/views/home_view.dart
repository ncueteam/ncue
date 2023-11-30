import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/units/type_tile.dart';
import 'package:ncue.aiot_app/src/features/basic/views/file_upload_view.dart';
import 'package:ncue.aiot_app/src/features/bluetooth/flutter_blue_app.dart';
import 'package:ncue.aiot_app/src/features/room_system/add_room_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_list_view.dart';
import '../../auth_system/profile_view.dart';
import '../../settings/settings_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'route_view.dart';

class Home extends RouteView {
  const Home({key}) : super(key, routeName: '/home', routeIcon: Icons.home);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> items = [];
  @override
  void initState() {
    reload();
    super.initState();
  }

  Future<List<Widget>> loadUnits() async {
    items.clear();
    items.add(TypeTile(name: "捷徑", children: [
      // const MqttUnit(uuid: "302"),
      const AddRoomView().getUnit(context, customName: "註冊房間"),
      const FileUploadView().getUnit(context, customName: '上傳檔案'),
      const RoomListView().getUnit(context, customName: '房間列表'),
      // const IRDeviceControlPanel().getUnit(context, customName: '紅外線控制器'),
      // const Dht11Unit(),
    ]));
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
          const BlueToothView().getIconButton(context),
        ],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: RefreshIndicator(
        onRefresh: () => reload(),
        child: ListView.builder(
          restorationId: 'homeView',
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return items[index];
          },
        ),
      ),
    );
  }
}
