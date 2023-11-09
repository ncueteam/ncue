import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';

class IRDeviceControlPanel extends RouteView {
  const IRDeviceControlPanel({super.key})
      : super(routeIcon: Icons.speaker_phone, routeName: "/ir-controll");

  @override
  State<IRDeviceControlPanel> createState() => _IRDeviceControlPanelState();
}

class _IRDeviceControlPanelState extends State<IRDeviceControlPanel> {
  String id = "209586a7-61af-44a5-87e8-485fb1ff47c0";
  late MQTTService mqttService;

  @override
  void initState() {
    mqttService = MQTTService("NCUEMQTT");
<<<<<<< HEAD
=======

>>>>>>> 849b71d24001c218c6d9c347b78b23bb53bec424
    super.initState();
  }

  @override
  void dispose() {
    mqttService.port.disconnect();
    super.dispose();
  }

  Map<String, String> button = {
    "light": "0x02",
    "wave +": "0x0e",
    "wave -": "0x12",
    "head": "0x0c",
    "mode": "0x04",
  };
  String protoco = "NEC16";

  @override
  Widget build(BuildContext context) {
    List<String> keys = button.keys.toList();
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
                  debugPrint("$protoco ${value!}");
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
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            itemCount: button.length,
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      mqttService.send(
                          //'{"from":"phone", "type":"ir_tx","data":"${button[keys[index]]!}","uuid":"$id"}'
                          "000");
                      //mqttService.send("0x0e");
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
    );
  }
}
