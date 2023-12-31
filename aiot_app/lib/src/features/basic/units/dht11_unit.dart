import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';

class Dht11Unit extends UnitTile {
  final String uuid;
  const Dht11Unit({super.key, this.uuid = ""});

  @override
  State<Dht11Unit> createState() => _Dht11UnitState();
}

class _Dht11UnitState extends State<Dht11Unit> {
  late MQTTService mqtt;

  late String uuid = "??";
  late String temperature = "??";
  late String humidity = "??";
  late String type = "??";

  void setReceivedText() {
    Map<String, dynamic> mqttData = json.decode(mqtt.value);
    // debugPrint(mqttData.toString());
    type = mqttData["type"].toString();
    uuid = mqttData["uuid"].toString();
    // debugPrint("$uuid vs ${widget.uuid}");
    if (type == "dht11" && uuid == widget.uuid) {
      temperature = mqttData["temperature"].toString();
      humidity = mqttData["humidity"].toString();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    mqtt = MQTTService('Esp32Send');
    mqtt.callback = () => setReceivedText();
  }

  @override
  void dispose() {
    mqtt.port.disconnect();
    super.dispose();
  }

  Widget sensorWidget(String lottieAsset, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 6,
            blurRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
          child: Column(
        children: [
          Lottie.asset(
            lottieAsset,
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          ),
          Text(value,
              style: const TextStyle(
                fontSize: 25,
              )),
          Text(title)
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // title: Text(uuid.split('-').toString()),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          sensorWidget(
              'assets/lottie/LightRain.json', 'humidity', "$humidity%"),
          sensorWidget(
              'assets/lottie/day.json', 'Temperature', "$temperature°C"),
        ],
      ),
    );
  }
}
