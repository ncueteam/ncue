import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';

class MqttUnit extends StatefulWidget {
  const MqttUnit({super.key});
  @override
  State<MqttUnit> createState() => _MqttUnitState();
}

class _MqttUnitState extends State<MqttUnit> {
  MQTTService mqttService = MQTTService("ncue_app");

  TextEditingController messageToSend = TextEditingController();
  FocusNode textFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    textFocus.addListener(() {
      if (textFocus.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => setState(() {
        debugPrint("trigger!");
      }),
      leading: Icon(mqttService.isConnected()
          ? Icons.wifi_tethering
          : Icons.wifi_tethering_off),
      title: SizedBox(
        width: 100.0,
        child: TextField(
          focusNode: textFocus,
          readOnly: !mqttService.isConnected(),
          controller: messageToSend,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "the message you wanna send"),
        ),
      ),
      subtitle: Text("Received: ${mqttService.value}"),
      trailing: IconButton(
        onPressed: () => setState(() {
          messageToSend.text = "";
        }),
        icon: const Icon(Icons.send),
      ),
    );
  }
}
