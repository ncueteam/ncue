import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class UserModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  late String uuid;
  late String name;
  late String type;
  late String language;
  late List<String> rooms;
  late List<String> memberRooms;

  UserModel({String id = "Error"}) {
    name = "User temp name";
    uuid = id != "Error" ? id : RouteView.user!.uid;
    type = "user";
    language = "en_US";
    rooms = [];
    memberRooms = [];
  }

  UserModel self() {
    return this;
  }

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

  Map<String, dynamic> getDocument() {
    return {
      'name': name,
      // 'uuid': uuid,
      'type': type,
      'language': language,
      'rooms': rooms, //.map((item) => item.uuid),
      'memberRooms': memberRooms, //.map((item) => item.uuid),
    };
  }

  Future<UserModel> create() async {
    if (name == "User temp name") {
      name = RouteView.user!.displayName ??
          RouteView.user!.email ??
          RouteView.user?.uid ??
          name;
    }
    await database.collection('users').doc(uuid).set(getDocument());
    return this;
  }

  Future<UserModel> read({String id = ""}) async {
    if (id != "") uuid = id;
    try {
      Map<String, dynamic> data =
          (await database.collection('users').doc(uuid).get()).data()
              as Map<String, dynamic>;
      name = data['name'];
      type = data['type'];
      language = data['language'];
      rooms = dynamicToStringList(data['rooms']);
      memberRooms = dynamicToStringList(data['memberRooms']);
    } catch (e) {
      create();
    }

    return this;
  }

  Future<UserModel> update() async {
    DocumentReference data = database.collection('users').doc(uuid);
    try {
      data.update(getDocument());
    } catch (e) {
      create();
    }
    return this;
  }

  Future<List<UserModel>> loadAll() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<UserModel> users = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      UserModel model = UserModel();
      model.name = doc.get('name');
      model.uuid = doc.id;
      model.language = doc.get('language');
      model.type = doc.get('type');
      model.rooms = dynamicToStringList(doc.get('rooms'));
      // List<dynamic> roomsData = doc.get('rooms');
      // if (roomsData.isNotEmpty) {
      //   debugPrint("owns: ${roomsData.length}");
      //   for (String temp in roomsData) {
      //     model.rooms.add(await RoomModel().read(temp.toString()));
      //   }
      // }
      model.memberRooms = dynamicToStringList(doc.get('memberRooms'));
      // List<dynamic> memberRoomsData = doc.get('memberRooms');
      // if (memberRoomsData.isNotEmpty) {
      //   debugPrint("owns: ${memberRoomsData.length}");
      //   for (String temp in memberRoomsData) {
      //     model.memberRooms.add(await RoomModel().read(temp.toString()));
      //   }
      // }
      users.add(model);
    }
    return users;
  }
}
