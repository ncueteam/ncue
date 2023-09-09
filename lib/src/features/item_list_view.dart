import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'data_item.dart';
import 'item_details_view.dart';

class ItemListView extends StatelessWidget {
  const ItemListView({
    super.key,
    this.items = const [DataItem(1), DataItem(2), DataItem(3)],
  });

  static const routeName = '/';

  final List<DataItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
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
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text('SampleItem ${item.id}'),
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
