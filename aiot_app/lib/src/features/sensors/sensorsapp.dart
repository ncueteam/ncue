import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';
import '../basic/views/route_view.dart';
import 'package:lottie/lottie.dart';

class SensorsPage extends RouteView {
  const SensorsPage({super.key})
      : super(routeName: '/sensors', routeIcon: Icons.assessment);

  @override
  SensorsPageState createState() => SensorsPageState();
}

class SensorsPageState extends State<SensorsPage> {
  MQTTService mqtt = MQTTService('AIOT_113/dht11');
  String messageText = "initial";
  late List<String> mqttDataArray = ["??", "??"];

  @override
  void initState() {
    mqtt.callback = () {
      setReceivedText(mqtt.value);
    };
    super.initState();
  }

  void setReceivedText(String text) {
    String receivedText = text;
    mqttDataArray = receivedText.split(" ");
    setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors Page'),
      ),
      body: Center(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              sensorWidget('assets/lottie/LightRain.json', 'humidity',
                  "${mqttDataArray[0]}%"),
              sensorWidget('assets/lottie/day.json', 'Temperature',
                  "${mqttDataArray[1]}°C"),
            ],
          ),
        ]),
      ),
    );
  }
}
