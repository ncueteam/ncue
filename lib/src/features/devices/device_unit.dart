import 'package:flutter/material.dart';
import 'dart:math';

import '../item_system/data_item.dart';
import '../item_system/item_details_view.dart';

class DeviceUnit extends StatefulWidget {
  const DeviceUnit(
      {super.key, required this.deviceData, required this.onChanged});

  final void Function(bool)? onChanged;
  final DataItem deviceData;

  @override
  State<DeviceUnit> createState() => _DeviceUnitState();
}

class _DeviceUnitState extends State<DeviceUnit> {
  late DataItem device;
  bool powerOn = false;

  @override
  void initState() {
    super.initState();
    device = widget.deviceData;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      textColor: Colors.blue[100],
      title: Text(device.name),
      subtitle: Text(device.data.elementAt(0)),
      leading: CircleAvatar(
        foregroundImage: AssetImage(device.iconPath),
        backgroundColor: Colors.white,
      ),
      trailing: Transform.rotate(
          angle: pi / 2,
          child: Switch(
            value: powerOn,
            onChanged: (bool value) => {
              setState(
                () {
                  powerOn = value;
                },
              )
            },
          )),
      onTap: () {
        Navigator.pushNamed(context, ItemDetailsView.routeName,
            arguments: {'item': device});
      },
    );
  }
}
