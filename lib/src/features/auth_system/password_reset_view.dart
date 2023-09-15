import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../basic/route_view.dart';

class PasswordResetView extends RouteView {
  const PasswordResetView({super.key})
      : super(routeName: "/forgot-password", routeIcon: Icons.password);

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  @override
  Widget build(BuildContext context) {
    return const ForgotPasswordScreen();
  }
}
