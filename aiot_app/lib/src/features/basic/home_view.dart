import 'dart:async';
import 'package:flutter/material.dart';
import '../auth_system/profile_view.dart';
import '../bluetooth/flutterblueapp.dart';
import '../settings/settings_view.dart';
import '../item_system/data_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'route_view.dart';
import 'unit.dart';

class Home extends RouteView {
  const Home({super.key}) : super(routeName: '/home', routeIcon: Icons.home);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DataItem> items = [];

  @override
  void initState() {
    reload();
    super.initState();
  }

  Future<void> reload() async {
    items = await RouteView.loadUnits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${AppLocalizations.of(context)!.appTitle} ${AppLocalizations.of(context)?.localeName.toString() ?? "sss"}"),
        actions: [
          const SettingsView().getIconButton(context),
          const BluetoothView().getIconButton(context),
        ],
      ),
      drawer: const Drawer(child: ProfileView()),
      body: RefreshIndicator(
        onRefresh: () => reload(),
        child: ListView.builder(
          restorationId: 'homeView',
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            DataItem item = items[index];
            return Unit(item: item);
          },
        ),
      ),
    );
  }
}
