import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/home_view.dart';
import 'package:ncue_app/src/features/basic/route_view.dart';
import 'package:ncue_app/src/features/devices/device_service.dart';
import 'package:ncue_app/src/features/user/user_model.dart';
import 'package:uuid/uuid.dart';

import '../user/user_service.dart';

class AddDeviceView extends RouteView {
  const AddDeviceView({super.key})
      : super(routeName: "/add-device-page", routeIcon: Icons.add_box);

  @override
  State<AddDeviceView> createState() => AddDeviceViewState();
}

class AddDeviceViewState extends State<AddDeviceView> {
  String deviceType = "device";
  TextEditingController deviceName = TextEditingController();
  String deviceIconPath = "lib/src/icons/light-bulb.png";
  String deviceUUID = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final UserModel user = arguments['user'];
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
                  items: const [
                    DropdownMenuItem(
                      value: "lib/src/icons/light-bulb.png",
                      child: Text("電燈"),
                    ),
                    DropdownMenuItem(
                      value: "lib/src/icons/fan.png",
                      child: Text("電扇"),
                    ),
                    DropdownMenuItem(
                      value: "lib/src/icons/smart-tv.png",
                      child: Text("智慧電視"),
                    ),
                    DropdownMenuItem(
                      value: "lib/src/icons/air-conditioner.png",
                      child: Text("冷氣"),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () async {
                  UserService().addDevice(user, deviceUUID);
                  DeviceService().addDevice(deviceUUID, deviceType,
                      deviceName.text, deviceIconPath, false);
                  Navigator.pop(context, true);
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
}
