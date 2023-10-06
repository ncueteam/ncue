import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/unit.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';
import 'package:uuid/uuid.dart';
import '../auth_system/profile_view.dart';
import '../settings/settings_view.dart';
import '../item_system/data_item.dart';

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
    List<DataItem> items = [
      DataItem(
          "room",
          [RoomModel(await RouteView.getUser(), "雙人房", const Uuid().v1())],
          "雙人房")
    ];
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
        title: const Text("房間列表"),
        actions: [const SettingsView().getIconButton(context)],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: RefreshIndicator(
        onRefresh: () => reload(),
        child: ListView.builder(
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
