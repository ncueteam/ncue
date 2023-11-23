import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';
import 'package:uuid/uuid.dart';

class IRDeviceControlPanel extends RouteView {
  final String uuid;
  const IRDeviceControlPanel({super.key, this.uuid = ""})
      : super(routeIcon: Icons.speaker_phone, routeName: "/ir-controll");

  @override
  State<IRDeviceControlPanel> createState() => _IRDeviceControlPanelState();
}

class _IRDeviceControlPanelState extends State<IRDeviceControlPanel> {
  late MQTTService mqttService;

  DeviceModel device = DeviceModel();

  late String uuid = const Uuid().v1().toString();

  late List<String> keys = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> reload(BuildContext context) async {
    // Map<String, dynamic> arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // //等等從這邊開始
    // await DeviceModel().read(arguments['data'] as DeviceModel).then((value) => null);
    mqttService = MQTTService('AppSend');
    // debugPrint("ID: " + widget.uuid);
    // if (widget.uuid != "") {
    //   uuid = widget.uuid;
    //   await device.read(uuid).then((value) {
    //     debugPrint("%%%" + value.type);
    //   });
    // }
    debugPrint("# ${device.subType}");
    keys =
        // buttonSet[device.type] == null
        //     ? []
        //     :
        (buttonSet[device.subType])!.keys.toList();
    device.type = "fan";
    setState(() {});
  }

  @override
  void dispose() {
    mqttService.port.disconnect();
    super.dispose();
  }

  Map<String, Map<String, String>> buttonSet = {
    "fan": {
      "on/off": "0x00",
      "light": "0x02",
      "wave +": "0x0e",
      "wave -": "0x12",
      "head": "0x0c",
      "mode": "0x04",
    },
    "tv": {
      "on/off": "0x00",
    }
  };

  String protoco = "NEC16";

  @override
  Widget build(BuildContext context) {
    List<String> protocos = [
      "NEC8",
      "NEC16",
      "sony",
      "Philip",
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
                "電扇遙控器 協定",
                style: TextStyle(fontSize: 17),
              ),
            ),
            DropdownButton<String>(
                onChanged: (value) {
                  setState(() {
                    protoco = value!;
                  });
                },
                value: protoco,
                items: protocos.map((name) {
                  return DropdownMenuItem(
                    value: name,
                    child: Text(name),
                  );
                }).toList()),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await reload(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
              ),
              itemCount: keys.length,
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        mqttService.send(
                            '{"type":"ir_tx","data":"${(buttonSet[device.type])![keys[index]]!}","protocol":"$protoco","uuid":"$uuid"}');
                      },
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          keys[index],
                          style: const TextStyle(fontSize: 100),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 200,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                mqttService.send(
                    '{"type":"ir_rx","data":"none","protocol":"$protoco","clientID":"${RouteView.model.uuid.toString()}"}');
              },
              child: const FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "IR 測試",
                  style: TextStyle(fontSize: 100),
                ),
              ),
            ),
            FittedBox(fit: BoxFit.scaleDown, child: Text("UUID: $uuid"))
          ],
        ),
      ),
    );
  }
}
