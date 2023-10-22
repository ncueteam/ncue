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
  MQTTService mqttService = MQTTService("AIOT_113/IR_transmitter");

  Map<String, String> button = {
    "light": "0x02",
    "wave +": "0x0e",
    "wave -": "0x12",
    "head": "0x0c",
    "mode": "0x04",
  };

  @override
  Widget build(BuildContext context) {
    List<String> keys = button.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text("電扇遙控器")),
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
                      mqttService.send(button[keys[index]]!);
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
