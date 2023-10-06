import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_detail_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';

class RoomUnit extends StatefulWidget {
  const RoomUnit({super.key, required this.roomData, required this.onChanged});

  final void Function(bool)? onChanged;
  final RoomModel roomData;

  @override
  State<RoomUnit> createState() => _RoomUnitState();
}

class _RoomUnitState extends State<RoomUnit> {
  late RoomModel room;
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    room = widget.roomData;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(room.name),
      subtitle: Text("房間主人:${room.owner.displayName}"),
      // leading: CircleAvatar(
      //   foregroundImage: AssetImage(room.iconPath),
      //   backgroundColor: Colors.white,
      // ),
      onTap: () {
        Navigator.pushNamed(context, const RoomDetailsView().routeName,
            arguments: {'data': room});
      },
    );
  }
}
