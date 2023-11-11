import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';

class ACPanel extends RouteView {
  final String uuid;
  const ACPanel({super.key, this.uuid = ""})
      : super(routeIcon: Icons.air, routeName: "/AC-panel");

  @override
  State<ACPanel> createState() => _ACPanelState();
}

class _ACPanelState extends State<ACPanel> {
  late MQTTService mqttService;

  @override
  void initState() {
    mqttService = MQTTService("NCUEMQTT/${widget.uuid}");
    super.initState();
  }

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
