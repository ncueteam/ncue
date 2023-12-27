import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/units/device_unit.dart';
import 'package:ncue.aiot_app/src/features/basic/units/dht11_unit.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class DeviceModel {
  DeviceModel(
      {this.name = "Unnamed",
      this.powerOn = false,
      this.uuid = "error uuid",
      this.roomId = "error room id",
      this.type = 'device',
      this.iconPath = 'assets/images/flutter_logo.png',
      this.temperature = 28.0,
      this.subType = "fan"});

  DeviceModel self() {
    return this;
  }

  String name = "error";
  String uuid = "error id";
  String roomId = "Error Id";
  String type = 'switch';
  String iconPath = 'assets/images/flutter_logo.png';
  bool authenticated = false;
  bool bioLocked = false;

  bool powerOn = false;
  String subType = 'fan';
  double temperature = 28.0;
  int timer = 0;

  void debugData() {
    debugPrint("=================================================");
    debugPrint("name: $name");
    debugPrint("type: $type");
    debugPrint("uuid: $uuid");
    debugPrint("roomId: $roomId");
    debugPrint("iconPath: $iconPath");
    debugPrint("bioLocked: $bioLocked");

    debugPrint("temperature: ${temperature.toString()}");
    debugPrint("powerOn: $powerOn");
    debugPrint("subType: $subType");
    debugPrint("timer: $timer");
    debugPrint("=================================================");
  }

  Widget getUnit(VoidCallback callback) {
    Widget result = Container();
    switch (type) {
      case "wet_degree_sensor":
        result = Dht11Unit(
          uuid: roomId,
        );
      case "slide_device":
      case "switch":
      case "ir_controller":
        result = DeviceUnit(deviceModel: this, callback: callback);
      default:
        result = const UnitTile();
    }
    return result;
  }

  Map<String, dynamic> getDocument() {
    return {
      'device_name': name,
      'roomId': roomId,
      'iconPath': iconPath,
      'type': type,
      'powerOn': powerOn,
      'temperature': temperature,
      'bioLocked': bioLocked,
      'subType': subType,
      'timer': timer,
    };
  }

  Future<DeviceModel> create() async {
    DocumentReference documentReference =
        await RouteView.database.collection('devices').add(getDocument());
    uuid = documentReference.id;
    await RouteView.database
        .collection('devices')
        .doc(uuid)
        .update(getDocument());
    return this;
  }

  Future<DeviceModel> read(String uuidQuery) async {
    DocumentReference reference =
        RouteView.database.collection('devices').doc(uuidQuery);
    DocumentSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      name = data['device_name'];
      powerOn = data['powerOn'];
      uuid = uuidQuery;
      roomId = data['roomId'] ?? "error";
      iconPath = data['iconPath'];
      type = data['type'] ?? "device";
      temperature = data['temperature'] ?? 28;
      bioLocked = data['bioLocked'] ?? false;
      subType = data['subType'] ?? "fan";
      timer = data['timer'] ?? 0;
    }
    return this;
  }

  Future<DeviceModel> update() async {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('devices').doc(uuid);
    DocumentSnapshot snapshot = await reference.get();
    if (snapshot.exists) {
      snapshot.reference.update(getDocument());
    } else {
      create();
    }
    return this;
  }

  Future<void> delete() async {
    RoomModel room = await RoomModel().read(roomId);
    room.devices.remove(uuid);
    await room.update();
    await RouteView.database.collection('devices').doc(uuid).delete();
  }

  static Future<List<DeviceModel>> queryAll() async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot snapshot = await devices.get();
    List<DeviceModel> data = [];

    for (QueryDocumentSnapshot document in snapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      DeviceModel temp = DeviceModel();
      temp.uuid = document.reference.id;
      temp.name = result['device_name'];
      temp.powerOn = result['powerOn'];
      temp.iconPath = result['iconPath'];
      temp.roomId = result['roomId'] ?? "error";
      temp.type = result['type'];
      temp.temperature = result['temperature'] ?? 28;
      temp.bioLocked = result['bioLocked'] ?? false;
      temp.subType = result['subType'] ?? "fan";
      temp.timer = result['timer'] ?? 0;
      data.add(temp);
    }
    return data;
  }
}
