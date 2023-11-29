import 'package:flutter/material.dart';

import '../basic/views/route_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends RouteView {
  const SettingsView({key})
      : super(key, routeName: '/settings', routeIcon: Icons.settings);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingPageTitle),
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
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(AppLocalizations.of(context)!.systemTheme),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(AppLocalizations.of(context)!.lightTheme),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(AppLocalizations.of(context)!.darkTheme),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<String>(
              value: RouteView.settingsController.locale,
              onChanged: (locale) async {
                await RouteView.settingsController.updateLocale(locale);
                setState(() {});
              },
              items: [
                DropdownMenuItem(
                  value: "en_US",
                  child: Text(AppLocalizations.of(context)!.englishUS),
                ),
                DropdownMenuItem(
                  value: "zh_TW",
                  child: Text(AppLocalizations.of(context)!.chineseTW),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
