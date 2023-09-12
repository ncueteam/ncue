import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/devices/device_model.dart';

class DeviceDetailsView extends StatelessWidget {
  const DeviceDetailsView({super.key});

  static const routeName = '/data_item';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final DeviceModel item = arguments['data'];

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
          title: const Text('裝置內容'),
        ),
        body: const Center(
            child: Column(
          children: [
            Text('無法載入 / 載入錯誤'),
          ],
        )),
      );
    }
  }
}
