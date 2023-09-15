import 'dart:math';

import 'package:flutter/material.dart';
import 'device_detail_view.dart';
import 'device_model.dart';
import 'device_service.dart';

class DeviceUnit extends StatefulWidget {
  const DeviceUnit(
      {super.key, required this.deviceData, required this.onChanged});

  final void Function(bool)? onChanged;
  final DeviceModel deviceData;

  @override
  State<DeviceUnit> createState() => _DeviceUnitState();
}

class _DeviceUnitState extends State<DeviceUnit> {
  late DeviceModel device;

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
      subtitle: const Text("副標頭的部分"),
      leading: CircleAvatar(
        foregroundImage: AssetImage(device.iconPath),
        backgroundColor: Colors.white,
      ),
      trailing: Transform.rotate(
          angle: pi / 2,
          child: Switch(
            value: device.powerOn,
            onChanged: (bool value) => {
              setState(
                () {
                  device.powerOn = value;
                  DeviceService().updateDeviceData(device);
                },
              )
            },
          )),
      onTap: () {
        Navigator.pushNamed(context, const DeviceDetailsView().routeName,
            arguments: {'data': device});
      },
    );
  }
}
