import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'models/RoomDetail.dart';

class RoomSelect extends StatelessWidget {

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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
  ItemCard({super.key, required this.room});

  final Room room;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding:EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(room.image),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            room.title,
            style: TextStyle(fontSize: 20)
          )
        ),
        Text(
          room.description,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("選擇房間"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("邀請"),
            ),
          ],
        ),
      ],
    );
  }
}