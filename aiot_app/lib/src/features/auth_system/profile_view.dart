import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../basic/views/route_view.dart';
import '../settings/settings_view.dart';
import 'sign_in_view.dart';

class ProfileView extends RouteView {
  const ProfileView({super.key})
      : super(routeName: '/profile', routeIcon: Icons.account_circle);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(),
      actions: [
        SignedOutAction((context) {
          Navigator.pushReplacementNamed(context, const SignInView().routeName);
        })
      ],
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: const SettingsView().getIconButton(context),
        ),
      ],
    );
  }
}
