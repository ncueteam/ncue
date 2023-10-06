import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/unit.dart';
import 'package:ncue.aiot_app/src/features/item_system/data_item.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';

import '../basic/route_view.dart';

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
      final RoomModel item = arguments['data'];
      final List<DataItem> items = [];
      items.add(DataItem("text", [], item.uuid));
      items.addAll(item.devices.map((device) {
        return device.toDataItem();
      }).toList());
      return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("    ${item.name}",
                    style: const TextStyle(fontSize: 30)),
              )
            ]),
          ),
        ),
        body: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  DataItem item = items[index];
                  return Unit(item: item);
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
