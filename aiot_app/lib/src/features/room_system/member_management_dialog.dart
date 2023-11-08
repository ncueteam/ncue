import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';

class MemberManagementDialog extends StatefulWidget {
  const MemberManagementDialog(
      {super.key, required this.userModels, required this.room});

  final RoomModel room;
  final List<UserModel> userModels;

  @override
  State<MemberManagementDialog> createState() => _MemberManagementDialogState();
}

class _MemberManagementDialogState extends State<MemberManagementDialog> {
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
        if (widget.room.members.contains(user.name) == true) {
          temp.add(user);
        } else {
          temp.insert(0, user);
          //debugPrint(temp[0].name);
        }
      }
    }

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
                debugPrint(searchBar.text);
                /*for (UserModel user in temp) {
                  debugPrint(user.name);
                }*/
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
                  trailing: widget.room.members.contains(member.name)
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.room.members.remove(member.name);
                              widget.room.update();
                              for (String name in widget.room.members) {
                                debugPrint(name);
                              }
                            });
                          },
                          child: const Text("移除"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.room.members.add(member.name);
                              widget.room.update();
                              for (String name in widget.room.members) {
                                debugPrint(name);
                              }
                            });
                          },
                          child: const Text("增加"),
                        ));
            },
          )),
    );
  }
}
