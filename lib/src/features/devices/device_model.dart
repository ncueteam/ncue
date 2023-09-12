import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/item_system/data_item.dart';
import 'package:uuid/uuid.dart';

class DeviceModel {
  DeviceModel(this.name, this.powerOn, this.uuid,
      {this.type = 'switch',
      this.iconPath = 'assets/images/flutter_logo.png',
      isisBioAuthcanted = false});

  final String name;
  bool powerOn;
  bool isBioAuthcanted = false;
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
    debugPrint("isBioAuthcanted: $isBioAuthcanted");
    debugPrint("=================================================");
  }

  DataItem toDataItem() {
    return DataItem(type, [uuid], name, iconPath: iconPath, origin: this);
  }
}
