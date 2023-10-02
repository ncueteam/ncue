import 'package:flutter/material.dart';
import '../basic/route_view.dart';
import 'package:lottie/lottie.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SensorsPage extends RouteView {
  const SensorsPage({super.key})
      : super(routeName: '/sensors', routeIcon: Icons.assessment);

  @override
  SensorsPageState createState() => SensorsPageState();
}

class SensorsPageState extends State<SensorsPage> {
  late MqttServerClient client;
  String messageText = "initial";
  late List<String> receivedtext = ["??", "??"];

  Widget messageComponent(String msg) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(msg),
      ),
    );
  }

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void connect() async {
    client = MqttServerClient('test.mosquitto.org', 'ncue_app');
    client.disconnect();
    client.port = 1883;
    client.logging(on: true);

    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        // .authenticateAs('username', 'password')
        .withWillTopic('NCUEMQTT')
        .withWillMessage('MQTT Connect from App')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      debugPrint('Exception: $e');
      client.disconnect();
    }
  }

  void onConnected() {
    debugPrint('Connected');
    client.subscribe('receive_topic', MqttQos.exactlyOnce);
    client.subscribe('NCUEMQTT', MqttQos.exactlyOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final MqttPublishMessage payload =
            message.payload as MqttPublishMessage;
        messageText =
            MqttPublishPayload.bytesToStringAsString(payload.payload.message);
        setReceivedText(messageText);
      }
    });
  }

  void setReceivedText(String text) {
    String receivedText = text;
    receivedtext = receivedText.split(" ");
    setState(() {});
  }

  void onSubscribed(String topic) {}

  void onDisconnected() {}

  void onUnsubscribed(String? topic) {}

  void pong() {}

  void sendMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
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
                  "${receivedtext[0]}%"),
              sensorWidget('assets/lottie/day.json', 'Temperature',
                  "${receivedtext[1]}°C"),
            ],
          ),
        ]),
      ),
    );
  }
}
