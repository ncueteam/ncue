import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';
import 'package:uuid/uuid.dart';
import '../basic/views/home_view.dart';
import '../basic/views/route_view.dart';

class AddRoomView extends RouteView {
  const AddRoomView({super.key})
      : super(
            routeName: "/add-room-view",
            routeIcon: Icons.meeting_room_outlined);

  @override
  State<AddRoomView> createState() => AddRoomViewState();
}

class AddRoomViewState extends State<AddRoomView> {
  TextEditingController roomName = TextEditingController();
  TextEditingController roomDiscription = TextEditingController();
  String roomUUID = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      String imagePath = "assets/room/room${Random().nextInt(2) + 1}.jpg";
      return Scaffold(
        appBar: AppBar(
          title: const Text("房間選擇頁面"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Spacer(),
            Row(
              children: [
                const Text(
                  "房間ID  ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  roomUUID,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const Spacer(),
            TextField(
              controller: roomName,
              decoration: const InputDecoration(
                labelText: '房間名稱',
                hintText: '房間名稱',
              ),
            ),
            const Spacer(),
            TextField(
              controller: roomDiscription,
              decoration: const InputDecoration(
                labelText: '房間敘述',
                hintText: '房間敘述',
              ),
            ),
            const Spacer(),
            Image.asset(imagePath),
            IconButton(
                onPressed: () async {
                  RoomModel room = RoomModel(
                    roomName: roomName.text,
                    id: roomUUID,
                    roomDescription: roomDiscription.text,
                    path: imagePath,
                  );
                  room.members.add(RouteView.user!.uid.toString());
                  await room.create();
                  room.debugData();
                  await RouteView.model
                      .addRoom(roomUUID)
                      .then((value) => Navigator.pop(context, true));
                },
                icon: const Icon(Icons.add)),
            const Spacer(),
            const Spacer(),
            const Spacer()
          ]),
        ),
      );
    } else {
      return Container(
        child: const Home().getIconButton(context),
      );
    }
  }
}
