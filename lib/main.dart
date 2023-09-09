import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:ncue_app/src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    PhoneAuthProvider(),
    GoogleProvider(
        clientId:
            '117149850724-6c6lir1523514hstqh8c8cikcf06fcc3.apps.googleusercontent.com',
        redirectUri:
            'https://ncueapp.firebaseapp.com/__/auth/action?mode=action&oobCode=code'),
    FacebookProvider(clientId: '5237e52b036ec08a84952e02e921e11f'),
  ]);

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(AppRoot(settingsController: settingsController));
}
