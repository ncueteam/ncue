import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';
import 'package:uuid/uuid.dart';
import '../basic/views/home_view.dart';
import '../basic/views/route_view.dart';

class AddDeviceView extends RouteView {
  final RoomModel? roomData;
  const AddDeviceView({key, this.roomData})
      : super(key, routeName: "/add-device-page", routeIcon: Icons.add_box);
  @override
  State<AddDeviceView> createState() => AddDeviceViewState();
}

class AddDeviceViewState extends State<AddDeviceView> {
  TextEditingController deviceName = TextEditingController();
  DeviceModel temp = DeviceModel();
  MQTTService mqttService = MQTTService("AppSend");

  @override
  void initState() {
    temp.iconPath = 'lib/src/icons/light-bulb.png';
    temp.type = 'switch';
    temp.uuid = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> deviceIcons = [
      "lib/src/icons/light-bulb.png",
      "lib/src/icons/fan.png",
      "lib/src/icons/smart-tv.png",
      "lib/src/icons/air-conditioner.png",
      "lib/src/icons/degree&wet.png",
    ];

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final RoomModel roomData = arguments['data'];

      List<Widget> items = [
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
              temp.uuid,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text("裝置類型", style: TextStyle(fontSize: 17)),
            ),
            DropdownButton<String>(
              onChanged: (value) {
                temp.type = value!;
                setState(() {});
              },
              value: temp.type,
              items: const [
                DropdownMenuItem(
                  value: "switch",
                  child: Text("開關"),
                ),
                DropdownMenuItem(
                  value: "bio_device",
                  child: Text("生物鎖裝置"),
                ),
                DropdownMenuItem(
                  value: "slide_device",
                  child: Text("調控裝置"),
                ),
                DropdownMenuItem(
                  value: "wet_degree_sensor",
                  child: Text("溫溼度感測器"),
                ),
                DropdownMenuItem(
                  value: "ir_controller",
                  child: Text("紅外線遙控器"),
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
        if (temp.type == "ir_controller")
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Text("裝置類型", style: TextStyle(fontSize: 17)),
              ),
              DropdownButton<String>(
                onChanged: (value) {
                  temp.subType = value!;
                  setState(() {});
                },
                value: temp.subType,
                items: const [
                  DropdownMenuItem(
                    value: "fan",
                    child: Text("風扇"),
                  ),
                  DropdownMenuItem(
                    value: "tv",
                    child: Text("電視"),
                  ),
                ],
              ),
            ],
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
                    temp.iconPath = value!;
                  });
                },
                value: temp.iconPath,
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
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
                "是否使用生物鎖",
                style: TextStyle(fontSize: 17),
              ),
            ),
            Switch(
              value: temp.bioLocked,
              onChanged: (bool value) =>
                  {temp.bioLocked = value, setState(() {})},
            )
          ],
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  if (deviceName.text != "") {
                    temp.name = deviceName.text;
                    temp.roomId = roomData.uuid;

                    await temp
                        .create()
                        .then((value) => roomData.devices.add(temp.uuid))
                        .then((value) async => await roomData.update())
                        .then((value) => mqttService.send(
                            '{"type":"register_device","type_data":"${temp.type}","uuid":"${temp.uuid}"}'))
                        // .then((value) => temp.debugData())
                        // .then((value) => roomData.debugData())
                        .then((value) => Navigator.pop(context, true));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: const Color.fromRGBO(200, 200, 200, 0.2),
                                padding: const EdgeInsets.all(20.0),
                                child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "請輸入裝置名稱",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ));
                  }
                },
                child: const Row(children: [Text("註冊裝置"), Icon(Icons.add)])),
          ],
        ),
        const Row(children: [Text('預覽裝置:')]),
        Container(child: temp.getUnit(context, () {})),
      ];

      return Scaffold(
        appBar: AppBar(
          title: const Text("裝置註冊頁面"),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return items[index];
          },
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
}
