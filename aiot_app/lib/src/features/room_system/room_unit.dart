import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_detail_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';
//import 'models/room_detail.dart';

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
      subtitle:
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding:const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset("assets/room/room1.jpg"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            room.name,
            style: const TextStyle(fontSize: 20)
          )
        ),
        Text(
          "獨特的現代設計、建築品質的堅持主人的用心與獨到眼光，值得您細細品味。",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.all(7.0), // Add this padding
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("選擇房間"),
                /*style: ElevatedButton.styleFrom(
                primary: Colors.blue, 
                  ),*/
              ),
              ElevatedButton(
                onPressed: () {
                  //showListDialog();
                },
                child: const Text("邀請"),
              ),
            ],
          ),
        )
      ],
    ),
      //subtitle: Text("房間主人:${room.owner.displayName}"),
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
