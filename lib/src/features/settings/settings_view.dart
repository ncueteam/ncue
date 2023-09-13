import 'package:flutter/material.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';
  static const IconData routeIcon = Icons.settings;

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
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