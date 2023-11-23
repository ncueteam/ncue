import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import '../auth_system/profile_view.dart';

class RoomListView extends RouteView {
  const RoomListView({super.key})
      : super(routeName: '/room-list', routeIcon: Icons.meeting_room_sharp);

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

  static Future<List<Widget>> loadUnits() async {
    List<Widget> temp = [];
    for (String s in RouteView.model.rooms) {
      temp.add((await RoomModel().read(s)).getUnit());
    }
    for (String s in RouteView.model.memberRooms) {
      temp.add((await RoomModel().read(s)).getUnit());
    }
    return temp;
  }

  Future<void> reload() async {
    await RouteView.loadAccount();
    items = await loadUnits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("房間列表")),
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
