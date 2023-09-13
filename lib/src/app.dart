import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ncue_app/src/features/basic/password_reset_view.dart';
import 'package:ncue_app/src/features/basic/phone_input_view.dart';
import 'package:ncue_app/src/features/basic/profile_view.dart';
import 'package:ncue_app/src/features/basic/sign_in_view.dart';
import 'package:ncue_app/src/features/basic/sms_view.dart';
import 'package:ncue_app/src/features/devices/device_detail_view.dart';
import 'package:ncue_app/src/features/web_view/webview.dart';

import 'features/bluetooth/FlutterBlueApp.dart';
import 'features/basic/home_view.dart';
import 'features/item_system/item_details_view.dart';
import 'features/mqtt/mqttapp.dart';
import 'features/settings/settings_controller.dart';
import 'features/settings/settings_view.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            locale: const Locale('en'),
            localizationsDelegates: [
              FirebaseUILocalizations.withDefaultOverrides(LabelOverrides()),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FirebaseUILocalizations.delegate,
            ],
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? SignInView.routeName
                : Home.routeName,
            routes: {
              Home.routeName: (context) => const Home(),
              SignInView.routeName: (context) => const SignInView(),
              ProfileView.routeName: (context) => const ProfileView(),
              DeviceDetailsView.routeName: (context) =>
                  const DeviceDetailsView(),
              PasswordResetView.routeName: (context) =>
                  const PasswordResetView(),
              PhoneView.routeName: (context) => const PhoneView(),
              SmsView.routeName: (context) => const SmsView(),
              FlutterBlueApp.routeName: (context) => const FlutterBlueApp(),
              MqttPage.routeName: (context) => const MqttPage(),
              SettingsView.routeName: (context) =>
                  SettingsView(controller: settingsController),
              ItemDetailsView.routeName: (context) => const ItemDetailsView(),
              WebView.routeName: (context) => const WebView()
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
