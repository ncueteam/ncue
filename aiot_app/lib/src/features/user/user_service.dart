import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_model.dart';

class UserService {
  FirebaseFirestore database = FirebaseFirestore.instance;

  Future<UserModel> loadUserData(User user) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: user.uid).get();
    if (querySnapshot.size == 1) {
      QueryDocumentSnapshot lst = querySnapshot.docs.first;
      return UserModel(lst['name'], lst['uuid'],
          type: lst['type'], devices: lst['devices']);
    } else {
      return createUserData(UserModel(
        user.displayName ?? user.email ?? user.phoneNumber ?? user.uid,
        user.uid,
        type: "user",
      ));
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
      };
      await documentReference.update(updatedData);
    } else {
      createUserData(model);
    }
  }

  void addDevice(UserModel model, String deviceUUID) async {
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

  UserModel createUserData(UserModel model) {
    List<String> temp = [];
    database.collection('users').add({
      'name': model.name,
      "type": model.type,
      "uuid": model.uuid,
      "devices": temp,
    });
    return model;
  }
}
