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
      "https://media.vogue.com.tw/photos/5f2015ac9743347976d7796a/master/pass/2020728_200728_49.jpg";
  List<Widget> items = [];
  late FileService fileService;

  List<DropdownMenuItem<String>> pictureDrops = [];

  Future reload() async {
    pictureDrops.clear();
    pictureDrops.addAll(await listAllFiles());
    setState(() {});
  }

  @override
  void initState() {
    reload();
    fileService = FileService(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items.clear();
    items.addAll([
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
      Image.network(link),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: DropdownButton<String>(
          onChanged: (value) async {
            link = await FirebaseStorage.instance
                .ref()
                .child('files/$value')
                .getDownloadURL();
            pictureDrops.clear();
            pictureDrops.addAll(await listAllFiles());
            imagePath = value!;
            setState(() {});
          },
          value: imagePath,
          items: pictureDrops,
        ),
      ),
      fileService.getUnit(),
      ElevatedButton(
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
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.add), Text("註冊房間")])),
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
