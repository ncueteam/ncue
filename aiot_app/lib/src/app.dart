import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'features/auth_system/sign_in_view.dart';
import 'features/basic/home_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/basic/route_view.dart';
import 'features/web_view/services/states.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: RouteView.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserModel()),
            ],
            builder: (BuildContext context, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  restorationScopeId: 'app',
                  locale: const Locale('tw'),
                  supportedLocales: const [
                    Locale('en'),
                    Locale('zh_tw'),
                  ],
                  localizationsDelegates: [
                    FirebaseUILocalizations.withDefaultOverrides(
                        LabelOverrides()),
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
                  }));
            });
      },
    );
  }
}

class LabelOverrides extends DefaultLocalizations {
  LabelOverrides();
  @override
  String get registerHintText => '還沒註冊帳號?';
  @override
  String get emailInputLabel => '輸入你的email';
  @override
  String get isNotAValidEmailErrorText => '請輸入有效的電子郵件';
  @override
  String get passwordIsRequiredErrorText => '請輸入密碼';
  @override
  String get emailIsRequiredErrorText => '請輸入電子郵件';
  @override
  String get signInActionText => '登入';
  @override
  String get registerActionText => '註冊';
  @override
  String get passwordInputLabel => '密碼';
  @override
  String get signInWithPhoneButtonText => "手機登入";
  @override
  String get signInWithGoogleButtonText => "google 登入";
  @override
  String get signInWithFacebookButtonText => "facebook 登入";
  @override
  String get signInText => '登入';
  @override
  String get registerText => '註冊';
  @override
  String get forgotPasswordViewTitle => '忘記密碼';
  @override
  String get forgotPasswordButtonLabel => '忘記密碼?';
  @override
  String get resetPasswordButtonLabel => '重設密碼';
  @override
  String get goBackButtonLabel => '返回';
  @override
  String get unknownError => '未知錯誤';
}
