import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../basic/views/route_view.dart';

class SmsView extends RouteView {
  const SmsView({key})
      : super(key, routeName: '/sms', routeIcon: Icons.message);
  @override
  State<SmsView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<SmsView> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
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
  }
}
