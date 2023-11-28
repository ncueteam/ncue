import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ncue.aiot_app/src/features/bluetooth/Tiles/characteristic_tile.dart';

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile(
      {Key? key, required this.service, required this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //if (service.serviceUuid.toString().toUpperCase() == serviceuuid) {
    return ExpansionTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Service'),
          Text('0x${service.serviceUuid.toString().toUpperCase()}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color))
        ],
      ),
      children: characteristicTiles,
    );
    //} else {
    //return const SizedBox.shrink();
    //}
  }
}
