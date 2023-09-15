import 'package:flutter/material.dart';
import '../basic/route_view.dart';
import 'data_item.dart';

class ItemDetailsView extends RouteView {
  const ItemDetailsView({super.key})
      : super(routeName: '/data_item', routeIcon: Icons.details);

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final DataItem item = arguments['item'];

      return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: const Center(
            child: Column(
          children: [
            Text('More Information Here'),
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
