class DataItem {
  DataItem(this.type, this.data,
      {this.name = "name not set",
      this.iconPath = 'assets/images/flutter_logo.png'});

  final String type;
  final List data;
  String name = "name not set";
  String iconPath = 'assets/images/flutter_logo.png';
}
