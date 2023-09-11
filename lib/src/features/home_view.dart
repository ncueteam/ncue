import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'settings/settings_view.dart';
import 'item_system/data_item.dart';
import 'item_system/item_details_view.dart';
import 'bluetooth/flutterblueapp.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    List<DataItem> items = [];
    if (user != null) {
      items.add(DataItem(1, user.uid));
      if (user.displayName != null) {
        items.add(DataItem(2, user.displayName.toString()));
      }
      if (user.email != null) {
        items.add(DataItem(3, user.email.toString()));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-in');
              },
              icon: const Icon(Icons.login_sharp)),
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                icon: const Icon(Icons.account_box_sharp)),
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bluetooth');
            },
            icon: const Icon(Icons.compare_arrows),
          ),
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.chat),
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text('[${item.id}]   ${item.data}'),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                    context, ItemDetailsView.routeName,
                    arguments: {'id': item.id});
              });
        },
      ),
    );
  }
}
