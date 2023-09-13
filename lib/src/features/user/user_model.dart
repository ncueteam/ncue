import 'package:flutter/material.dart';

class UserModel {
  UserModel(this.name, this.uuid, {type = 'user'});
  final String uuid;
  final String name;
  final String type = 'user';

  void debugData() {
    debugPrint("name:$name");
    debugPrint("uuid:$uuid");
    debugPrint("type:$type");
  }
}
