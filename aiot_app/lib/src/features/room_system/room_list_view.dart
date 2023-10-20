import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/unit.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';
import '../auth_system/profile_view.dart';
import '../settings/settings_view.dart';
import '../basic/data_item.dart';

class RoomListView extends RouteView {
  const RoomListView({super.key})
      : super(routeName: '/room-list', routeIcon: Icons.meeting_room_sharp);

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  List<DataItem> items = [];

  @override
  void initState() {
    reload();
    super.initState();
  }

  static Future<List<DataItem>> loadUnits() async {
    List<DataItem> items = [];
    return items;
  }

  Future<void> reload() async {
    await RouteView.loadAccount();
    items = await loadUnits();
    for (String s in RouteView.model.rooms) {
      items.add(
          (await RoomModel("error", "error").getRoomFromUuid(s)).toDataItem());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("房間列表"),
        actions: [const SettingsView().getIconButton(context)],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: RefreshIndicator(
        onRefresh: () => reload(),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Unit(item: items[index]);
          },
        ),
      ),
    );
  }
}
