import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';
import 'package:ncue.aiot_app/src/features/bluetooth/flutter_blue_app.dart';
import 'package:ncue.aiot_app/src/features/devices/add_device_view.dart';

import '../basic/views/route_view.dart';

class RoomDetailsView extends RouteView {
  const RoomDetailsView({key})
      : super(key,
            routeName: '/room_detail_view',
            routeIcon: Icons.medical_information);

  @override
  State<RoomDetailsView> createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<RoomDetailsView> {
  List<Widget> items = [];
  RoomModel model = RoomModel();
  bool isFirstLoad = true;
  @override
  void initState() {
    super.initState();
  }

  Future<void> reload(BuildContext context) async {
    items.clear();
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    await RoomModel().read(arguments['data'] as String).then((room) async {
      items.add(Text(room.name));
      items.add(Text(room.uuid));
      items.add(const AddDeviceView()
          .getUnit(context, data: {'data': room}, customName: "註冊裝置"));
      List<DeviceModel> devices = [];
      for (String s in room.devices) {
        devices.addOrUpdate(await DeviceModel().read(s));
      }
      items.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, const BlueToothView().routeName,
                    arguments: {'data': room});
              },
              child: const Text("透過藍芽新增wifi帳號密碼")),
          ElevatedButton(
              onPressed: () async {
                room.owner.rooms.remove(room.uuid);
                room.owner.memberRooms.remove(room.uuid);
                room.owner.update();
                Navigator.pop(context);
                for (String memberId in room.members) {
                  UserModel member = await UserModel().read(id: memberId);
                  member.memberRooms.remove(room.uuid);
                }
              },
              child: const Text("刪除房間"))
        ],
      ));

      items.addAll((devices.map((e) => e.getUnit(() {
            setState(() {});
            room.update();
          }))).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      Future.delayed(const Duration(seconds: 1), () async {
        await reload(context).then((value) {
          setState(() {
            isFirstLoad = false;
          });
        });
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(children: [
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("房間內容", style: TextStyle(fontSize: 30)),
                ),
              )
            ]),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () async {
              await reload(context).then((value) {
                setState(() {});
              });
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                child: items[index],
              );
            },
          ),
        ));
  }
}
