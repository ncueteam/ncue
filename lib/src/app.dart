import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ncue_app/src/features/auth/auth_view.dart';
import 'package:ncue_app/src/features/data_item.dart';

import 'features/item_details_view.dart';
import 'features/item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AnimatedBuilder(
              animation: settingsController,
              builder: (BuildContext context, Widget? child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  restorationScopeId: 'app',
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  onGenerateTitle: (BuildContext context) =>
                      AppLocalizations.of(context)!.appTitle,
                  theme: ThemeData(),
                  darkTheme: ThemeData.dark(),
                  themeMode: settingsController.themeMode,
                  onGenerateRoute: (RouteSettings routeSettings) {
                    final user = FirebaseAuth.instance.currentUser;
                    List<DataItem> data = [DataItem(1, user!.uid)];
                    if (user.displayName != null) {
                      data.add(DataItem(2, user.displayName.toString()));
                    }
                    if (user.email != null) {
                      data.add(DataItem(3, user.email.toString()));
                    }
                    return MaterialPageRoute<void>(
                      settings: routeSettings,
                      builder: (BuildContext context) {
                        switch (routeSettings.name) {
                          case SettingsView.routeName:
                            return SettingsView(controller: settingsController);
                          case ItemDetailsView.routeName:
                            return const ItemDetailsView();
                          case ItemListView.routeName:
                          default:
                            return ItemListView(
                              items: data,
                            );
                        }
                      },
                    );
                  },
                );
              },
            );
          } else {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: AuthView(),
            );
          }
        });
  }
}
