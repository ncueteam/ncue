import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/route_view.dart';

class IRDeviceControlPanel extends RouteView {
  const IRDeviceControlPanel({super.key})
      : super(routeIcon: Icons.speaker_phone, routeName: "/ir-controll");

  @override
  State<IRDeviceControlPanel> createState() => _IRDeviceControlPanelState();
}

class _IRDeviceControlPanelState extends State<IRDeviceControlPanel> {
  List buttons = [
    Icons.space_bar,
    Icons.keyboard_arrow_up,
    Icons.space_bar,
    Icons.keyboard_arrow_left,
    Icons.center_focus_strong,
    Icons.keyboard_arrow_right,
    Icons.space_bar,
    Icons.keyboard_arrow_down,
    Icons.space_bar,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("電視遙控器")),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            itemCount: buttons.length,
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                child: Container(
                  color: Colors.green,
                  child: Center(
                      child: buttons[index] is IconData
                          ? Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                color: Colors.red,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(100, 100))),
                                  child: Icon(buttons[index]),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text("${buttons[index]}"),
                              ),
                            )),
                ),
              );
            }),
      ),
    );
  }
}
