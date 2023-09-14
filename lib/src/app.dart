import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ncue_app/src/features/basic/password_reset_view.dart';
import 'package:ncue_app/src/features/basic/phone_input_view.dart';
import 'package:ncue_app/src/features/basic/profile_view.dart';
import 'package:ncue_app/src/features/basic/route_view.dart';
import 'package:ncue_app/src/features/basic/sign_in_view.dart';
import 'package:ncue_app/src/features/basic/sms_view.dart';
import 'package:ncue_app/src/features/devices/device_detail_view.dart';
import 'package:ncue_app/src/features/web_view/webview.dart';

import 'features/basic/home_view.dart';
import 'features/bluetooth/flutterblueapp.dart';
import 'features/item_system/item_details_view.dart';
import 'features/mqtt/mqttapp.dart';
import 'features/settings/settings_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: RouteView.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            locale: const Locale('en'),
            supportedLocales: const [
              Locale('en'),
              Locale('zh_tw'),
            ],
            localizationsDelegates: [
              FirebaseUILocalizations.withDefaultOverrides(LabelOverrides()),
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FirebaseUILocalizations.delegate,
            ],
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: RouteView.settingsController.themeMode,
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? const SignInView().routeName
                : const Home().routeName,
            routes: {
              const Home().routeName: (context) => const Home(),
              const SignInView().routeName: (context) => const SignInView(),
              const ProfileView().routeName: (context) => const ProfileView(),
              DeviceDetailsView.routeName: (context) =>
                  const DeviceDetailsView(),
              const PasswordResetView().routeName: (context) =>
                  const PasswordResetView(),
              const PhoneView().routeName: (context) => const PhoneView(),
              const SmsView().routeName: (context) => const SmsView(),
              const BluetoothView().routeName: (context) =>
                  const BluetoothView(),
              const MqttPage().routeName: (context) => const MqttPage(),
              const SettingsView().routeName: (context) => const SettingsView(),
              const ItemDetailsView().routeName: (context) =>
                  const ItemDetailsView(),
              const WebView().routeName: (context) => const WebView(),
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
