// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// import '../basic/views/route_view.dart';
// import 'bluetoothoffscreen.dart';
// import 'finddevicesscreen.dart';

// final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
// final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
// final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();
// final Map<DeviceIdentifier, ValueNotifier<bool>> isConnectingOrDisconnecting =
//     {};

// TextEditingController wifiNameController = TextEditingController();
// TextEditingController wifiPasswordController = TextEditingController();

// class BluetoothAdapterStateObserver extends NavigatorObserver {
//   StreamSubscription<BluetoothAdapterState>? _btStateSubscription;

//   @override
//   void didPush(Route route, Route? previousRoute) {
//     super.didPush(route, previousRoute);
//     if (route.settings.name == '/deviceScreen') {
//       _btStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
//         if (state != BluetoothAdapterState.on) {
//           navigator?.pop();
//         }
//       });
//     }
//   }

//   @override
//   void didPop(Route route, Route? previousRoute) {
//     super.didPop(route, previousRoute);
//     _btStateSubscription?.cancel();
//     _btStateSubscription = null;
//   }
// }

// class BluetoothView extends RouteView {
//   const BluetoothView({super.key})
//       : super(routeName: '/bluetooth', routeIcon: Icons.bluetooth);

//   @override
//   State<BluetoothView> createState() => _BluetoothScreenState();
// }

// class _BluetoothScreenState extends State<BluetoothView> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<BluetoothAdapterState>(
//       stream: FlutterBluePlus.adapterState,
//       initialData: BluetoothAdapterState.unknown,
//       builder: (c, snapshot) {
//         final adapterState = snapshot.data;
//         if (adapterState == BluetoothAdapterState.on) {
//           return const FindDevicesScreen();
//         } else {
//           FlutterBluePlus.stopScan();
//           return BluetoothOffScreen(adapterState: adapterState);
//         }
//       },
//     );
//   }
// }
