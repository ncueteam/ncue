import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class RoomListView extends RouteView {
  const RoomListView({key})
      : super(key,
            routeName: '/room-list', routeIcon: Icons.meeting_room_sharp);

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("房間列表")),
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
