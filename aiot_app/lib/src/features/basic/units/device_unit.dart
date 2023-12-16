import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/device_model.dart';
import 'package:ncue.aiot_app/src/features/basic/services/local_auth_service.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:ncue.aiot_app/src/features/devices/device_detail_view.dart';
import 'package:ncue.aiot_app/src/features/devices/ir_device_control_panel.dart';

class DeviceUnit extends StatefulWidget {
  const DeviceUnit(
      {super.key, required this.deviceModel, required this.callback});

  final DeviceModel deviceModel;
  final VoidCallback callback;

  @override
  State<DeviceUnit> createState() => _DeviceUnitState();
}

class _DeviceUnitState extends State<DeviceUnit> {
  bool authenticated = false;
  @override
  Widget build(BuildContext context) {
    DeviceModel device = widget.deviceModel;

    Widget result = const Text("none");

    Widget bioLock(Widget content, VoidCallback callback) {
      if (authenticated) {
        return content;
      } else {
        return UnitTile(
          leading: CircleAvatar(
            foregroundImage: AssetImage(device.iconPath),
            backgroundColor: Colors.white,
          ),
          title: Text(device.name),
          subtitle: Text(device.subType),
          trailing: IconButton(
              onPressed: () async {
                final authenticate = await LocalAuth.authenticate();
                authenticated = authenticate;
                callback();
                setState(() {});
              },
              icon: const Icon(Icons.fingerprint)),
        );
      }
    }

    switch (device.type) {
      case "switch":
        {
          result = UnitTile(
            title: Text(device.name),
            subtitle: const Text("裝置類型:開關"),
            leading: CircleAvatar(
              foregroundImage: AssetImage(device.iconPath),
              backgroundColor: Colors.white,
            ),
            trailing: Transform.rotate(
                angle: pi / 2,
                child: Switch(
                  value: device.powerOn,
                  onChanged: (bool value) async {
                    device.powerOn = !device.powerOn;
                    await device.update().then(
                      (e) {
                        widget.callback();
                      },
                    );
                    setState(() {});
                  },
                )),
            onTap: () {
              Navigator.pushNamed(context, const DeviceDetailsView().routeName,
                  arguments: {'data': device});
            },
          );
        }
      case "ir_controller":
        {
          result = UnitTile(
            title: Text(device.name),
            subtitle: const Text("裝置類型:遙控器"),
            leading: CircleAvatar(
              foregroundImage: AssetImage(device.iconPath),
              backgroundColor: Colors.white,
            ),
            onTap: () {
              Navigator.pushNamed(
                  context, const IRDeviceControlPanel().routeName,
                  arguments: {'data': device});
            },
          );
        }
      default:
        {
          result = const Text("error");
        }
    }
    if (device.bioLocked) {
      result = bioLock(result, widget.callback);
    }
    return result;
  }
}
