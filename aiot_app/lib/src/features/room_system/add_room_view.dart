import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import '../basic/views/route_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  TextEditingController roomUUID = TextEditingController();
  String imagePath = "assets/room/room1.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.roomChoosePage),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Spacer(),
          Row(
            children: [
              const Text(
                "房間ID  ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                roomUUID.text,
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
          DropdownButton<String>(
            onChanged: (value) {
              setState(() {
                imagePath = value!;
              });
            },
            value: imagePath,
            items: const [
              DropdownMenuItem(
                value: "assets/room/room1.jpg",
                child: Text("圖片一"),
              ),
              DropdownMenuItem(
                value: "assets/room/room2.jpg",
                child: Text("圖片二"),
              ),
              DropdownMenuItem(
                value: "assets/room/room3.jpg",
                child: Text("圖片三"),
              ),
              DropdownMenuItem(
                value: "assets/room/room4.jpg",
                child: Text("圖片四"),
              ),
            ],
          ),
          IconButton(
              onPressed: () async {
                RoomModel room = RoomModel(
                  roomName: roomName.text,
                  roomDescription: roomDiscription.text,
                  path: imagePath,
                );
                room.members.add(RouteView.user!.uid.toString());
                await room.create().then((value) => null);
                room.debugData();
                await RouteView.model
                    .addRoom(room.uuid)
                    .then((value) => Navigator.pop(context, true));
              },
              icon: const Icon(Icons.add)),
          const Spacer(),
          const Spacer(),
          const Spacer()
        ]),
      ),
    );
  }
}
