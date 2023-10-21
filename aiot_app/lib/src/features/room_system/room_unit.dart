import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_detail_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';

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

  Future<void> showListDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("管理房間成員"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: room.members.length,
              itemBuilder: (BuildContext context, int index) {
                UserModel member =
                    UserModel(name: "test user", uuid: room.members[index]);
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.people)),
                  title: Text(member.name),
                  subtitle: Text(member.uuid),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text("移除"),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(room.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("房間主人:${room.owner.displayName}"),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(room.imagePath),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
              child: Text(room.name, style: const TextStyle(fontSize: 20))),
          Text(
            room.description,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0), // Add this padding
            child: Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("選擇房間")),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      showListDialog();
                    },
                    child: const Text("邀請")),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, const RoomDetailsView().routeName,
                          arguments: {'data': room});
                    },
                    child: const Text("詳細資料")),
              ],
            ),
          )
        ],
      ),
      // onTap: () {
      //   Navigator.pushNamed(context, const RoomDetailsView().routeName,
      //       arguments: {'data': room});
      // },
    );
  }
}
