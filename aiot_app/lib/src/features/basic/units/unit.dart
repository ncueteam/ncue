// import 'package:flutter/material.dart';
// import 'package:ncue.aiot_app/src/features/basic/units/dht11_unit.dart';
// import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
// import 'package:ncue.aiot_app/src/features/devices/add_device_view.dart';
// import 'package:ncue.aiot_app/src/features/basic/units/mqtt_unit.dart';
// import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
// import 'package:ncue.aiot_app/src/features/room_system/room_unit.dart';

// import '../models/device_model.dart';
// import '../models/user_model.dart';
// import '../views/route_view.dart';

// class Unit extends StatefulWidget {
//   const Unit({super.key});

//   @override
//   State<Unit> createState() => _UnitState();
// }

// class _UnitState extends State<Unit> {
//   @override
//   Widget build(BuildContext context) {
//     switch (item.type) {
//       case "dht11":
//         {
//           if (item.data.isNotEmpty && item.data[0] is String) {
//             return Dht11Unit(uuid: item.data[0]);
//           } else {
//             return const Dht11Unit();
//           }
//         }
//       case "auto":
//         {
//           return UnitTile(
//             selected: true,
//             onTap: () {},
//           );
//         }
//       case "bio_device":
//       case "device":
//         {
//           if (item.data[0] is DeviceModel) {
//             return (item.data[0] as DeviceModel).getUnit(context);
//           } else {
//             return ListTile(
//               key: ValueKey(item),
//               title: const Text("裝置載入錯誤"),
//             );
//           }
//         }
//       case "mqtt":
//         {
//           if (item.data.isNotEmpty && item.data[0] is String) {
//             return MqttUnit(uuid: item.data[0]);
//           } else {
//             return const MqttUnit();
//           }
//         }
//       case "route":
//         {
//           if (item.data.elementAt(0) is RouteView) {
//             return (item.data.elementAt(0) as RouteView)
//                 .getDataItemRoute(context);
//             // ;
//             // RouteView view = item.data.elementAt(0);
//             // return ListTile(
//             //     key: ValueKey(item),
//             //     isThreeLine: true,
//             //     title: Text("前往頁面 : ${item.name}"),
//             //     subtitle: Text(view.routeName),
//             //     leading: Icon(view.routeIcon),
//             //     onTap: () {
//             //       Navigator.pushNamed(context, view.routeName);
//             //     });
//           }
//           return Container();
//         }
//       case "room":
//         {
//           if (item.data.elementAt(0) is RoomModel) {
//             return RoomUnit(
//               roomData: item.data.elementAt(0),
//               onChanged: (p0) {},
//             );
//           }
//           return Container();
//         }
//       case "addDevice":
//         {
//           if (item.data.elementAt(0) is RoomModel) {
//             AddDeviceView view =
//                 AddDeviceView(roomData: item.data.elementAt(0));
//             return ListTile(
//                 key: ValueKey(item),
//                 isThreeLine: true,
//                 title: Text("前往頁面 : ${item.name}"),
//                 subtitle: Text(view.routeName),
//                 leading: Icon(view.routeIcon),
//                 onTap: () {
//                   Navigator.pushNamed(context, view.routeName,
//                       arguments: {"roomData": item.data.elementAt(0)});
//                 });
//           } else {
//             debugPrint("item.data.elementAt(0) is not roomModel");
//             return Container();
//           }
//         }
//       case "addRoom":
//         {
//           if (item.data.elementAt(0) is RouteView &&
//               item.data.elementAt(1) is UserModel) {
//             RouteView view = item.data.elementAt(0);
//             return UnitTile(
//                 key: ValueKey(item),
//                 isThreeLine: true,
//                 title: Text("前往頁面 : ${item.name}"),
//                 subtitle: Text(view.routeName),
//                 leading: Icon(view.routeIcon),
//                 onTap: () {
//                   Navigator.pushNamed(context, view.routeName,
//                       arguments: {"user": item.data.elementAt(1)});
//                 });
//           }
//           return Container();
//         }

//       case "genric":
//       default:
//         {
//           return ListTile(
//             key: ValueKey(item),
//             title: Text(item.name),
//           );
//         }
//     }
//   }
// }
