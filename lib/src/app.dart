import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/bluetooth/FlutterBlueApp.dart';
import 'features/home_view.dart';
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
                ? '/sign-in'
                : '/home',
            routes: {
              '/home': (context) => const Home(),
              '/sign-in': (context) {
                return SignInScreen(
                  styles: const {
                    EmailFormStyle(signInButtonVariant: ButtonVariant.filled)
                  },
                  headerBuilder: (context, constraints, shrinkOffset) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('lib/src/icons/app_icon.png'),
                    );
                  },
                  subtitleBuilder: (context, action) {
                    return Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.restorablePushNamed(
                                context, SettingsView.routeName);
                          },
                        ));
                  },
                  actions: [
                    ForgotPasswordAction((context, email) {
                      Navigator.of(context).pushNamed("/forgot-password",
                          arguments: {'email': email});
                    }),
                    AuthStateChangeAction<SignedIn>((context, state) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }),
                    AuthStateChangeAction<UserCreated>((context, state) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }),
                    VerifyPhoneAction(
                      (context, action) {
                        Navigator.pushNamed(context, '/phone');
                      },
                    )
                  ],
                );
              },
              '/profile': (context) => ProfileScreen(
                    appBar: AppBar(
                      backgroundColor: Colors.red,
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.pushReplacementNamed(context, '/sign-in');
                      })
                    ],
                  ),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/phone': (context) => PhoneInputScreen(
                    actions: [
                      SMSCodeRequestedAction(
                          (context, action, flowKey, phoneNumber) {
                        Navigator.of(context)
                            .pushReplacementNamed('/sms', arguments: {
                          'action': action,
                          'flowkey': flowKey,
                          'phone': phoneNumber,
                        });
                      })
                    ],
                  ),
              '/sms': (context) {
                final arguments = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>;
                return SMSCodeInputScreen(
                  actions: [
                    AuthStateChangeAction<SignedIn>(
                      (context, state) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    )
                  ],
                  flowKey: arguments['flowkey'],
                  action: arguments['action'],
                );
              },
              '/bluetooth': (context) => const FlutterBlueApp(),
              '/mqtt': (context) => const MqttPage(),
              SettingsView.routeName: (context) =>
                  SettingsView(controller: settingsController),
              ItemDetailsView.routeName: (context) => const ItemDetailsView(),
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
