import 'package:flutter/material.dart';

class IconRoute extends StatefulWidget {
  const IconRoute({
    super.key,
    required this.routeName,
    required this.iconData,
  });

  final String routeName;

  final IconData iconData;

  @override
  State<IconRoute> createState() => _IconRouteState();
}

class _IconRouteState extends State<IconRoute> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.restorablePushNamed(context, widget.routeName);
      },
      icon: Icon(widget.iconData),
    );
  }
}
