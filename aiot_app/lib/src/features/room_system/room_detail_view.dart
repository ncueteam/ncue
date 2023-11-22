import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/units/type_tile.dart';
import 'package:ncue.aiot_app/src/features/devices/add_device_view.dart';

import '../basic/views/route_view.dart';

class RoomDetailsView extends RouteView {
  const RoomDetailsView({super.key})
      : super(
            routeName: '/room_detail_view',
            routeIcon: Icons.medical_information);

  @override
  State<RoomDetailsView> createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<RoomDetailsView> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final RoomModel room = arguments['data'];
      final List<Widget> items = [];
      items.add(Text(room.name));
      items.add(Text(room.uuid));
      items.add(TypeTile(
          name: "房間內裝置",
          children: (room.devices.map((e) => e.getUnit(context, () {
                setState(() {});
              }))).toList()));
      items.add(const AddDeviceView()
          .getDataItemRoute(context, data: {'data': room}, customName: "註冊裝置"));
      return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("    ${room.name}",
                    style: const TextStyle(fontSize: 30)),
              )
            ]),
          ),
        ),
        body: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: items[index],
                  );
                },
              ),
            )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('裝置內容')),
        body: const Center(child: Column(children: [Text('無法載入 / 載入錯誤')])),
      );
    }
  }
}
