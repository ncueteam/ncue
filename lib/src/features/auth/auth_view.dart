import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_view.dart';
import 'register_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  static const routeName = '/auth_view';

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool showLoginView = true;

  void toogleView() {
    setState(() {
      showLoginView = !showLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (showLoginView) {
              return LoginView(onTap: toogleView);
            } else {
              return RegisterView(onTap: toogleView);
            }
          }),
    );
  }
}
