import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/units/room_unit.dart';

class RoomModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  late String uuid;
  late String name;
  late String imagePath;
  late String description;
  late User owner;
  late List<String> members;
  late List<DeviceModel> devices;

  RoomModel({String id = "Error id"}) {
    name = "ErrorName";
    uuid = id;
    devices = [];
    members = [];
    imagePath = "assets/room/room1.jpg";
    description = "empty description";
    initialize();
  }

  RoomModel self() {
    return this;
  }

  Future<void> initialize() async {
    owner = (await RouteView.getUser())!;
  }

  void debugData() {
    debugPrint("name:$name");
    debugPrint("uuid:$uuid");
    debugPrint("description:$description");
    debugPrint("imagePath:$imagePath");
    debugPrint("members:$members");
    debugPrint("devices:$devices");
  }

  UnitTile getUnit() {
    return RoomUnit(roomData: this, onChanged: (x) {});
  }

  Map<String, dynamic> getDocument() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'members': members,
      'devices': devices.map((item) => item.uuid),
    };
  }

  Future<void> create() async {
    DocumentReference documentReference =
        await database.collection('rooms').add(getDocument());
    uuid = documentReference.id;
  }

  Future<RoomModel> read(String roomID) async {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('rooms').doc(roomID);
    DocumentSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      /* load member */
      List<dynamic> memberData = data['members'];
      if (memberData.isNotEmpty) {
        members = memberData.map((item) => item.toString()).toList();
      }
      /* load device */
      List<dynamic> deviceData = data['devices'];
      if (deviceData.isNotEmpty) {
        List<String> temp = deviceData.map((item) => item.toString()).toList();
        for (String D in temp) {
          devices.add(await DeviceModel().read(D));
        }
      }
      /* others */
      name = data['name'];
      description = data['description'];
      imagePath = data['imagePath'];
      uuid = roomID;
    }
    return this;
  }

  Future<void> update() async {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('rooms').doc(uuid);
    DocumentSnapshot snapshot = await reference.get();
    if (snapshot.exists) {
      snapshot.reference.update(getDocument());
    } else {
      create();
    }
  }

  static Future<void> getDocIds() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('rooms');
    QuerySnapshot snapshot = await reference.get();

    List<String> documentIds = [];
    for (DocumentSnapshot document in snapshot.docs) {
      documentIds.add(document.id);
    }
    debugPrint(documentIds.toString());
  }
}
