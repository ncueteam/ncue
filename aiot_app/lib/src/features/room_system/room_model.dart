import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoomModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  RoomModel(this.owner, this.name, this.uuid,
      {this.type = "", this.devices = const []});

  String uuid;
  String name;
  String type;
  User owner;
  List<dynamic> devices;
  void debugData() {
    debugPrint("name:$name");
    debugPrint("uuid:$uuid");
    debugPrint("type:$type");
    debugPrint("devices:$devices");
  }

  Future<void> loadUserData(User user) async {
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
    } else {
      name = user.displayName ?? user.email ?? user.phoneNumber ?? user.uid;
      uuid = user.uid;
      type = "user";
    }
  }

  void updateUserData(RoomModel model, List<String> devices) async {
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
      };
      await documentReference.update(updatedData);
    } else {
      createUserData(model);
    }
  }

  Future<void> addDevice(RoomModel model, String deviceUUID) async {
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

  Future<void> createUserData(RoomModel model) async {
    List<String> temp = [];
    database.collection('users').add({
      'name': model.name,
      "type": model.type,
      "uuid": model.uuid,
      "devices": temp,
    });
  }
}
