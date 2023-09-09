import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'data_item.dart';
import 'item_details_view.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  static const routeName = '/item_list_view';

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final user = FirebaseAuth.instance.currentUser;
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
        title: const Text("item list view"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-in');
              },
              icon: const Icon(Icons.login_sharp)),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
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
