import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class RemoteModel {
  late int launch;
  late String protocol;
  late int low;
  late int high;
  Map<String, List<int>> data = {};

  RemoteModel(int iLaunch, String iProtocol, int iLow, int iHigh,
      Map<String, List<int>> iData) {
    launch = iLaunch;
    protocol = iProtocol;
    low = iLow;
    high = iHigh;
    data = iData;
  }

  Map<String, dynamic> getDocument() {
    return {"launch": launch, "low": low, "high": high, "data": data};
  }

  List<int> getCode(String key) {
    List<int> temp = [];
    temp.addAll([launch, launch]);
    data[key]?.forEach((element) {
      temp.add(element == 0 ? low : high);
    });
    return temp;
  }

  List<int> getCodeFromData(List<int> iData) {
    List<int> temp = [];
    temp.addAll([launch, launch]);
    for (int i = 0; i < iData.length; i++) {
      temp.add(iData[i] == 0 ? low : high);
    }
    return temp;
  }

  Future<RemoteModel> create() async {
    await RouteView.database
        .collection('remote')
        .doc(protocol)
        .set(getDocument());
    return this;
  }

  Future<RemoteModel> read(String protocolName) async {
    try {
      Map<String, dynamic> data = (await RouteView.database
              .collection('remote')
              .doc(protocolName)
              .get())
          .data() as Map<String, dynamic>;
      launch = data["launch"];
      low = data["low"];
      high = data["high"];
      data = data["data"];
    } catch (e) {
      create();
    }

    return this;
  }

  Future<RemoteModel> update() async {
    DocumentReference data =
        RouteView.database.collection('remote').doc(protocol);
    try {
      data.update(getDocument());
    } catch (e) {
      create();
    }
    return this;
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance
        .collection('remote')
        .doc(protocol)
        .delete();
  }
}
