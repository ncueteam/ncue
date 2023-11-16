import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../data_item.dart';

class DeviceModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;

  DeviceModel({
    this.name = "Unnamed",
    this.powerOn = false,
    this.uuid = "error uuid",
    this.type = 'device',
    this.iconPath = 'assets/images/flutter_logo.png',
    this.temperature = 28.0,
  });

  DeviceModel self() {
    return this;
  }

  String name = "error";
  bool powerOn = false;
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
        iconPath = result['iconPath'];
        type = result['type'];
        temperature = result['temperature'] ?? 28;
      }
    }
    return this;
  }

  Future<void> create() async {
    await FirebaseFirestore.instance.collection('devices').add({
      'uuid': uuid,
      'device_name': name,
      'iconPath': iconPath,
      'powerOn': powerOn,
      "temperature": temperature,
    });
  }

  Future<void> update() async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot =
        await devices.where('uuid', isEqualTo: uuid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = devices.doc(documentSnapshot.id);

      Map<String, dynamic> updatedData = {
        'uuid': uuid,
        'device_name': name,
        'iconPath': iconPath,
        'powerOn': powerOn,
        "temperature": temperature,
      };
      await documentReference.update(updatedData);
    } else {
      create();
    }
  }

  Future<List<DeviceModel>> queryAll() async {
    List<DeviceModel> data = [];
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      data.add(DeviceModel(
        name: result['device_name'],
        powerOn: result['powerOn'],
        uuid: result['uuid'],
        iconPath: result['iconPath'],
        type: result['type'],
        temperature: result['temperature'] ?? 28,
      ));
    }
    return data;
  }
}
