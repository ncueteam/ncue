import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/icon_route.dart';
import 'package:ncue_app/src/features/basic/profile_view.dart';
import 'package:ncue_app/src/features/basic/unit.dart';
import 'package:ncue_app/src/features/mqtt/mqttapp.dart';
import 'package:ncue_app/src/features/web_view/webview.dart';

import '../bluetooth/FlutterBlueApp.dart';
import '../settings/settings_view.dart';
import '../item_system/data_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String routeName = '/home';
  static const IconData routeIcon = Icons.home;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    /*=================================================== */
    List<DataItem> items = [];
    items.add(DataItem("device", ["正常的風扇"], "智慧風扇",
        iconPath: 'lib/src/icons/fan.png'));
    items.add(DataItem("device", ["一個電視"], "智慧電視",
        iconPath: 'lib/src/icons/smart-tv.png'));
    items.add(
        DataItem("route", [MqttPage.routeName, MqttPage.routeIcon], "MQTT"));
    items.add(
        DataItem("route", [WebView.routeName, WebView.routeIcon], "Web view"));
    /*=================================================== */
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page"),
        actions: const [
          IconRoute(
              routeName: SettingsView.routeName,
              iconData: SettingsView.routeIcon),
          IconRoute(
              routeName: FlutterBlueApp.routeName,
              iconData: Icons.compare_arrows),
          IconRoute(
              routeName: MqttPage.routeName, iconData: MqttPage.routeIcon),
        ],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        addAutomaticKeepAlives: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          DataItem item = items[index];
          return Unit(item: item);
        },
      ),
    );
  }
}
