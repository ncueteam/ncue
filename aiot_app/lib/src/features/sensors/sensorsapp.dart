import 'package:flutter/material.dart';
import '../basic/route_view.dart';
import 'package:lottie/lottie.dart';

class SensorsPage extends RouteView {
  const SensorsPage({super.key})
      : super(routeName: '/sensors', routeIcon: Icons.assessment);

  @override
  SensorsPageState createState() => SensorsPageState();
}

class SensorsPageState extends State<SensorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors Page'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 6,
                      blurRadius: 0,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    Lottie.asset(
                      'assets/lottie/LightRain.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                    const Text("62.00%",
                        style: TextStyle(
                          fontSize: 25,
                        )),
                    const Text('humidity')
                  ],
                )),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 6,
                      blurRadius: 0,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    Lottie.asset(
                      'assets/lottie/day.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                    const Text("32.50°C",
                        style: TextStyle(
                          fontSize: 25,
                        )),
                    const Text('Temperature')
                  ],
                )),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
