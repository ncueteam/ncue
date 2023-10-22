import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';

class Dht11Unit extends StatefulWidget {
  const Dht11Unit({super.key});

  @override
  State<Dht11Unit> createState() => _Dht11UnitState();
}

class _Dht11UnitState extends State<Dht11Unit> {
  MQTTService mqtt = MQTTService('AIOT_113/dht11');
  late List<String> mqttDataArray = ["??", "??"];
  void setReceivedText() {
    mqttDataArray = mqtt.value.split(" ");
    setState(() {});
  }

  @override
  void initState() {
    mqtt.callback = () => setReceivedText();
    super.initState();
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
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          sensorWidget('assets/lottie/LightRain.json', 'humidity',
              "${mqttDataArray[0]}%"),
          sensorWidget(
              'assets/lottie/day.json', 'Temperature', "${mqttDataArray[1]}°C"),
        ],
      ),
    );
  }
}
