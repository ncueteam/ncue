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
  String roomUUID = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("房間選擇頁面"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            TextField(
              controller: roomName,
              decoration: const InputDecoration(
                labelText: '房間名稱',
                hintText: '房間名稱',
              ),
            ),
            Image.asset("assets/room/room1.jpg"),
            Row(children: [
              IconButton(
                  onPressed: () async {
                    RoomModel room = RoomModel(
                      roomName: roomName.text,
                      id: roomUUID,
                      roomDescription: "測試描述",
                    );
                    room.members.add(RouteView.user!.uid.toString());
                    await room.create();
                    room.debugData();
                    await RouteView.model
                        .addRoom(roomUUID)
                        .then((value) => Navigator.pop(context, true));
                  },
                  icon: const Icon(Icons.add)),
            ]),
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
