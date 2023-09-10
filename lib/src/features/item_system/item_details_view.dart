import 'package:flutter/material.dart';

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({super.key});

  static const routeName = '/data_item';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final int id = arguments['id'];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Item Details'),
        ),
        body: Center(
            child: Column(
          children: [
            Text("ID:$id"),
            const Text('More Information Here'),
          ],
        )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Item Details'),
        ),
        body: const Center(
            child: Column(
          children: [
            Text('Having problem loading item'),
          ],
        )),
      );
    }
  }
}
