import 'package:flutter/material.dart';

import '../basic/route_view.dart';
import 'device_model.dart';

class DeviceDetailsView extends RouteView {
  const DeviceDetailsView({super.key})
      : super(
            routeName: '/device_detail_view',
            routeIcon: Icons.medical_information);

  @override
  State<DeviceDetailsView> createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<DeviceDetailsView> {
  double valueDouble = 28;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final DeviceModel item = arguments['data'];
      return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            CircleAvatar(
                foregroundImage: AssetImage(item.iconPath),
                backgroundColor: Colors.white),
            Text("    ${item.name}", style: const TextStyle(fontSize: 30))
          ]),
        ),
        body: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "裝置狀態: ${item.powerOn ? "開啟" : "關閉"}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "裝置uuid: ${item.uuid}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "裝置類型: ${item.type == "device" ? "一般裝置" : "生物解鎖裝置"}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Slider(
                      value: valueDouble,
                      min: 16.0,
                      max: 30.0,
                      onChanged: (value) {
                        setState(() {
                          valueDouble = value;
                        });
                      }),
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
