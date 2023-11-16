import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  UserModel(
      {this.name = "Error",
      this.uuid = "Error",
      this.type = "",
      this.language = "en_US",
      this.rooms = const <String>[],
      this.memberRooms = const <String>[]});

  String uuid;
  String name;
  String type;
  String language;
  List<String> rooms;
  List<String> memberRooms;
  void debugData() {
    debugPrint("name:$name");
    debugPrint("uuid:$uuid");
    debugPrint("language:$language");
    debugPrint("type:$type");
    debugPrint("rooms:$rooms");
    debugPrint("memberRooms:$memberRooms");
  }

  List<String> dynamicToStringList(List<dynamic> lst) {
    return (lst).map((item) => item as String).toList();
  }

  UserModel self() {
    return this;
  }

  Future<UserModel> create() async {
    await database.collection('users').add({
      'name': name,
      "type": type,
      "uuid": uuid,
      "language": language,
      "rooms": <String>[],
      "memberRooms": <String>[],
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
      language = lst['language'];
      rooms = dynamicToStringList(lst['rooms']);
      memberRooms = dynamicToStringList(lst['memberRooms']);
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
        "language": language,
        'rooms': rooms,
        'memberRooms': memberRooms
      };
      await documentReference.update(updatedData);
    } else {
      await create();
    }
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
      name = querySnapshot.docs[0].get('name');
      language = querySnapshot.docs[0].get('language');
      type = querySnapshot.docs[0].get('type');
      uuid = uuid;
      rooms = dynamicToStringList(querySnapshot.docs[0].get('rooms'));
      memberRooms =
          dynamicToStringList(querySnapshot.docs[0].get('memberRooms'));
      return this;
    } else {
      debugPrint("uuid found no user!");
      return this;
    }
  }

  Future<List<UserModel>> loadAll() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<UserModel> users = querySnapshot.docs.map((doc) {
      UserModel model = UserModel();
      model.name = doc.get('name');
      model.uuid = doc.get('uuid');
      model.language = doc.get('language');
      model.type = doc.get('type');
      model.rooms = dynamicToStringList(querySnapshot.docs[0].get('rooms'));
      model.memberRooms =
          dynamicToStringList(querySnapshot.docs[0].get('memberRooms'));
      return model;
    }).toList();
    return users;
  }
}
