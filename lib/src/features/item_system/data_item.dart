class DataItem {
  DataItem(this.type, this.data, this.name,
      {this.iconPath = 'assets/images/flutter_logo.png'});

  final String type;
  final List data;
  final String name;
  String iconPath = 'assets/images/flutter_logo.png';
}
