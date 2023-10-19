import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../basic/home_view.dart';
import '../basic/route_view.dart';
import '../user/user_model.dart';
import 'device_service.dart';

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
    List<String> deviceIcons = [
      "lib/src/icons/light-bulb.png",
      "lib/src/icons/fan.png",
      "lib/src/icons/smart-tv.png",
      "lib/src/icons/air-conditioner.png",
    ];

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
                  await RouteView.model.addDevice(user, deviceUUID);
                  DeviceService().addDevice(deviceUUID, deviceType,
                      deviceName.text, deviceIconPath, false, 28.0);
                  // ignore: use_build_context_synchronously
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
