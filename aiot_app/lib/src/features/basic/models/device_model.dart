import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/services/local_auth_service.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:ncue.aiot_app/src/features/devices/device_detail_view.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;

  DeviceModel({
    this.name = "Unnamed",
    this.powerOn = false,
    this.uuid = "error uuid",
    this.roomId = "error room id",
    this.type = 'device',
    this.iconPath = 'assets/images/flutter_logo.png',
    this.temperature = 28.0,
  });

  DeviceModel self() {
    return this;
  }

  String name = "error";
  bool powerOn = false;
  double temperature = 28.0;
  String uuid = const Uuid().v1();
  String roomId = const Uuid().v1();
  String type = 'device';
  String iconPath = 'assets/images/flutter_logo.png';
  bool authenticated = false;

  void debugData() {
    debugPrint("=================================================");
    debugPrint("name: $name");
    debugPrint("powerOn: $powerOn");
    debugPrint("type: $type");
    debugPrint("uuid: $uuid");
    debugPrint("roomId: $roomId");
    debugPrint("iconPath: $iconPath");
    debugPrint("temperature: ${temperature.toString()}");
    debugPrint("=================================================");
  }

  UnitTile getUnit(BuildContext context) {
    return UnitTile(
      title: Text(name),
      subtitle: Text("裝置類型: $type}"),
      leading: CircleAvatar(
        foregroundImage: AssetImage(iconPath),
        backgroundColor: Colors.white,
      ),
      trailing: type == "bio_device" && !authenticated
          ? IconButton(
              onPressed: () async {
                final authenticate = await LocalAuth.authenticate();
                authenticated = authenticate;
              },
              icon: const Icon(Icons.fingerprint))
          : Transform.rotate(
              angle: pi / 2,
              child: Switch(
                value: powerOn,
                onChanged: (bool value) => {
                  powerOn = value,
                  update(),
                },
              )),
      onTap: () {
        if (type == "bio_device") {
          if (authenticated) {
            Navigator.pushNamed(context, const DeviceDetailsView().routeName,
                arguments: {'data': this});
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.appTitle),
                    content: const Text("請先通過生物認證!"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('關閉'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          }
        } else if (type == "device") {
          Navigator.pushNamed(context, const DeviceDetailsView().routeName,
              arguments: {'data': this});
        }
      },
    );
  }

  Map<String, dynamic> getDocument() {
    return {
      'uuid': uuid,
      'device_name': name,
      'roomId': roomId,
      'iconPath': iconPath,
      'type': type,
      'powerOn': powerOn,
      "temperature": temperature,
    };
  }

  Future<DeviceModel> read(String uuidQuery) async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      if (result['uuid'] == uuidQuery) {
        name = result['device_name'];
        powerOn = result['powerOn'];
        uuid = result['uuid'];
        roomId = result['roomId'] ?? "error";
        iconPath = result['iconPath'];
        debugPrint(result['type']);
        type = result['type'] ?? "device";
        temperature = result['temperature'] ?? 28;
      }
    }
    return this;
  }

  Future<void> delete() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('devices');
    DocumentReference documentReference = collectionReference.doc(uuid);
    documentReference.delete();
  }

  Future<DeviceModel> create() async {
    await FirebaseFirestore.instance.collection('devices').add(getDocument());
    return this;
  }

  Future<void> update() async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot =
        await devices.where('uuid', isEqualTo: uuid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = devices.doc(documentSnapshot.id);
      await documentReference.update(getDocument());
    } else {
      create();
    }
  }

  Future<List<DeviceModel>> queryAll() async {
    List<DeviceModel> data = [];
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      data.add(DeviceModel(
        name: result['device_name'],
        powerOn: result['powerOn'],
        uuid: result['uuid'],
        iconPath: result['iconPath'],
        roomId: result['roomId'] ?? "error",
        type: result['type'],
        temperature: result['temperature'] ?? 28,
      ));
    }
    return data;
  }
}
