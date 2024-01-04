import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/remote_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';
import 'package:uuid/uuid.dart';

class IRDeviceControlPanel extends RouteView {
  final String uuid;
  const IRDeviceControlPanel({key, this.uuid = ""})
      : super(key, routeIcon: Icons.speaker_phone, routeName: "/ir-control");

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

  /*--------------------------遙控器資料------------------------------*/
  RemoteModel tatung = RemoteModel(2900, "room", 500, 1550, {
    "init": [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ]
  });
  RemoteModel nec16 = RemoteModel(9200, "nec16", 600, 1620, {});
  List<int> code = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
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
  List<String> protocos = ["NEC8", "NEC16", "sony", "Philip", "Tatung", "room"];

  void encodeSend() {
    if (protoco == "room") {
      code[10] = (device.temperature ~/ 10) ~/ 2;
      code[11] = (device.temperature ~/ 10) % 2;
      int tmp = device.temperature.round() % 10;
      code[12] = tmp ~/ 8;
      tmp = tmp % 8;
      code[13] = tmp ~/ 4;
      tmp = tmp % 4;
      code[14] = tmp ~/ 2;
      tmp = tmp % 2;
      code[15] = tmp;
      if (device.timer < 0) {
        int tmp2 = device.timer * -1;
        code[28] = tmp2 ~/ 8;
        tmp2 %= 8;
        code[29] = tmp2 ~/ 4;
        tmp2 %= 4;
        code[30] = tmp2 ~/ 2;
        tmp2 %= 2;
        code[31] = tmp2;
        code[36] = 0;
        code[37] = 0;
        code[38] = 0;
        code[39] = 0;
      } else {
        int tmp2 = device.timer;
        code[28] = 0;
        code[29] = 0;
        code[30] = 0;
        code[31] = 0;
        code[36] = tmp2 ~/ 8;
        tmp2 %= 8;
        code[37] = tmp2 ~/ 4;
        tmp2 %= 4;
        code[38] = tmp2 ~/ 2;
        tmp2 %= 2;
        code[39] = tmp2;
      }
      // debugPrint(tatung.getCodeFromData(code).toString());
      mqttService.send(
          '{"type":"ir_tx","data":"${tatung.getCodeFromData(code)}","protocol":"$protoco","uuid":"${device.roomId}"}');
    } else {
      // debugPrint(tatung.getCodeFromData(code).toString());
      code = [
        9198,
        4446,
        614,
        587,
        555,
        533,
        624,
        520,
        621,
        521,
        615,
        528,
        607,
        537,
        624,
        519,
        581,
        564,
        611,
        1636,
        604,
        1644,
        606,
        1643,
        618,
        1631,
        578,
        1668,
        581,
        1668,
        616,
        1633,
        624,
        1622,
        621,
        522,
        616,
        526,
        610,
        537,
        674,
        467,
        614,
        530,
        615,
        526,
        612,
        533,
        622,
        522,
        620,
        1624,
        603,
        1645,
        643,
        1635,
        589,
        1626,
        614,
        1634,
        617,
        1629,
        616,
        1631,
        615,
        1635,
        639
      ];
      mqttService.send(
          '{"type":"ir_tx","data":"${nec16.getCodeFromData(code)}","protocol":"$protoco","uuid":"${device.roomId}"}');
    }
  }

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
                "遙控器 協定",
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
                                onPressed: () {
                                  encodeSend();
                                },
                                child: const Text("風向")),
                            ElevatedButton(
                                onPressed: () {
                                  encodeSend();
                                },
                                child: const Text("風量")),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      device.temperature += 1;
                                      encodeSend();
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
                                      encodeSend();
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
                            onPressed: () {
                              code[22] = (code[22] + 1) % 2;
                            },
                            child: const Icon(Icons.power_settings_new)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  code[5] = 0;
                                  code[6] = 0;
                                  code[7] = 1;
                                  encodeSend();
                                },
                                child: const Text("除溼")),
                            ElevatedButton(
                                onPressed: () {
                                  code[5] = 1;
                                  code[6] = 0;
                                  code[7] = 1;
                                  encodeSend();
                                },
                                child: const Text("送風")),
                            ElevatedButton(
                                onPressed: () {
                                  code[5] = 0;
                                  code[6] = 0;
                                  code[7] = 0;
                                  encodeSend();
                                },
                                child: const Text("冷氣")),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  device.timer *= -1;
                                  encodeSend();
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
                            String rst = "";
                            if (protoco == "Tatung") {
                              rst = keys[index];
                              mqttService.send(
                                  '{"type":"ir_tx","data":"${keys[index]}","protocol":"$protoco","uuid":"${device.roomId}"}');
                            } else {
                              rst = (buttonSet[device.subType])![keys[index]]!;
                              mqttService.send(
                                  '{"type":"ir_tx","data":"${(buttonSet[device.subType])![keys[index]]!}","protocol":"$protoco","uuid":"${device.roomId}"}');
                            }
                            debugPrint("${device.roomId}:$rst");
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
