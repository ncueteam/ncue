import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/profile_view.dart';
import 'package:ncue_app/src/features/basic/unit.dart';
import 'package:ncue_app/src/features/mqtt/mqttapp.dart';

import '../settings/settings_view.dart';
import '../item_system/data_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const routeName = '/home';

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
    /*=================================================== */
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bluetooth');
            },
            icon: const Icon(Icons.compare_arrows),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/mqtt');
            },
            icon: const Icon(Icons.chat),
          ),
        ],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          DataItem item = items[index];

          return Unit(item: item);
        },
      ),
    );
  }
}
