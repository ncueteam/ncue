import 'package:flutter/material.dart';

import '../basic/views/route_view.dart';

class SettingsView extends RouteView {
  const SettingsView({super.key})
      : super(routeName: '/settings', routeIcon: Icons.settings);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          DropdownButton<ThemeMode>(
            padding: const EdgeInsets.all(16),
            value: RouteView.settingsController.themeMode,
            onChanged: (themeMode) async {
              await RouteView.settingsController.updateThemeMode(themeMode);
              setState(() {});
            },
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark Theme'),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<String>(
              value: "zh_tw",
              onChanged: (value) {},
              items: const [
                DropdownMenuItem(
                  value: "en_us",
                  child: Text("Language English US"),
                ),
                DropdownMenuItem(
                  value: "zh_tw",
                  child: Text('Language 中文 台灣'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
