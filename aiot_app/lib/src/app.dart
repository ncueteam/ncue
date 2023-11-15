import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/auth_system/sign_in_view.dart';
import 'features/basic/views/home_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/basic/views/route_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: RouteView.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          locale: Locale(RouteView.settingsController.locale),
          supportedLocales: const [
            Locale('zh', 'TW'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FirebaseUILocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.brown,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: RouteView.settingsController.themeMode,
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? const SignInView().routeName
              : const Home().routeName,
          routes: RouteView.pages.fold({}, (map, routeView) {
            map[routeView.routeName] = (context) => routeView;
            return map;
          }),
        );
      },
    );
  }
}
