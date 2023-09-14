import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/icon_route.dart';
import 'package:ncue_app/src/features/basic/profile_view.dart';
import 'package:ncue_app/src/features/basic/route_view.dart';
import 'package:ncue_app/src/features/basic/unit.dart';
import 'package:ncue_app/src/features/devices/device_model.dart';
import 'package:ncue_app/src/features/devices/device_service.dart';
import 'package:ncue_app/src/features/mqtt/mqttapp.dart';
import 'package:ncue_app/src/features/web_view/webview.dart';

import '../bluetooth/flutterblueapp.dart';
import '../settings/settings_view.dart';
import '../item_system/data_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends RouteView {
  const Home({super.key}) : super(routeName: '/home', routeIcon: Icons.home);

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
    items.add(DataItem("route",
        [const MqttPage().routeName, const MqttPage().routeIcon], "MQTT"));
    items.add(DataItem("route",
        [const WebView().routeName, const WebView().routeIcon], "Web view"));
    loadDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          const IconRoute(routeView: SettingsView()),
          const IconRoute(routeView: BluetoothView()),
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
