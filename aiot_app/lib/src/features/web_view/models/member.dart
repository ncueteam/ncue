class Member {
  final String username, email;
  final int id;

  Member({
    required this.username,
    required this.email,
    required this.id
  });
}

List<Member> members = [
  Member(
      id: 1,
      username: "app_user1",
      email: "tsing347437@gmail.com"),
  Member(
      id: 2,
      username: "app_user2",
      email: "tsing98712372@email.com"),
];