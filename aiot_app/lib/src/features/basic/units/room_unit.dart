import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/units/unit_tile.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_detail_view.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/models/user_model.dart';
import '../../room_system/member_management_dialog.dart';
import '../../room_system/owner_management_dialog.dart';

class RoomUnit extends UnitTile {
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
  String link =
      "https://firebasestorage.googleapis.com/v0/b/ncueapp.appspot.com/o/files%2Froom1.jpg?alt=media&token=2d3f04ef-d833-4fd9-b7b6-e1f070fe5109";

  void getUsers() async {
    room = widget.roomData;
    userModels = await UserModel().loadAll();
    link = await FirebaseStorage.instance
        .ref()
        .child('files/${room.imagePath}')
        .getDownloadURL();
  }

  @override
  void initState() {
    getUsers();
    super.initState();
    setState(() {});
  }

  Future<void> showListDialogMember() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return MemberManagementDialog(room: room, userModels: userModels);
      },
    );
  }

  Future<void> showListDialogOwner() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return OwnerManagementDialog(room: room, userModels: userModels);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (room.uuid == "error uuid") {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/ncueapp.appspot.com/o/files%2Froom1.jpg?alt=media&token=2d3f04ef-d833-4fd9-b7b6-e1f070fe5109"),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20 / 4),
                child: Text(room.name, style: const TextStyle(fontSize: 20))),
            Text("房間主人:${room.owner.name}"),
            Text(
              room.description,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (room.owner.uuid == RouteView.model.uuid)
                    ElevatedButton(
                        onPressed: () {
                          showListDialogOwner();
                        },
                        child: const Text("轉移房間主人")),
                  if (room.owner.uuid == RouteView.model.uuid) const Spacer(),
                  if (room.owner.uuid == RouteView.model.uuid)
                    ElevatedButton(
                        onPressed: () {
                          showListDialogMember();
                        },
                        child: const Text("管理成員")),
                  if (room.owner.uuid == RouteView.model.uuid) const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, const RoomDetailsView().routeName,
                            arguments: {'data': room.uuid});
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
}
