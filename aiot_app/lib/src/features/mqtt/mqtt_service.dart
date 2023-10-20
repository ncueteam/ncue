import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  late MqttServerClient port;
  String value = "";
  String topic = "NCUEMQTT";
  MQTTService(String mqttTopic) {
    port = MqttServerClient('test.mosquitto.org', 'ncue_app');
    port.disconnect();
    topic = mqttTopic;
    port.port = 1883;
    port.logging(on: false);
    port.autoReconnect = true;
    port.onConnected = () => port.subscribe(topic, MqttQos.atMostOnce);
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
        });
    port.connect();
  }
  void send(String message) {
    if (port.connectionStatus?.state == MqttConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);
      port.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    } else {
      debugPrint("not connected!");
      port.connect();
    }
  }
}
