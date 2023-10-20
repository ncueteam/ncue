import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../item_system/data_item.dart';

class DeviceModel {
  DeviceModel(
    this.name,
    this.powerOn,
    this.uuid, {
    this.type = 'device',
    this.iconPath = 'assets/images/flutter_logo.png',
    this.temperature = 28.0,
  });

  final String name;
  bool powerOn;
  double temperature = 28.0;
  String uuid = const Uuid().v1();
  String type = 'device';
  String iconPath = 'assets/images/flutter_logo.png';

  void debugData() {
    debugPrint("=================================================");
    debugPrint("name: $name");
    debugPrint("powerOn: $powerOn");
    debugPrint("type: $type");
    debugPrint("uuid: $uuid");
    debugPrint("iconPath: $iconPath");
    debugPrint("temperature: ${temperature.toString()}");
    debugPrint("=================================================");
  }

  DataItem toDataItem() {
    return DataItem(type, [uuid], name: name, iconPath: iconPath, origin: this);
  }
}
