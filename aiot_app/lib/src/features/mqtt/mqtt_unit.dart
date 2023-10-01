import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttUnit extends StatefulWidget {
  const MqttUnit({super.key});
  @override
  State<MqttUnit> createState() => _MqttUnitState();
}

class _MqttUnitState extends State<MqttUnit> {
  MqttServerClient client = MqttServerClient('test.mosquitto.org', 'ncue_app');

  TextEditingController messageToSend = TextEditingController();

  Future<void> initMqtt() async {
    client.disconnect();
    client.port = 1883;
    client.logging(on: true);

    client.onConnected = () {
      client.subscribe('receive_topic', MqttQos.exactlyOnce);
      client.subscribe('NCUEMQTT', MqttQos.exactlyOnce);
      messageToSend.text = "connected";
      setState(() {});
    };
    client.onDisconnected = () {
      messageToSend.text = "disconnected";
      setState(() {});
    };
    client.onSubscribed = (topic) {
      messageToSend.text = topic;
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        for (var message in messages) {
          final MqttPublishMessage payload =
              message.payload as MqttPublishMessage;
          final String messageText =
              MqttPublishPayload.bytesToStringAsString(payload.payload.message);
          setState(() {
            messageToSend.text = "收到 > $messageText";
          });
        }
      });
      setState(() {});
    };
    client.connectionMessage = MqttConnectMessage();
  }

  void connectMqqtt() async {
    try {
      await initMqtt();
      await client.connect();
      setState(() {});
    } catch (e) {
      debugPrint('$e');
      client.disconnect();
    }
  }

  @override
  void initState() {
    connectMqqtt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(client.connectionStatus?.returnCode ==
              MqttConnectReturnCode.connectionAccepted
          ? Icons.wifi_tethering
          : Icons.wifi_tethering_off),
      title: SizedBox(
        width: 100.0,
        child: TextField(
          readOnly: client.connectionStatus?.returnCode ==
              MqttConnectReturnCode.connectionAccepted,
          controller: messageToSend,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "the message you wanna send"),
        ),
      ),
      subtitle: const Text("Mqtt service"),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.send),
      ),
    );
  }
}
