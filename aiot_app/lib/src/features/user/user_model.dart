import 'package:flutter/material.dart';

class UserModel {
  UserModel(this.name, this.uuid, {this.type = "", this.devices = const []});
  final String uuid;
  final String name;
  final String type;
  final List<dynamic> devices;
  void debugData() {
    debugPrint("name:$name");
    debugPrint("uuid:$uuid");
    debugPrint("type:$type");
    debugPrint("devices:$devices");
  }
}
