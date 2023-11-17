import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/services/local_auth_service.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'device_detail_view.dart';
import '../basic/models/device_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    device = widget.deviceData;
  }

  @override
  Widget build(BuildContext context) {
    return UnitTile(
      title: Text(device.name),
      subtitle: Text("裝置類型: ${device.type == "device" ? "一般裝置" : "生物解鎖裝置"}"),
      leading: CircleAvatar(
        foregroundImage: AssetImage(device.iconPath),
        backgroundColor: Colors.white,
      ),
      trailing: device.type == "bio_device" && !authenticated
          ? IconButton(
              onPressed: () async {
                final authenticate = await LocalAuth.authenticate();
                setState(() {
                  authenticated = authenticate;
                });
              },
              icon: const Icon(Icons.fingerprint))
          : Transform.rotate(
              angle: pi / 2,
              child: Switch(
                value: device.powerOn,
                onChanged: (bool value) => {
                  device.powerOn = value,
                  device.update().then(
                    (value) {
                      setState(() {});
                    },
                  )
                },
              )),
      onTap: () {
        if (device.type == "bio_device") {
          if (authenticated) {
            Navigator.pushNamed(context, const DeviceDetailsView().routeName,
                arguments: {'data': device});
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
        } else if (device.type == "device") {
          Navigator.pushNamed(context, const DeviceDetailsView().routeName,
              arguments: {'data': device});
        }
      },
    );
  }
}
