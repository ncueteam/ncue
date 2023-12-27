import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/app.dart';
import 'package:ncue.aiot_app/src/features/auth_system/profile_view.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/add_room_view.dart';
import 'package:ncue.aiot_app/src/features/settings/settings_view.dart';

class RoomListView extends RouteView {
  const RoomListView({key})
      : super(key, routeName: '/home', routeIcon: Icons.meeting_room_sharp);

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  List<Widget> items = [];

  @override
  void initState() {
    reload();
    super.initState();
  }

  Future<List<Widget>> loadUnits() async {
    items = [];
    for (String room in RouteView.model.rooms) {
      Widget temp = (await RoomModel().read(room)).getUnit();
      if (!items.contains(temp)) items.add(temp);
    }
    for (String room in RouteView.model.memberRooms) {
      Widget temp = (await RoomModel().read(room)).getUnit();
      if (!items.contains(temp)) items.add(temp);
    }
    return items;
  }

  Future<void> reload() async {
    await RouteView.loadAccount();
    items = await loadUnits();
    items.add(const AddRoomView()
        .getUnit(navigatorKey.currentContext!, customName: "註冊房間"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(RouteView.language.roomListPageTitle),
          actions: [const SettingsView().getIconButton()],
        ),
        drawer: const Drawer(child: ProfileView()),
        body: RefreshIndicator(
          onRefresh: () => reload(),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return items[index];
            },
          ),
        ));
  }
}
