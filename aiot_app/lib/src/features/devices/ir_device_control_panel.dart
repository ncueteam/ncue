import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/remote_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/services/mqtt_service.dart';

class IRDeviceControlPanel extends RouteView {
  final String uuid;
  const IRDeviceControlPanel({key, this.uuid = ""})
      : super(key, routeIcon: Icons.speaker_phone, routeName: "/ir-control");

  @override
  State<IRDeviceControlPanel> createState() => _IRDeviceControlPanelState();
}

class _IRDeviceControlPanelState extends State<IRDeviceControlPanel> {
  bool check = false;
  late MQTTService mqttService;

  DeviceModel device = DeviceModel();

  late List<String> keys = [];

  /*--------------------------遙控器內容------------------------------*/

  TextEditingController temperatureDisplay = TextEditingController();

  String timer = "";

  TextEditingController timerDisplay = TextEditingController();

  String protoco = "";

  List<String> protocos = [];
  /*--------------------------遙控器資料------------------------------*/
  Map<String, RemoteModel> models = {};
  RemoteModel tatung = RemoteModel(
      iLaunch: 2900,
      iProtocol: "Room",
      iLow: 500,
      iHigh: 1550,
      iData: {
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
  RemoteModel nec16 = RemoteModel(
      iLaunch: 9200,
      iProtocol: "NEC16",
      iLow: 600,
      iHigh: 1620,
      iData: {
        "fan_power": [
          9170,
          4438,
          548,
          592,
          573,
          564,
          551,
          590,
          570,
          569,
          619,
          520,
          548,
          593,
          549,
          590,
          549,
          589,
          550,
          1695,
          552,
          1694,
          550,
          1694,
          550,
          1695,
          551,
          1695,
          549,
          1694,
          552,
          1695,
          576,
          1668,
          577,
          564,
          577,
          565,
          575,
          567,
          575,
          563,
          577,
          565,
          576,
          564,
          576,
          565,
          577,
          566,
          575,
          1702,
          544,
          1701,
          541,
          1704,
          542,
          1708,
          586,
          1651,
          594,
          1650,
          594,
          1652,
          619,
          1624,
          594
        ],
        "humidifier_power": [
          9096,
          4648,
          450,
          629,
          566,
          585,
          568,
          602,
          569,
          630,
          544,
          629,
          547,
          625,
          547,
          603,
          571,
          628,
          544,
          1687,
          571,
          1706,
          548,
          1708,
          545,
          1686,
          545,
          1734,
          547,
          1684,
          571,
          1709,
          545,
          1710,
          545,
          628,
          546,
          627,
          546,
          627,
          547,
          629,
          544,
          626,
          545,
          630,
          668,
          503,
          548,
          625,
          546,
          1690,
          566,
          1686,
          569,
          1709,
          546,
          1686,
          568,
          1708,
          546,
          1710,
          571,
          1684,
          546,
          1685,
          566
        ],
        "humidifier_light": [
          9168,
          4460,
          551,
          652,
          610,
          564,
          609,
          563,
          613,
          560,
          612,
          561,
          612,
          562,
          612,
          605,
          568,
          560,
          614,
          1642,
          612,
          1643,
          611,
          1643,
          612,
          1644,
          611,
          1642,
          612,
          1642,
          613,
          1643,
          612,
          1642,
          612,
          563,
          611,
          1642,
          611,
          562,
          614,
          1641,
          612,
          561,
          612,
          560,
          613,
          561,
          613,
          560,
          612,
          1641,
          613,
          562,
          612,
          1642,
          611,
          562,
          612,
          1642,
          613,
          1642,
          613,
          1641,
          714,
          1540,
          614
        ]
      });
  RemoteModel hitachi = RemoteModel(
      iLaunch: 3274,
      iProtocol: "HITACHI",
      iLow: 331,
      iHigh: 466,
      iData: {
        "on": [
          3274,
          1680,
          331,
          1363,
          331,
          561,
          456,
          464,
          519,
          403,
          458,
          463,
          457,
          466,
          456,
          496,
          329,
          589,
          454,
          466,
          456,
          465,
          457,
          465,
          456,
          465,
          458,
          1265,
          331,
          560,
          458,
          464,
          457,
          496,
          354,
          562,
          457,
          496,
          426,
          484,
          438,
          464,
          457,
          465,
          456,
          465,
          457,
          465,
          457,
          491,
          455,
          466,
          455,
          466,
          456,
          465,
          457,
          467,
          453,
          467,
          456,
          465,
          456,
          1265,
          331,
          588,
          456,
          1265,
          330,
          1363,
          332,
          1362,
          330,
          1363,
          452,
          1240,
          331,
          1363,
          330,
          563,
          457,
          1289,
          331,
          1362,
          331,
          1363,
          329,
          1362,
          333,
          1361,
          331,
          1362,
          331,
          1362,
          331,
          1362,
          331,
          1387,
          332,
          566,
          451,
          469,
          453,
          496,
          329,
          593,
          328,
          593,
          329,
          591,
          399,
          523,
          329,
          617,
          332,
          591,
          329,
          593,
          329,
          1387,
          306,
          1362,
          331,
          591,
          331,
          591,
          330,
          1361,
          331,
          1389,
          330,
          1363,
          330,
          1362,
          332,
          591,
          331,
          589,
          331,
          1362,
          332,
          1361,
          331,
          592,
          330,
          616,
          331,
          591,
          330,
          1383,
          312,
          589,
          332,
          589,
          331,
          1362,
          332,
          590,
          331,
          591,
          330
        ]
      });
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
    if (!check) {
      Map<String, dynamic> arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      if (arguments['data'] is DeviceModel) {
        device = arguments['data'] as DeviceModel;
      }
      keys = (buttonSet[device.subType])!.keys.toList();
      mqttService = MQTTService('AppSend');
      temperatureDisplay.text = "${device.temperature}°C";
      device.timer > 0
          ? timer = "定時關"
          : device.timer == 0
              ? timer = "定時"
              : timer = "定時開";
      timerDisplay.text = "${device.timer.abs()} hr";
      List<String> x = await RemoteModel.idList();
      for (String item in x) {
        RemoteModel temp = await RemoteModel().read(item);
        models.update(item, (value) => temp, ifAbsent: () => temp);
      }
      protocos = x;
      protoco = protocos[0];
      check = !check;
    }
  }

  @override
  void dispose() {
    mqttService.port.disconnect();
    super.dispose();
  }

  Map<String, Map<String, String>> buttonSet = {
    "fan": {
      "power": "0x00",
      "light": "0x02",
      "wave +": "0x0e",
      "wave -": "0x12",
      "head": "0x0c",
      "mode": "0x04",
    },
    "humidifier": {
      "power": "power",
      "light": "light",
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
    },
    "HITACHI": {}
  };

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

  Widget getUI(String deviceType) {
    reload(context).whenComplete(() => setState(() {}));
    switch (deviceType) {
      case "AC":
        {
          return Padding(
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
                ]),
          );
        }
      case "humidifier":
        {
          Map<String, String> temp = {
            "power":
                '{"type":"ir_tx","data":"${nec16.data["humidifier_power"].toString()}","protocol":"$protoco","uuid":"${device.roomId}"}',
            "light":
                '{"type":"ir_tx","data":"${nec16.data["humidifier_light"].toString()}","protocol":"$protoco","uuid":"${device.roomId}"}',
            "power2":
                '{"type":"ir_tx","data":"${models.keys.contains(protoco) ? models[protoco]!.data["${deviceType}_power"] : "error"}","protocol":"$protoco","uuid":"${device.roomId}"}'
          };
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
              ),
              itemCount: temp.length,
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        mqttService.send(temp.values.elementAt(index));
                      },
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          temp.keys.elementAt(index),
                          style: const TextStyle(fontSize: 100),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
      case "TV":
        {
          return GridView.builder(
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
                      onPressed: () {},
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
              });
        }
      case "fan":
        {
          return GridView.builder(
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
                        switch (protoco) {
                          case "room":
                            {
                              mqttService.send(
                                  '{"type":"ir_tx","data":"${hitachi.data["on"].toString()}","protocol":"$protoco","uuid":"${device.roomId}"}');
                            }
                          case "Tatung":
                            {
                              mqttService.send(
                                  '{"type":"ir_tx","data":"${keys[index]}","protocol":"$protoco","uuid":"${device.roomId}"}');
                            }
                          case "NEC16":
                            {
                              if (device.subType == "fan") {
                                // debugPrint(keys[index]);
                                switch (keys[index]) {
                                  case "power":
                                    mqttService.send(
                                        '{"type":"ir_tx","data":"${nec16.data["fan_power"].toString()}","protocol":"$protoco","uuid":"${device.roomId}"}');
                                  default:
                                    mqttService.send(
                                        '{"type":"ir_tx","data":"${nec16.data["fan_power"].toString()}","protocol":"$protoco","uuid":"${device.roomId}"}');
                                }
                              }
                            }
                          default:
                            mqttService.send(
                                '{"type":"ir_tx","data":"[0,0,0,0]","protocol":"error","uuid":"${device.roomId}"}');
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
              });
        }
      default:
        {
          return const Center(child: Text("Error"));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          check = false;
          await reload(context);
        },
        child: Padding(
            padding: const EdgeInsets.all(6.0), child: getUI(device.subType)),
      ),
    );
  }
}
