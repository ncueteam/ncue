import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/devices/device_model.dart';
import 'package:ncue.aiot_app/src/features/devices/device_service.dart';
import 'package:ncue.aiot_app/src/features/basic/data_item.dart';

class RoomModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  String uuid = "Error";
  String name = "Error";
  String imagePath = "";
  String description = "";
  User owner = RouteView.user!;
  List<String> members = [];
  List<DeviceModel> devices = [];

  RoomModel(
      {String roomName = "Error name",
      String id = "Error id",
      List<DeviceModel> addDevices = const [],
      List<String> members = const [],
      String path = "assets/room/room1.jpg",
      String roomDescription = "no description"}) {
    name = roomName;
    uuid = id;
    devices = [];
    devices.addAll(addDevices);
    members = members;
    imagePath = path;
    description = roomDescription;
    initialize();
  }

  Future<void> initialize() async {
    owner = (await RouteView.getUser())!;
  }

  void debugData() {
    debugPrint("name:$name");
    debugPrint("name:$name");
    debugPrint("description:$description");
    debugPrint("imagePath:$imagePath");
    debugPrint("members:$members");
    debugPrint("devices:$devices");
  }

  DataItem toDataItem() {
    return DataItem("room", [this], name: name);
  }

  Future<void> loadRoomData(String uuid) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('rooms');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: uuid).get();
    QueryDocumentSnapshot lst = querySnapshot.docs.first;
    name = lst['name'];
    uuid = lst['uuid'];
    description = lst['description'];
    imagePath = lst['imagePath'];
    members = lst['members'];

    for (String s in lst['devices']) {
      devices.add(await DeviceService().getDeviceFromUuid(s));
    }
  }

  Future<RoomModel> getRoomFromUuid(String uuid) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      if (result['uuid'] == uuid) {
        List<dynamic> memberData = result['members'];
        if (memberData.isNotEmpty) {
          members = memberData.map((item) => item.toString()).toList();
        } else {
          members = [];
        }
        List<dynamic> deviceData = result['devices'];
        if (deviceData.isNotEmpty) {
          List<String> temp =
              deviceData.map((item) => item.toString()).toList();
          for (String D in temp) {
            devices.add(await DeviceService().getDeviceFromUuid(D));
          }
        } else {
          devices = [];
        }
        name = result['name'];
        uuid = result['uuid'];
        description = result['description'];
        imagePath = result['imagePath'];
        // debugData();
        return this;
      }
    }
    return this;
  }

  Future<void> update() async {
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
        'description': description,
        'imagePath': imagePath,
        'members': members,
        'devices': devices.map((item) => item.uuid),
      };
      await documentReference.update(updatedData);
    } else {
      create();
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
    database.collection('rooms').add({
      'name': model.name,
      "uuid": model.uuid,
      'description': model.description,
      'imagePath': model.imagePath,
      'members': model.members,
      "devices": <String>[],
    });
  }

  Future<void> create() async {
    database.collection('rooms').add({
      'owner': owner.uid,
      'name': name,
      "uuid": uuid,
      'description': description,
      'imagePath': imagePath,
      'members': members,
      "devices": devices.map((item) => item.uuid),
    });
  }
}
