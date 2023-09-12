class DataItem {
  DataItem(this.id, this.data, this.name,
      {this.iconPath = 'assets/images/flutter_logo.png'});

  final int id;
  final List<String> data;
  final String name;
  String iconPath = 'assets/images/flutter_logo.png';
}
