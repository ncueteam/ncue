import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:ncue.aiot_app/src/features/notify_system/notify_service.dart';
import 'firebase_options.dart';
import 'src/app.dart';
import 'src/features/basic/views/route_view.dart';

String clientID =
    '117149850724-6c6lir1523514hstqh8c8cikcf06fcc3.apps.googleusercontent.com';
String redirectUri =
    'https://ncueapp.firebaseapp.com/__/auth/action?mode=action&oobCode=code';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    // PhoneAuthProvider(),
    GoogleProvider(clientId: clientID, redirectUri: redirectUri),
    // FacebookProvider(clientId: '5237e52b036ec08a84952e02e921e11f'),
  ]);
  await NotifyApi().initNotifications();
  await RouteView.loadRouteViewSettings();
  runApp(const AppRoot());
}
