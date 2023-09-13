import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/icon_route.dart';
import 'package:ncue_app/src/features/basic/profile_view.dart';
import 'package:ncue_app/src/features/basic/unit.dart';
import 'package:ncue_app/src/features/devices/device_model.dart';
import 'package:ncue_app/src/features/devices/device_service.dart';
import 'package:ncue_app/src/features/mqtt/mqttapp.dart';
import 'package:ncue_app/src/features/web_view/webview.dart';

import '../bluetooth/FlutterBlueApp.dart';
import '../settings/settings_view.dart';
import '../item_system/data_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String routeName = '/home';
  static const IconData routeIcon = Icons.home;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DataItem> items = [];

  void loadDevices() async {
    for (DeviceModel device in await DeviceService().loadDeviceData()) {
      setState(() {
        items.add(device.toDataItem());
      });
    }
  }

  @override
  void initState() {
    items.add(
        DataItem("route", [MqttPage.routeName, MqttPage.routeIcon], "MQTT"));
    items.add(
        DataItem("route", [WebView.routeName, WebView.routeIcon], "Web view"));
    loadDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          const IconRoute(
              routeName: SettingsView.routeName,
              iconData: SettingsView.routeIcon),
          const IconRoute(
              routeName: FlutterBlueApp.routeName,
              iconData: Icons.compare_arrows),
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
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
