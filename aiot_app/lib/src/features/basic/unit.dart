import 'package:flutter/material.dart';

import '../devices/device_model.dart';
import '../devices/device_unit.dart';
import '../item_system/data_item.dart';
import '../item_system/item_details_view.dart';
import '../user/user_model.dart';
import 'route_view.dart';

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
      case "bio_device":
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
          if (item.data.elementAt(0) is RouteView) {
            RouteView view = item.data.elementAt(0);
            return ListTile(
                isThreeLine: true,
                title: Text("前往頁面 : ${item.name}"),
                subtitle: Text(view.routeName),
                leading: Icon(view.routeIcon),
                onTap: () {
                  Navigator.pushNamed(context, view.routeName);
                });
          }
          return Container();
        }
      case "addDevice":
        {
          if (item.data.elementAt(0) is RouteView &&
              item.data.elementAt(1) is UserModel) {
            RouteView view = item.data.elementAt(0);
            return ListTile(
                isThreeLine: true,
                title: Text("前往頁面 : ${item.name}"),
                subtitle: Text(view.routeName),
                leading: Icon(view.routeIcon),
                onTap: () {
                  Navigator.pushNamed(context, view.routeName,
                      arguments: {"user": item.data.elementAt(1)});
                });
          }
          return Container();
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