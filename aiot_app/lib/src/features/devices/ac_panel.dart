import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/route_view.dart';
import 'package:ncue.aiot_app/src/features/mqtt/mqtt_service.dart';

class ACPanel extends RouteView {
  const ACPanel({super.key})
      : super(routeIcon: Icons.air, routeName: "/AC-panel");

  @override
  State<ACPanel> createState() => _ACPanelState();
}

class _ACPanelState extends State<ACPanel> {
  MQTTService mqttService = MQTTService("NCUEMQTT/AC");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("冷氣控制"),
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              mqttService.send("test messsage!");
            },
            child: const Icon(Icons.abc))
      ]),
    );
  }
}
