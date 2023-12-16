import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/units/device_unit.dart';
import 'package:ncue.aiot_app/src/features/basic/units/dht11_unit.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:uuid/uuid.dart';

class DeviceModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;

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
  bool powerOn = false;
  double temperature = 28.0;
  String uuid = const Uuid().v1();
  String roomId = "Error Id";
  String type = 'switch';
  String subType = 'fan';
  String iconPath = 'assets/images/flutter_logo.png';
  bool authenticated = false;
  bool bioLocked = false;

  void debugData() {
    debugPrint("=================================================");
    debugPrint("name: $name");
    debugPrint("powerOn: $powerOn");
    debugPrint("type: $type");
    debugPrint("subType: $subType");
    debugPrint("uuid: $uuid");
    debugPrint("roomId: $roomId");
    debugPrint("iconPath: $iconPath");
    debugPrint("bioLocked: $bioLocked");
    debugPrint("temperature: ${temperature.toString()}");
    debugPrint("=================================================");
  }

  Widget getUnit(VoidCallback callback) {
    Widget result = Container();
    switch (type) {
      case "wet_degree_sensor":
        result = Dht11Unit(
          uuid: roomId,
        );
      case "switch":
        result = DeviceUnit(deviceModel: this, callback: callback);
      case "ir_controller":
        result = DeviceUnit(deviceModel: this, callback: callback);
      default:
        result = const UnitTile();
    }
    return result;
  }

  Map<String, dynamic> getDocument() {
    return {
      'uuid': uuid,
      'device_name': name,
      'roomId': roomId,
      'iconPath': iconPath,
      'type': type,
      'powerOn': powerOn,
      'temperature': temperature,
      'bioLocked': bioLocked,
      'subType': subType,
    };
  }

  Future<DeviceModel> create() async {
    DocumentReference documentReference =
        await database.collection('devices').add(getDocument());
    uuid = documentReference.id;
    await database.collection('devices').doc(uuid).update(getDocument());
    return this;
  }

  Future<DeviceModel> read(String uuidQuery) async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      if (result['uuid'] == uuidQuery) {
        name = result['device_name'];
        powerOn = result['powerOn'];
        uuid = result['uuid'];
        roomId = result['roomId'] ?? "error";
        iconPath = result['iconPath'];
        type = result['type'] ?? "device";
        temperature = result['temperature'] ?? 28;
        bioLocked = result['bioLocked'] ?? false;
        subType = result['subType'] ?? "fan";
      }
    }
    return this;
  }

  Future<void> update() async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot =
        await devices.where('uuid', isEqualTo: uuid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = devices.doc(documentSnapshot.id);
      await documentReference.update(getDocument());
    } else {
      create();
    }
  }

  Future<void> delete() async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      if (result['uuid'] == uuid) {
        RoomModel room = await RoomModel().read(roomId);
        room.devices.remove(uuid);
        await room.update();
        room.debugData();
        document.reference.delete();
      }
    }
  }

  Future<List<DeviceModel>> queryAll() async {
    List<DeviceModel> data = [];
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      DeviceModel temp = DeviceModel();
      temp.name = result['device_name'];
      temp.powerOn = result['powerOn'];
      temp.uuid = result['uuid'];
      temp.iconPath = result['iconPath'];
      temp.roomId = result['roomId'] ?? "error";
      temp.type = result['type'];
      temp.temperature = result['temperature'] ?? 28;
      temp.bioLocked = result['bioLocked'] ?? false;
      temp.subType = result['subType'] ?? "fan";
      data.add(temp);
    }
    return data;
  }
}
