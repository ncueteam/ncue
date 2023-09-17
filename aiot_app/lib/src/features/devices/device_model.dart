import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../item_system/data_item.dart';

class DeviceModel {
  DeviceModel(this.name, this.powerOn, this.uuid,
      {this.type = 'switch', this.iconPath = 'assets/images/flutter_logo.png'});

  final String name;
  bool powerOn;
  String uuid = const Uuid().v1();
  String type = 'switch';
  String iconPath = 'assets/images/flutter_logo.png';

  void debugData() {
    debugPrint("=================================================");
    debugPrint("name: $name");
    debugPrint("powerOn: $powerOn");
    debugPrint("type: $type");
    debugPrint("uuid: $uuid");
    debugPrint("iconPath: $iconPath");
    debugPrint("=================================================");
  }

  DataItem toDataItem() {
    return DataItem(type, [uuid], name, iconPath: iconPath, origin: this);
  }
}
