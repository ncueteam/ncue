import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'data_item.dart';
import 'item_details_view.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key, required this.items});

  static const routeName = '/';

  final List<DataItem> items;

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("item list view"),
        actions: [
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
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];

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
