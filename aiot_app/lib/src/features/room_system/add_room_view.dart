import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/room_system/room_model.dart';
import 'package:uuid/uuid.dart';
import '../basic/home_view.dart';
import '../basic/route_view.dart';
import '../user/user_model.dart';
import '../user/user_service.dart';

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
      final UserModel user = arguments['user'];
      return Scaffold(
        appBar: AppBar(
          title: const Text("裝置註冊頁面"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Text(
                  "裝置號碼  ",
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
                labelText: '裝置名稱',
                hintText: '裝置名稱',
              ),
            ),
            Row(children: [
              IconButton(
                  onPressed: () async {
                    UserService().addRoom(user, roomUUID);
                    RoomModel(roomName.text, roomUUID).create();
                    Navigator.pop(context, true);
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
