import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/route_view.dart';
import 'package:ncue.aiot_app/src/features/devices/device_model.dart';
import 'package:ncue.aiot_app/src/features/devices/device_service.dart';

class RoomModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  RoomModel(this.name, this.uuid,
      {List<String> addDeviceIDs = const [],
      List<DeviceModel> addDevices = const []}) {
    deviceIDs = [];
    deviceIDs.addAll(addDeviceIDs);
    devices = [];
    devices.addAll(addDevices);
    initialize();
  }

  String uuid;
  String name;
  User owner = RouteView.user!;
  List<DeviceModel> devices = [];
  List<String> deviceIDs = [];

  Future<void> initialize() async {
    await getDevices();
    owner = await RouteView.getUser();
  }

  void debugData() {
    debugPrint("name:$name");
    debugPrint("uuid:$uuid");
    debugPrint("devices:$deviceIDs");
  }

  Future<List<DeviceModel>> getDevices() async {
    for (String s in deviceIDs) {
      devices.add(await DeviceService().getDeviceFromUuid(s));
    }
    return devices;
  }

  Future<void> loadRoomData(String uuid) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('rooms');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: uuid).get();
    QueryDocumentSnapshot lst = querySnapshot.docs.first;
    name = lst['name'];
    uuid = lst['uuid'];
    deviceIDs = lst['devices'];

    for (String s in deviceIDs) {
      devices.add(await DeviceService().getDeviceFromUuid(s));
    }
  }

  void update() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('rooms');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: uuid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = reference.doc(documentSnapshot.id);

      Map<String, dynamic> updatedData = {
        'name': name,
        "uuid": uuid,
        'devices': deviceIDs,
      };
      await documentReference.update(updatedData);
    } else {
      create();
    }
  }

  void updateRoomData(RoomModel model, List<String> deviceIDs) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('rooms');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: model.uuid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = reference.doc(documentSnapshot.id);

      Map<String, dynamic> updatedData = {
        'name': model.name,
        "uuid": model.uuid,
        'devices': deviceIDs,
      };
      await documentReference.update(updatedData);
    } else {
      createRoomData(model);
    }
  }

  Future<void> addDevice(RoomModel model, String deviceUUID) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('rooms');
    QuerySnapshot querySnapshot =
        await usersCollection.where('uuid', isEqualTo: model.uuid).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentReference = querySnapshot.docs[0].reference;
      List<dynamic> currentDevices = querySnapshot.docs[0].get('devices') ?? [];
      currentDevices.add(deviceUUID);
      await documentReference.update({'devices': currentDevices});
    } else {
      debugPrint('Document with uuid "${model.uuid}" not found.');
    }
  }

  Future<void> createRoomData(RoomModel model) async {
    List<String> temp = [];
    database.collection('rooms').add({
      'name': model.name,
      "uuid": model.uuid,
      "devices": temp,
    });
  }

  Future<void> create() async {
    database.collection('rooms').add({
      'owner': owner.uid,
      'name': name,
      "uuid": uuid,
      "devices": deviceIDs,
    });
  }
}
