import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "characteristic_tile.dart";

const String serviceuuid = "9011";

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile(
      {Key? key, required this.service, required this.characteristicTiles})
      : super(key: key);

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    if (service.serviceUuid.toString().toUpperCase() == serviceuuid) {
      return characteristicTiles.isNotEmpty
          ? ExpansionTile(
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Service', style: TextStyle(color: Colors.blue)),
                  //buildUuid(context),
                ],
              ),
              children: characteristicTiles,
            )
          : ListTile(
              title: const Text('Service'),
              subtitle: buildUuid(context),
            );
    } else {
      return const SizedBox.shrink();
    }
  }
}
