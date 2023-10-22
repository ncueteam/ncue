import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';

class Dht11Unit extends StatefulWidget {
  const Dht11Unit({super.key});

  @override
  State<Dht11Unit> createState() => _Dht11UnitState();
}

class _Dht11UnitState extends State<Dht11Unit> {
  void reload() {
    setState(() {});
  }

  MQTTService mqtt = MQTTService('AIOT_113/dht11');
  @override
  Widget build(BuildContext context) {
    mqtt.callback = () {
      setState(() {});
    };
    return ListTile(
      subtitle: Column(
        children: [
          Text("MQTT:${mqtt.value}"),
        ],
      ),
    );
  }
}
