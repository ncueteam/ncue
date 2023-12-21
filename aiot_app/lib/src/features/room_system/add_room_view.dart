import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/services/file_service.dart';
import '../basic/views/route_view.dart';

class AddRoomView extends RouteView {
  const AddRoomView({key})
      : super(key,
            routeName: "/add-room-view",
            routeIcon: Icons.meeting_room_outlined);

  @override
  State<AddRoomView> createState() => AddRoomViewState();
}

Future<List<DropdownMenuItem<String>>> listAllFiles() async {
  List<DropdownMenuItem<String>> fileNames = [];

  final ListResult result =
      await FirebaseStorage.instance.ref().child('files').listAll();

  for (Reference r in result.items) {
    fileNames.add(DropdownMenuItem(
      value: r.name,
      child: Text(r.name),
    ));
  }

  return fileNames;
}

class AddRoomViewState extends State<AddRoomView> {
  TextEditingController roomName = TextEditingController();
  TextEditingController roomDiscription = TextEditingController();
  TextEditingController roomUUID = TextEditingController();
  String imagePath = "room1.jpg";
  String link =
      "https://firebasestorage.googleapis.com/v0/b/ncueapp.appspot.com/o/files%2Froom1.jpg?alt=media&token=2d3f04ef-d833-4fd9-b7b6-e1f070fe5109";
  List<Widget> items = [];
  late FileService fileService;

  List<DropdownMenuItem<String>> pictureDrops = [
    const DropdownMenuItem(value: "room1.jpg", child: Text("room1.jpg")),
    const DropdownMenuItem(value: "room2.jpg", child: Text("room2.jpg")),
    const DropdownMenuItem(value: "room3.jpg", child: Text("room3.jpg")),
    const DropdownMenuItem(value: "room4.jpg", child: Text("room4.jpg")),
  ];

  @override
  void initState() {
    fileService = FileService(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items.clear();
    items.addAll([
      // Row(
      //   children: [
      //     const Text(
      //       "房間ID  ",
      //       style: TextStyle(fontSize: 16),
      //     ),
      //     Text(
      //       roomUUID.text,
      //       style: const TextStyle(fontSize: 15),
      //     ),
      //   ],
      // ),
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
      // Image.asset(imagePath),
      Image.network(link),
      DropdownButton<String>(
        onChanged: (value) async {
          link = await FirebaseStorage.instance
              .ref()
              .child('files/$imagePath')
              .getDownloadURL();
          pictureDrops.clear();
          pictureDrops.addAll(await listAllFiles());
          setState(() {
            imagePath = value!;
          });
        },
        value: imagePath,
        items: pictureDrops,
        // const [
        //   DropdownMenuItem(
        //     value: "room1.jpg",
        //     child: Text("圖片一"),
        //   ),
        //   DropdownMenuItem(
        //     value: "room2.jpg",
        //     child: Text("圖片二"),
        //   ),
        //   DropdownMenuItem(
        //     value: "room3.jpg",
        //     child: Text("圖片三"),
        //   ),
        //   DropdownMenuItem(
        //     value: "room4.jpg",
        //     child: Text("圖片四"),
        //   ),
        // ],
      ),
      fileService.getUnit(),
      IconButton(
          onPressed: () async {
            if (roomName.text != "") {
              RoomModel room = RoomModel();
              room.imagePath = imagePath;
              room.description = roomDiscription.text;
              room.name = roomName.text;
              room.members.add(RouteView.user!.uid.toString());
              await room.create().then((value) => null);
              // room.debugData();
              RouteView.model.rooms.add(room.uuid);
              await RouteView.model
                  .update()
                  .then((value) => Navigator.pop(context, true));
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(RouteView.language.roomNameEmptyError),
                ),
              );
            }
          },
          icon: const Icon(Icons.add)),
    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text(RouteView.language.roomRegisterPageTitle),
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
