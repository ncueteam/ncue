import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ncue.aiot_app/src/features/bluetooth/flutter_blue_app.dart';
import "../utils/snackbar.dart";
import "descriptor_tile.dart";

const String characteristicuuid = "9012";
//"0x9012"; //00009012-0000-1000-8000-00805f9b34fb

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile(
      {Key? key, required this.characteristic, required this.descriptorTiles})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription =
        widget.characteristic.lastValueStream.listen((value) {
      _value = value;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothCharacteristic get c => widget.characteristic;

  // List<int> _getRandomBytes() {
  //   var wifiData = '${wifiNameController.text},${wifiPasswordController.text}';
  //   List<int> bytes = utf8.encode(wifiData);
  //   return bytes;
  // }

  List<int> _getWifiBytes() {
    var wifiData = '${wifiNameController.text},${wifiPasswordController.text}';
    List<int> bytes = utf8.encode(wifiData);
    return bytes;
  }

  /*---------------------------------------- custom data --------------------------------------*/

  // List<int> _getAllDataBytes() {
  //   List<int> bytes = utf8.encode(
  //       "ssid:${wifiNameController.text},pswd:${wifiPasswordController.text},uuid:$roomId");
  //   return bytes;
  // }

  List<int> _getWifiSsidBytes() {
    var wifiData = 'ssid:${wifiNameController.text}';
    List<int> bytes = utf8.encode(wifiData);
    return bytes;
  }

  List<int> _getWifiPswdBytes() {
    var wifiData = 'pswd:${wifiPasswordController.text}';
    List<int> bytes = utf8.encode(wifiData);
    return bytes;
  }

  List<int> _getUuidByte_1() {
    var uuidData = 'id_1:${roomId.substring(0, 10)}';
    List<int> bytes = utf8.encode(uuidData);
    return bytes;
  }

  List<int> _getUuidByte_2() {
    var uuidData = 'id_2:${roomId.substring(10)}';
    List<int> bytes = utf8.encode(uuidData);
    return bytes;
  }
  /*---------------------------------------------------------------------------------------*/

  Future onReadPressed() async {
    try {
      await c.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await c.write(_getWifiBytes(),
          withoutResponse: c.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  Future onWritePressedCustom(List<int> input, String name) async {
    try {
      await c.write(
        input,
        withoutResponse: c.properties.writeWithoutResponse,
        allowLongWrite: true,
      );
      Snackbar.show(ABC.c, "[$name]Write: Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("[$name]Write Error:", e),
          success: false);
    }
  }

  // Future onWritePressedCustom_1() async {
  //   try {
  //     await c.write(_getWifiSsidBytes(),
  //         withoutResponse: c.properties.writeWithoutResponse);
  //     Snackbar.show(ABC.c, "Write: Success", success: true);
  //     if (c.properties.read) {
  //       await c.read();
  //     }
  //   } catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
  //   }
  // }

  // Future onWritePressedCustom_2() async {
  //   try {
  //     await c.write(_getWifiPswdBytes(),
  //         withoutResponse: c.properties.writeWithoutResponse);
  //     Snackbar.show(ABC.c, "Write: Success", success: true);
  //     if (c.properties.read) {
  //       await c.read();
  //     }
  //   } catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
  //   }
  // }

  // Future onWritePressedCustom_3() async {
  //   try {
  //     await c.write(_getUuidByte_1(),
  //         withoutResponse: c.properties.writeWithoutResponse);
  //     Snackbar.show(ABC.c, "Write: Success", success: true);
  //     if (c.properties.read) {
  //       await c.read();
  //     }
  //   } catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
  //   }
  // }

  // Future onWritePressedCustom_4() async {
  //   try {
  //     await c.write(_getUuidByte_2(),
  //         withoutResponse: c.properties.writeWithoutResponse);
  //     Snackbar.show(ABC.c, "Write: Success", success: true);
  //     if (c.properties.read) {
  //       await c.read();
  //     }
  //   } catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
  //   }
  // }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotifying == false ? "Subscribe" : "Unubscribe";
      await c.setNotifyValue(c.isNotifying == false);
      Snackbar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
      setState(() {});
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
          success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: const Text("Read"),
        onPressed: () async {
          await onReadPressed();
          setState(() {});
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return ElevatedButton(
        child: Text(withoutResp ? "WriteNoResp" : "Submit"),
        onPressed: () async {
          // await onWritePressed();
          // await onWritePressedCustom(_getAllDataBytes(), "data");
          await onWritePressedCustom(_getWifiSsidBytes(), "wifi ssid");
          await onWritePressedCustom(_getWifiPswdBytes(), "wifi password");
          await onWritePressedCustom(_getUuidByte_1(), "uuid part 1");
          await onWritePressedCustom(_getUuidByte_2(), "uuid part 2");
          setState(() {});
        });
  }

  // Widget buildWriteButton2(BuildContext context) {
  //   bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
  //   return ElevatedButton(
  //       child: Text(withoutResp ? "WriteNoResp" : "uuid send"),
  //       onPressed: () async {
  //         await onWritePressed2();
  //         setState(() {});
  //       });
  // }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        onPressed: () async {
          await onSubscribePressed();
          setState(() {});
        });
  }

  Widget buildButtonRow(BuildContext context) {
    // bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    // bool notify = widget.characteristic.properties.notify;
    // bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        // buildWriteButton2(context),
        //if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.characteristic.characteristicUuid.toString().toLowerCase() ==
        characteristicuuid.toLowerCase()) {
      // if (widget.characteristic.characteristicUuid.toString().toLowerCase() ==
      //         9012 ||
      //     widget.characteristic.characteristicUuid.toString().toLowerCase() ==
      //         9013) {
      return ExpansionTile(
        title: ListTile(
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Characteristic'),
              //buildUuid(context),
              //buildValue(context),
            ],
          ),
          subtitle: buildButtonRow(context),
          contentPadding: const EdgeInsets.all(0.0),
        ),
        //children: widget.descriptorTiles,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
