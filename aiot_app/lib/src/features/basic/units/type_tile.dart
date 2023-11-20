import 'package:flutter/material.dart';

class TypeTile extends StatefulWidget {
  const TypeTile({super.key, required this.name, required this.children});
  final String name;
  final List<Widget> children;

  @override
  State<TypeTile> createState() => _TypeTileState();
}

class _TypeTileState extends State<TypeTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ValueKey(this),
      title: Text(widget.name),
      initiallyExpanded: true,
      children: widget.children,
    );
  }
}
