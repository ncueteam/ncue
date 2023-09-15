class DataItem {
  DataItem(this.type, this.data, this.name,
      {this.iconPath = 'assets/images/flutter_logo.png', this.origin = ""});

  final String type;
  final List data;
  final String name;
  dynamic origin = "";
  String iconPath = 'assets/images/flutter_logo.png';
}
