import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ncue.aiot_app/src/features/basic/models/room_model.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';
import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';

TextEditingController wifiNameController = TextEditingController();
TextEditingController wifiPasswordController = TextEditingController();
String roomId = "";

class BlueToothView extends RouteView {
  const BlueToothView({Key? key})
      : super(key, routeIcon: Icons.bluetooth, routeName: "/oldbt");

  @override
  State<BlueToothView> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<BlueToothView> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    RoomModel roomData = RoomModel();
    if (arguments != null && arguments is Map<String, dynamic>) {
      roomData = arguments['data'];
      roomId = (arguments['data'] as RoomModel).uuid;
    }
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? ScanScreen(
            roomID: roomData.uuid,
          )
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
