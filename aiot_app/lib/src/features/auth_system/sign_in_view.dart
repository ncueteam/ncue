import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../basic/route_view.dart';
import '../settings/settings_view.dart';

class SignInView extends RouteView {
  const SignInView({super.key})
      : super(routeName: '/sign-in', routeIcon: Icons.login);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      styles: const {EmailFormStyle(signInButtonVariant: ButtonVariant.filled)},
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset('lib/src/icons/app_icon.png'),
        );
      },
      subtitleBuilder: (context, action) {
        return Align(
            alignment: Alignment.centerRight,
            child: const SettingsView().getIconButton(context));
      },
      actions: [
        ForgotPasswordAction((context, email) {
          Navigator.of(context)
              .pushNamed("/forgot-password", arguments: {'email': email});
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
  }
}
