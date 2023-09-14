import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/route_view.dart';

class IconRoute extends StatefulWidget {
  const IconRoute({
    super.key,
    required this.routeView,
  });

  final RouteView routeView;

  @override
  State<IconRoute> createState() => _IconRouteState();
}

class _IconRouteState extends State<IconRoute> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.restorablePushNamed(context, widget.routeView.routeName);
      },
      icon: Icon(widget.routeView.routeIcon),
    );
  }
}
