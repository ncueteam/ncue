import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/devices/device_model.dart';
import 'package:ncue_app/src/features/devices/device_unit.dart';
import 'package:ncue_app/src/features/item_system/data_item.dart';

import '../item_system/item_details_view.dart';

class Unit extends StatefulWidget {
  const Unit({super.key, required this.item});

  final DataItem item;

  @override
  State<Unit> createState() => _UnitState();
}

class _UnitState extends State<Unit> {
  @override
  Widget build(BuildContext context) {
    final DataItem item = widget.item;
    switch (item.type) {
      case "device":
        {
          if (item.origin is DeviceModel) {
            return DeviceUnit(
              deviceData: item.origin,
              onChanged: (bool value) {},
            );
          } else {
            return const ListTile(
              title: Text("裝置載入錯誤"),
            );
          }
        }
      case "route":
        {
          return ListTile(
              isThreeLine: true,
              title: Text("前往頁面 : ${item.name}"),
              subtitle: Text(item.data.elementAt(0)),
              leading: Icon(item.data.elementAt(1)),
              onTap: () {
                Navigator.pushNamed(context, item.data.elementAt(0));
              });
        }
      case "genric":
      default:
        return ListTile(
            title: Text('[${item.name}]   ${item.data}'),
            leading: CircleAvatar(
              foregroundImage: AssetImage(item.iconPath),
            ),
            onTap: () {
              Navigator.pushNamed(context, const ItemDetailsView().routeName,
                  arguments: {'item': item});
            });
    }
  }
}
