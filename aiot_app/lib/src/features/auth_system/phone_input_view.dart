import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../basic/views/route_view.dart';

class PhoneView extends RouteView {
  const PhoneView({super.key})
      : super(routeName: '/phone', routeIcon: Icons.abc);

  @override
  State<PhoneView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<PhoneView> {
  @override
  Widget build(BuildContext context) {
    return PhoneInputScreen(
      actions: [
        SMSCodeRequestedAction((context, action, flowKey, phoneNumber) {
          Navigator.of(context).pushReplacementNamed('/sms', arguments: {
            'action': action,
            'flowkey': flowKey,
            'phone': phoneNumber,
          });
        })
      ],
    );
  }
}
