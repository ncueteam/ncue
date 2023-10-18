import 'package:flutter/material.dart';
import 'models/room_detail.dart';
import '../basic/route_view.dart';
import 'models/member.dart';

//class RoomSelect extends StatelessWidget {
  //const RoomSelect({super.key});
class RoomSelect extends RouteView {
  const RoomSelect({super.key})
      : super(routeName: '/room-select', routeIcon: Icons.meeting_room_sharp);
@override
  RoomSelectState createState() => RoomSelectState();
}

class RoomSelectState extends State<RoomSelect> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "選擇房間",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                itemCount: rooms.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) => ItemCard(room: rooms[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.room});

  final Room room;
  @override
  Widget build(BuildContext context) {
    Future<void> showListDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("管理房間成員"),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (BuildContext context, int index) {
                  Member member = members[index];
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.people)),
                    title: Text(member.username),
                    subtitle: Text(member.email),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle remove member action
                      },
                      child: const Text("移除"),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding:const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(room.image),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            room.title,
            style: const TextStyle(fontSize: 20)
          )
        ),
        Text(
          room.description,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.all(7.0), // Add this padding
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("選擇房間"),
                /*style: ElevatedButton.styleFrom(
                primary: Colors.blue, 
                  ),*/
              ),
              ElevatedButton(
                onPressed: () {
                  showListDialog();
                },
                child: const Text("邀請"),
              ),
            ],
          ),
        )
      ],
    );
  }
}