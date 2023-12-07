import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/services/local_auth_service.dart';
import 'package:ncue.aiot_app/src/features/basic/units/dht11_unit.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:ncue.aiot_app/src/features/devices/device_detail_view.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceModel {
  static FirebaseFirestore database = FirebaseFirestore.instance;

  DeviceModel(
      {this.name = "Unnamed",
      this.powerOn = false,
      this.uuid = "error uuid",
      this.roomId = "error room id",
      this.type = 'device',
      this.iconPath = 'assets/images/flutter_logo.png',
      this.temperature = 28.0,
      this.subType = "fan"});

  DeviceModel self() {
    return this;
  }

  String name = "error";
  bool powerOn = false;
  double temperature = 28.0;
  String uuid = const Uuid().v1();
  String roomId = const Uuid().v1();
  String type = 'switch';
  String subType = 'fan';
  String iconPath = 'assets/images/flutter_logo.png';
  bool authenticated = false;
  bool bioLocked = false;

  void debugData() {
    debugPrint("=================================================");
    debugPrint("name: $name");
    debugPrint("powerOn: $powerOn");
    debugPrint("type: $type");
    debugPrint("subType: $subType");
    debugPrint("uuid: $uuid");
    debugPrint("roomId: $roomId");
    debugPrint("iconPath: $iconPath");
    debugPrint("bioLocked: $bioLocked");
    debugPrint("temperature: ${temperature.toString()}");
    debugPrint("=================================================");
  }

  UnitTile getUnit(BuildContext context, VoidCallback callback) {
    switch (type) {
      case "wet_degree_sensor":
        return Dht11Unit(
          uuid: uuid,
        );
      case "switch":
        return UnitTile(
          title: Text(name),
          subtitle: const Text("裝置類型:開關"),
          leading: CircleAvatar(
            foregroundImage: AssetImage(iconPath),
            backgroundColor: Colors.white,
          ),
          trailing: Transform.rotate(
              angle: pi / 2,
              child: Switch(
                value: powerOn,
                onChanged: (bool value) async => {
                  powerOn = !powerOn,
                  await update().then(
                    (e) {
                      callback();
                    },
                  )
                },
              )),
          onTap: () {
            Navigator.pushNamed(context, const DeviceDetailsView().routeName,
                arguments: {'data': this});
          },
        );
      case "bio_device":
        return UnitTile(
          title: Text(name),
          subtitle: const Text("裝置類型: 生物解鎖裝置"),
          leading: CircleAvatar(
            foregroundImage: AssetImage(iconPath),
            backgroundColor: Colors.white,
          ),
          trailing: !authenticated
              ? IconButton(
                  onPressed: () async {
                    final authenticate = await LocalAuth.authenticate();
                    authenticated = authenticate;
                    callback();
                  },
                  icon: const Icon(Icons.fingerprint))
              : Transform.rotate(
                  angle: pi / 2,
                  child: Switch(
                    value: powerOn,
                    onChanged: (bool value) => {
                      powerOn = value,
                      update().then(
                        (value) {
                          callback();
                        },
                      )
                    },
                  )),
          onTap: () {
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
          },
        );
      case "ir_controller":
        return UnitTile(
          title: Text(name),
          subtitle: const Text("裝置類型:遙控器"),
          leading: CircleAvatar(
            foregroundImage: AssetImage(iconPath),
            backgroundColor: Colors.white,
          ),
          onTap: () {
            Navigator.pushNamed(context, const IRDeviceControlPanel().routeName,
                arguments: {'data': this});
          },
        );
      default:
        debugPrint("type:$type");
        return const UnitTile();
    }
  }

  Map<String, dynamic> getDocument() {
    return {
      'uuid': uuid,
      'device_name': name,
      'roomId': roomId,
      'iconPath': iconPath,
      'type': type,
      'powerOn': powerOn,
      'temperature': temperature,
      'bioLocked': bioLocked,
      'subType': subType,
    };
  }

  Future<DeviceModel> create() async {
    DocumentReference documentReference =
        await database.collection('devices').add(getDocument());
    uuid = documentReference.id;
    await database.collection('devices').doc(uuid).update(getDocument());
    return this;
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
        type = result['type'] ?? "device";
        temperature = result['temperature'] ?? 28;
        bioLocked = result['bioLocked'] ?? false;
        subType = result['subType'] ?? "fan";
      }
    }
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

  Future<void> delete() async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      if (result['uuid'] == uuid) {
        RoomModel room = await RoomModel().read(roomId);
        room.devices.remove(this);
        await room.update();
        room.debugData();
        document.reference.delete();
      }
    }
  }

  Future<List<DeviceModel>> queryAll() async {
    List<DeviceModel> data = [];
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      DeviceModel temp = DeviceModel();
      temp.name = result['device_name'];
      temp.powerOn = result['powerOn'];
      temp.uuid = result['uuid'];
      temp.iconPath = result['iconPath'];
      temp.roomId = result['roomId'] ?? "error";
      temp.type = result['type'];
      temp.temperature = result['temperature'] ?? 28;
      temp.bioLocked = result['bioLocked'] ?? false;
      temp.subType = result['subType'] ?? "fan";
      data.add(temp);
    }
    return data;
  }
}
