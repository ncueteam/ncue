class Room {
  final String image, title, description;
  final int id;
  //final Color color;

  Room({
    required this.image,
    required this.title,
    required this.description,
    //required this.price,
    //required this.size,
    required this.id
    //required this.color
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
  /*Product(
      id: 3,
      title: "Hang Top",
      price: 234,
      size: 10,
      description: dummyText,
      image: "assets/images/bag_3.png",
      color: Color(0xFF989493)),
  Product(
      id: 4,
      title: "Old Fashion",
      price: 234,
      size: 11,
      description: dummyText,
      image: "assets/images/bag_4.png",
      color: Color(0xFFE6B398)),
  Product(
      id: 5,
      title: "Office Code",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/bag_5.png",
      color: Color(0xFFFB7883)),
  Product(
    id: 6,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: Color(0xFFAEAEAE),
  ),*/
];

//String dummyText =
 //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";