class Room {
  final String image, title, description;
  final int id;

  Room({
    required this.image,
    required this.title,
    required this.description,
    required this.id
  });
}

List<Room> rooms = [
  Room(
      id: 1,
      title: "觀景六人房",
      description: "獨特的現代設計、建築品質的堅持主人的用心與獨到眼光，值得您細細品味。",
      image: "assets/room/room1.jpg"),
  Room(
      id: 2,
      title: "觀景兩人房",
      description: "獨特的現代設計、建築品質的堅持主人的用心與獨到眼光，值得您細細品味。",
      image: "assets/room/room2.jpg"),
];