import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/route_view.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class IRDeviceControlPanel extends RouteView {
  const IRDeviceControlPanel({super.key})
      : super(routeIcon: Icons.speaker_phone, routeName: "/ir-controll");

  @override
  State<IRDeviceControlPanel> createState() => _IRDeviceControlPanelState();
}

class _IRDeviceControlPanelState extends State<IRDeviceControlPanel> {
  late MqttServerClient client;
  final messageToSend = TextEditingController();

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
    messageToSend.dispose();
    // client.disconnect();
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
        //.authenticateAs('test', '00000000')
        .withWillTopic('AIOT_113/IR_transmitter')
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
    client.subscribe('AIOT_113/IR_transmitter', MqttQos.exactlyOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final MqttPublishMessage payload =
            message.payload as MqttPublishMessage;
        // ignore: unused_local_variable
        final String messageText =
            MqttPublishPayload.bytesToStringAsString(payload.payload.message);
      }
    });
  }

  void onSubscribed(String topic) {}

  void onDisconnected() {}

  void onUnsubscribed(String? topic) {}

  void pong() {}

  void sendMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    try {
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    } catch (e) {
      debugPrint('Exception: $e');
      client.connect();
    }
  }

  List buttons = [
    // Icons.space_bar,
    // Icons.keyboard_arrow_up,
    // Icons.space_bar,
    // Icons.keyboard_arrow_left,
    // Icons.center_focus_strong,
    // Icons.keyboard_arrow_right,
    // Icons.space_bar,
    // Icons.keyboard_arrow_down,
    // Icons.space_bar,
    // 1,
    // 2,
    // 3,
    // 4,
    // 5,
    // 6,
    // 7,
    // 8,
    // 9,
    "light",
    "wave +",
    "wave -",
    "head",
    "mode",
  ];

  List buttondata = [
    // "0x00",
    // "0x46",
    // "0x03",
    // "0x44",
    // "0x40",
    // "0x43",
    // "0x07",
    // "0x15",
    // "0x09",
    // //1~9
    // "0x16",
    // "0x19",
    // "0x0D",
    // "0x0C",
    // "0x18",
    // "0x5E",
    // "0x08",
    // "0x1C",
    "0x02",
    "0x0e",
    "0x12",
    "0x0c",
    "0x04",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("電視遙控器")),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            itemCount: buttons.length,
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                child: Container(
                  color: Colors.green,
                  child: Center(
                    child: buttons[index] is IconData
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              color: Colors.red,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(100, 100))),
                                child: Icon(buttons[index]),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevatedButton(
                              onPressed: () {
                                sendMessage('AIOT_113/IR_transmitter',
                                    buttondata[index]);
                              },
                              child: Text("${buttons[index]}"),
                            ),
                          ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
