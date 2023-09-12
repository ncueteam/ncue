import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'settings/settings_view.dart';
import 'item_system/data_item.dart';
import 'item_system/item_details_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget getTile(DataItem item) {
    switch (item.data.elementAt(0)) {
      case "device":
        {
          return ListTile(
            tileColor: Colors.amber,
            leading: CircleAvatar(foregroundImage: AssetImage(item.iconPath)),
            onTap: () {
              Navigator.pushNamed(context, ItemDetailsView.routeName,
                  arguments: {'item': item});
            },
          );
        }
      default:
        return ListTile(
            title: Text('[${item.name}]   ${item.data}'),
            leading: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.saturation,
              ),
              child: CircleAvatar(
                foregroundImage: AssetImage(item.iconPath),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, ItemDetailsView.routeName,
                  arguments: {'id': item.id, 'item': item});
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    /*=================================================== */
    List<DataItem> items = [];
    if (user != null) {
      items.add(DataItem(1, [user.uid], "item name 1"));
      if (user.displayName != null) {
        items.add(DataItem(2, [user.displayName.toString()], "item name 2"));
      }
      if (user.email != null) {
        items.add(DataItem(3, [user.email.toString()], "item name 3"));
      }
    }
    items.add(DataItem(4, ["device", "test device data"], "device",
        iconPath: 'lib/src/icons/google.png'));
    /*=================================================== */
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
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          )
        ],
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          DataItem item = items[index];

          return getTile(item);
        },
      ),
    );
  }
}
