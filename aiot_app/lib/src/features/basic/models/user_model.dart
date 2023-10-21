import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  UserModel(
      {this.name = "Error",
      this.uuid = "Error",
      this.type = "",
      this.devices = const [],
      this.rooms = const []});

  String uuid;
  String name;
  String type;
  List<dynamic> devices;
  List<dynamic> rooms;
  void debugData() {
    debugPrint("name:$name");
    debugPrint("uuid:$uuid");
    debugPrint("type:$type");
    debugPrint("devices:$devices");
    debugPrint("rooms:$rooms");
  }

  UserModel self() {
    return this;
  }

  Future<UserModel> create() async {
    database.collection('users').add({
      'name': name,
      "type": type,
      "uuid": uuid,
      "devices": <String>[],
      "rooms": <String>[],
    });
    return this;
  }

  Future<UserModel> load(User user) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: user.uid).get();
    if (querySnapshot.size == 1) {
      QueryDocumentSnapshot lst = querySnapshot.docs.first;
      name = lst['name'];
      uuid = lst['uuid'];
      type = lst['type'];
      devices = lst['devices'];
      rooms = lst['rooms'];
      return this;
    } else {
      name = user.displayName ?? user.email ?? user.phoneNumber ?? user.uid;
      uuid = user.uid;
      type = "user";
      return this;
    }
  }

  Future<UserModel> update() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: uuid).get();
    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = reference.doc(documentSnapshot.id);

      Map<String, dynamic> updatedData = {
        'name': name,
        "type": type,
        "uuid": uuid,
        'devices': devices,
        'rooms': rooms
      };
      await documentReference.update(updatedData);
    } else {
      create();
    }
    return this;
  }

  Future<UserModel> addDevice(String deviceUUID) async {
    devices.add(deviceUUID);
    update();
    return this;
  }

  Future<UserModel> addRoom(String roomUUID) async {
    rooms.add(roomUUID);
    update();
    return this;
  }

  Future<UserModel> fromID(String uuid) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await usersCollection.where('uuid', isEqualTo: uuid).get();
    if (querySnapshot.docs.isNotEmpty) {
      UserModel model = UserModel(name: name, uuid: uuid);
      model.name = querySnapshot.docs[0].get('name');
      model.type = querySnapshot.docs[0].get('type');
      model.uuid = uuid;
      model.rooms = model.type = querySnapshot.docs[0].get('rooms');
      return model;
    } else {
      debugPrint("uuid found no user!");
      return this;
    }
  }
}
