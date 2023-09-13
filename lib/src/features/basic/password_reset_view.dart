import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({super.key});

  static const routeName = '/forgot-password';
  static const routeIcon = Icons.password;

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  @override
  Widget build(BuildContext context) {
    return const ForgotPasswordScreen();
  }
}
