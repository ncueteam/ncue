import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';

class OwnerManagementDialog extends StatefulWidget {
  const OwnerManagementDialog(
      {super.key, required this.userModels, required this.room});

  final RoomModel room;
  final List<UserModel> userModels;

  @override
  State<OwnerManagementDialog> createState() => _OwnerManagementDialogState();
}

class _OwnerManagementDialogState extends State<OwnerManagementDialog> {
  final TextEditingController searchBar = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> temp = [];

    for (UserModel user in widget.userModels) {
      if (user.name.contains(searchBar.text)) {
        if (widget.room.owner.uid != user.uuid) {
          temp.add(user);
        }
      }
    }

    return AlertDialog(
      icon: const Text("轉移房間主人"),
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
              hintText: "搜尋使用者",
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
                debugPrint(searchBar.text);
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
                    onPressed: () async {
                      UserModel owner =
                          await UserModel().fromID(widget.room.owner.uid);
                      owner.rooms.remove(widget.room.uuid);
                      owner.update();
                      member.rooms.add(widget.room.uuid);
                      member.update().then((value) => setState(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }));
                    },
                    child: const Text("轉移"),
                  ));
            },
          )),
    );
  }
}
