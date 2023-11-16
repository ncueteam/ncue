import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/data_item.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:uuid/uuid.dart';
import '../basic/views/home_view.dart';
import '../basic/views/route_view.dart';
import 'device_service.dart';

class AddDeviceView extends RouteView {
  final RoomModel? roomData;
  const AddDeviceView({super.key, this.roomData})
      : super(routeName: "/add-device-page", routeIcon: Icons.add_box);
  @override
  State<AddDeviceView> createState() => AddDeviceViewState();
}

class AddDeviceViewState extends State<AddDeviceView> {
  String deviceType = "device";
  TextEditingController deviceName = TextEditingController();
  String deviceIconPath = "lib/src/icons/light-bulb.png";
  String deviceUUID = const Uuid().v1();
  RoomModel room = RoomModel();

  @override
  Widget build(BuildContext context) {
    List<String> deviceIcons = [
      "lib/src/icons/light-bulb.png",
      "lib/src/icons/fan.png",
      "lib/src/icons/smart-tv.png",
      "lib/src/icons/air-conditioner.png",
    ];

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final RoomModel roomData = arguments['roomData'];
      return Scaffold(
        appBar: AppBar(
          title: const Text("裝置註冊頁面"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Text(
                  "房間名稱 ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  roomData.name,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "房間ID  ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  roomData.uuid,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "裝置號碼  ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  deviceUUID,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text(
                    "裝置類型",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                DropdownButton<String>(
                  onChanged: (value) {
                    setState(() {
                      deviceType = value!;
                    });
                  },
                  value: deviceType,
                  items: const [
                    DropdownMenuItem(
                      value: "device",
                      child: Text("一般裝置"),
                    ),
                    DropdownMenuItem(
                      value: "bio_device",
                      child: Text("生物鎖裝置"),
                    ),
                    DropdownMenuItem(
                      value: "slide_device",
                      child: Text("調控裝置"),
                    ),
                  ],
                ),
              ],
            ),
            TextField(
              controller: deviceName,
              decoration: const InputDecoration(
                labelText: '裝置名稱',
                hintText: '裝置名稱',
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text(
                    "裝置圖像",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                DropdownButton<String>(
                    onChanged: (value) {
                      setState(() {
                        deviceIconPath = value!;
                      });
                    },
                    value: deviceIconPath,
                    items: deviceIcons.map((iconPath) {
                      return DropdownMenuItem(
                        value: iconPath,
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          foregroundImage: AssetImage(iconPath),
                        ),
                      );
                    }).toList()),
              ],
            ),
            IconButton(
                onPressed: () async {
                  roomData.devices
                      .add(await DeviceService().getDeviceFromUuid(deviceUUID));
                  await roomData.update();
                  await DeviceService()
                      .addDevice(deviceUUID, deviceType, deviceName.text,
                          deviceIconPath, false, 28.0)
                      .then((value) => Navigator.pop(context, true));
                },
                icon: const Icon(Icons.add)),
          ]),
        ),
      );
    } else {
      return Container(
        child: const Home().getIconButton(context),
      );
    }
  }

  ListTile toUnit() {
    return ListTile(
        key: ValueKey(this),
        isThreeLine: true,
        title: const Text("為房間註冊裝置"),
        subtitle: Text(widget.routeName),
        leading: Icon(widget.routeIcon),
        onTap: () {
          Navigator.pushNamed(context, widget.routeName,
              arguments: {"roomData": widget.roomData});
        });
  }

  DataItem toDataItem() {
    return DataItem(
        "addDevice",
        [
          AddDeviceView(
            roomData: widget.roomData,
          ),
          RouteView.model
        ],
        name: "註冊裝置");
  }
}
