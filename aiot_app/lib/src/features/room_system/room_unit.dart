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
  late List<UserModel> userModels;
  final TextEditingController searchBar = TextEditingController();

  void getUsers() async {
    userModels = await UserModel().loadAll();
  }

  @override
  void initState() {
    getUsers();
    room = widget.roomData;

    // room.initialize();
    super.initState();
    setState(() {});
  }

  Future<void> showListDialog() async {
    // List<UserModel> roomMembers = room.members.map((id) {return await UserModel().fromID(id);}).toList();
    List<UserModel> temp = [];

    for (UserModel user in userModels) {
      if (user.name.contains(searchBar.text)) {
        temp.add(user);
        user.debugData();
      }
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        room.initialize();
        return AlertDialog(
          icon: const Text("管理房間成員"),
          title: Container(
            width: double.maxFinite,
            height: 40,
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: TextField(
                style: TextStyle(color: Theme.of(context).primaryColor),
                controller: searchBar,
                decoration: InputDecoration(
                  hintText: "搜尋成員",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 0),
                      child: Icon(
                        Icons.search,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
                onChanged: (value) {
                  setState(() {
                    Navigator.of(context).pop();
                    showListDialog();
                  });
                }),
          ),
          content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: temp.length,
                itemBuilder: (BuildContext context, int index) {
                  UserModel member = temp[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.people)),
                    title: Text(member.name),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text("移除"),
                    ),
                  );
                },
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(room.imagePath),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20 / 4),
                    child:
                        Text(room.name, style: const TextStyle(fontSize: 20))),
                Text("房間主人:${room.owner.displayName}"),
                Text(
                  room.description,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("轉移房間主人")),
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
    );
  }
}
