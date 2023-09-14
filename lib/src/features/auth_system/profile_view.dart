import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/basic/route_view.dart';
import 'package:ncue_app/src/features/auth_system/sign_in_view.dart';
import 'package:ncue_app/src/features/settings/settings_view.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
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
