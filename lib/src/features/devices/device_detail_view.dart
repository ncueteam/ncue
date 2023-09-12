import 'package:flutter/material.dart';
import 'package:ncue_app/src/features/devices/device_model.dart';

class DeviceDetailsView extends StatelessWidget {
  const DeviceDetailsView({super.key});

  static const routeName = '/device_detail_view';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final DeviceModel item = arguments['data'];

      return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "裝置名稱: ${item.name}",
                    style: const TextStyle(fontSize: 30),
                  ),
                  Text(
                    "裝置狀態: ${item.powerOn}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "裝置uuid: ${item.uuid}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "裝置類型: ${item.type}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "裝置圖像位置: ${item.iconPath}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "裝置生物驗證: ${item.isBioAuthcanted}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
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
