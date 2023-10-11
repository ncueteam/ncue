import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';

class UserModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  UserModel(this.name, this.uuid,
      {this.type = "", this.devices = const [], this.rooms = const []});

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
    return UserModel(name, uuid, type: type, devices: devices, rooms: rooms);
  }

  Future<void> load(User user) async {
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
    } else {
      name = user.displayName ?? user.email ?? user.phoneNumber ?? user.uid;
      uuid = user.uid;
      type = "user";
    }
  }

  void updateUserData(UserModel model, List<String> devices) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: model.uuid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = reference.doc(documentSnapshot.id);

      Map<String, dynamic> updatedData = {
        'name': model.name,
        "type": model.type,
        "uuid": model.uuid,
        'devices': devices,
        'rooms': rooms
      };
      await documentReference.update(updatedData);
    } else {
      createUserData(model);
    }
  }

  Future<void> addDevice(UserModel model, String deviceUUID) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
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

  // void addDevice(UserModel model, String deviceUUID) async {
  //   CollectionReference usersCollection =
  //       FirebaseFirestore.instance.collection('users');
  //   QuerySnapshot querySnapshot =
  //       await usersCollection.where('uuid', isEqualTo: model.uuid).get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     DocumentReference documentReference = querySnapshot.docs[0].reference;
  //     List<dynamic> currentDevices = querySnapshot.docs[0].get('devices') ?? [];
  //     currentDevices.add(deviceUUID);
  //     await documentReference.update({'devices': currentDevices});
  //   } else {
  //     debugPrint('Document with uuid "${model.uuid}" not found.');
  //   }
  // }

  void addRoom(UserModel model, String roomUUID) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await usersCollection.where('uuid', isEqualTo: model.uuid).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentReference = querySnapshot.docs[0].reference;
      List<dynamic> currentRooms = querySnapshot.docs[0].get('rooms') ?? [];
      debugPrint("room not empty!\n$currentRooms");
      currentRooms.add(roomUUID);
      await documentReference.update({'rooms': currentRooms});
    } else {
      debugPrint('Document with user uuid "${model.uuid}" not found.');
    }
  }

  Future<void> createUserData(UserModel model) async {
    List<String> temp = [];
    database.collection('users').add({
      'name': model.name,
      "type": model.type,
      "uuid": model.uuid,
      "devices": temp,
      "rooms": temp,
    });
  }
}
