import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import '../basic/views/route_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRoomView extends RouteView {
  const AddRoomView({key})
      : super(key,
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
  List<Widget> items = [];

  @override
  void initState() {
    items.addAll([
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
      TextField(
        controller: roomName,
        decoration: const InputDecoration(
          labelText: '房間名稱',
          hintText: '房間名稱',
        ),
      ),
      TextField(
        controller: roomDiscription,
        decoration: const InputDecoration(
          labelText: '房間敘述',
          hintText: '房間敘述',
        ),
      ),
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
            RoomModel room = RoomModel();
            room.imagePath = imagePath;
            room.description = roomDiscription.text;
            room.name = roomName.text;
            room.members.add(RouteView.user!.uid.toString());
            await room.create().then((value) => null);
            // room.debugData();
            await RouteView.model
                .addRoom(room.uuid)
                .then((value) => Navigator.pop(context, true));
          },
          icon: const Icon(Icons.add)),
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.roomChoosePage),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemBuilder: (BuildContext context, int index) {
            return items[index];
          },
          itemCount: items.length,
        ));
  }
}
