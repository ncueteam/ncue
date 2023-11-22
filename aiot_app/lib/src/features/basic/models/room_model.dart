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

  RoomModel(
      {String roomName = "Error name",
      String id = "Error id",
      List<DeviceModel> addDevices = const [],
      List<String> addMembers = const [],
      String path = "assets/room/room1.jpg",
      String roomDescription = "no description"}) {
    name = roomName;
    uuid = id;
    devices = [];
    devices.addAll(addDevices);
    addMembers = [];
    addMembers.addAll(addMembers);
    imagePath = path;
    description = roomDescription;
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
    debugPrint("name:$name");
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
      "uuid": uuid,
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

  static Future<void> getDocIds() async {
    CollectionReference roomsRef =
        FirebaseFirestore.instance.collection('rooms');
    QuerySnapshot querySnapshot = await roomsRef.get();

    List<String> documentIds = [];
    for (DocumentSnapshot document in querySnapshot.docs) {
      documentIds.add(document.id);
    }
    debugPrint(documentIds.toString());
  }

  Future<RoomModel> newRead(String roomID) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rooms').doc(roomID);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
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

  Future<RoomModel> read(String roomID) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      if (result['uuid'] == roomID) {
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
            devices.add(await DeviceModel().read(D));
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
      await documentReference.update(getDocument());
    } else {
      create();
    }
  }
}
