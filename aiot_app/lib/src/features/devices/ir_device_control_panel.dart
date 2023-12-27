import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';
import 'package:uuid/uuid.dart';

class IRDeviceControlPanel extends RouteView {
  final String uuid;
  const IRDeviceControlPanel({key, this.uuid = ""})
      : super(key, routeIcon: Icons.speaker_phone, routeName: "/ir-controll");

  @override
  State<IRDeviceControlPanel> createState() => _IRDeviceControlPanelState();
}

class _IRDeviceControlPanelState extends State<IRDeviceControlPanel> {
  late MQTTService mqttService;

  DeviceModel device = DeviceModel();

  late String uuid = const Uuid().v1().toString();

  late List<String> keys = [];

  /*--------------------------遙控器內容------------------------------*/

  TextEditingController temperatureDisplay = TextEditingController();

  String timer = "";

  TextEditingController timerDisplay = TextEditingController();

  /*-----------------------------------------------------------------*/

  @override
  void initState() {
    super.initState();
  }

  Future<void> reload(BuildContext context) async {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (arguments['data'] is DeviceModel) {
      device = arguments['data'] as DeviceModel;
    }
    keys = (buttonSet[device.subType])!.keys.toList();
    // device.type = "fan";
    mqttService = MQTTService('AppSend');
    temperatureDisplay.text = "${device.temperature}°C";
    device.timer > 0
        ? timer = "定時關"
        : device.timer == 0
            ? timer = "定時"
            : timer = "定時開";
    timerDisplay.text = "${device.timer.abs()} hr";
    setState(() {});
  }

  @override
  void dispose() {
    mqttService.port.disconnect();
    super.dispose();
  }

  Map<String, Map<String, String>> buttonSet = {
    "fan": {
      "on/off": "0x00",
      "light": "0x02",
      "wave +": "0x0e",
      "wave -": "0x12",
      "head": "0x0c",
      "mode": "0x04",
    },
    "tv": {
      "on/off": "0x00",
    },
    "AC": {
      "on/off": "on/off",
      "degree": "degree",
      "warm": "warm",
      "cold": "cold",
      "off_timer": "off_timer",
      "on_timer": "on_timer",
    }
  };

  String protoco = "NEC16";

  List<String> protocos = ["NEC8", "NEC16", "sony", "Philip", "Tatung"];

  @override
  Widget build(BuildContext context) {
    reload(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
                "電扇遙控器 協定",
                style: TextStyle(fontSize: 17),
              ),
            ),
            DropdownButton<String>(
                onChanged: (value) {
                  setState(() {
                    protoco = value!;
                  });
                },
                value: protoco,
                items: protocos.map((name) {
                  return DropdownMenuItem(
                    value: name,
                    child: Text(name),
                  );
                }).toList()),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await reload(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: device.subType == "AC"
              ? Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: const Text("風向")),
                            ElevatedButton(
                                onPressed: () {}, child: const Text("風量")),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      device.temperature += 1;
                                      device.update();
                                      temperatureDisplay.text =
                                          "${device.temperature.round()}°C";
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.add)),
                                SizedBox(
                                  width: 50.0,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    controller: temperatureDisplay,
                                    readOnly: true,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      device.temperature -= 1;
                                      device.update();
                                      temperatureDisplay.text =
                                          "${device.temperature.round()}°C";
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.remove)),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: const Icon(Icons.power_settings_new)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: const Text("除溼")),
                            ElevatedButton(
                                onPressed: () {}, child: const Text("暖氣")),
                            ElevatedButton(
                                onPressed: () {}, child: const Text("冷氣")),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  device.timer *= -1;
                                  device.update();
                                  setState(() {});
                                },
                                child: Text(timer)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      timer == "定時開"
                                          ? device.timer -= 1
                                          : device.timer += 1;
                                      device.update();
                                      timerDisplay.text = "${device.timer} hr";
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.add)),
                                SizedBox(
                                  width: 50.0,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    controller: timerDisplay,
                                    readOnly: true,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      timer == "定時開"
                                          ? device.timer += 1
                                          : device.timer -= 1;
                                      device.update();
                                      timerDisplay.text = "${device.timer} hr";
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.remove)),
                              ],
                            ),
                          ],
                        ),
                        // ElevatedButton(
                        // onPressed: () {
                        //   RemoteModel remoteModel = RemoteModel();
                        //   remoteModel.data.putIfAbsent(
                        //       "on",
                        //       () => [
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             1,
                        //             0,
                        //             1,
                        //             1,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0,
                        //             0
                        //           ]);
                        //   remoteModel.launch = 2900;
                        //   remoteModel.low = 500;
                        //   remoteModel.high = 1550;
                        //   remoteModel.protocol = "room";
                        //   remoteModel.create();
                        // },
                        // child: const Text("test")),
                      ]),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 3.0,
                  ),
                  itemCount: keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GridTile(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (protoco == "Tatung") {
                              debugPrint("DD:${keys[index]}");
                              mqttService.send(
                                  '{"type":"ir_tx","data":"${keys[index]}","protocol":"$protoco","uuid":"$uuid"}');
                            } else {
                              debugPrint(
                                  "DD:${(buttonSet[device.type])![keys[index]]!}");
                              mqttService.send(
                                  '{"type":"ir_tx","data":"${(buttonSet[device.type])![keys[index]]!}","protocol":"$protoco","uuid":"$uuid"}');
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              keys[index],
                              style: const TextStyle(fontSize: 100),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(fit: BoxFit.scaleDown, child: Text("UUID: $uuid"))
          ],
        ),
      ),
    );
  }
}
