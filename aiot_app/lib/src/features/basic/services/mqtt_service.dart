import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  late MqttServerClient port;
  String value = "";
  String topic = "NCUEMQTT";
  void Function() callback = () {};
  MQTTService(String mqttTopic) {
    port = MqttServerClient('test.mosquitto.org', 'ncue_app');
    port.disconnect();
    topic = mqttTopic;
    port.port = 1883;
    port.logging(on: false);
    port.autoReconnect = true;
    port.onConnected = () {
      port.subscribe(topic, MqttQos.exactlyOnce);
      port.subscribe('receive_topic', MqttQos.exactlyOnce);
    };
    port.onDisconnected = () {};
    port.onSubscribed = (topic) =>
        port.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
          for (var message in messages) {
            final MqttPublishMessage payload =
                message.payload as MqttPublishMessage;
            final String messageText = MqttPublishPayload.bytesToStringAsString(
                payload.payload.message);
            value = messageText;
          }
          callback();
        });
    port.connectionMessage = MqttConnectMessage()
        .withWillTopic(topic)
        .withWillMessage(value)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    port.connect();
  }

  void send(String message) {
    if (port.connectionStatus?.state == MqttConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);
      port.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      debugPrint("Mqtt send:$message");
    } else {
      debugPrint("not connected!");
      port.connect();
    }
  }

  bool isConnected() {
    return port.connectionStatus?.returnCode ==
        MqttConnectReturnCode.connectionAccepted;
  }
}
