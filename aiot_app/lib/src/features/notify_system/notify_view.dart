import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class NotifyView extends RouteView {
  const NotifyView({super.key})
      : super(routeIcon: Icons.notifications, routeName: "/notification-view");

  @override
  State<StatefulWidget> createState() => _NotifyPage();
}

class _NotifyPage extends State<NotifyView> {
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final message =
          ModalRoute.of(context)!.settings.arguments as RemoteMessage;
      return Scaffold(
        appBar: AppBar(title: const Text("Notification")),
        body: Column(children: [
          Text(message.notification!.title.toString()),
          Text(message.notification!.body.toString()),
          Text(message.data.toString())
        ]),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text("Notification")),
        body: const Text("Nothing"),
      );
    }
  }
}
