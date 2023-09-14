import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ncue_app/src/features/devices/device_model.dart';

class DeviceService {
  FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<DeviceModel>> loadDeviceData() async {
    List<DeviceModel> data = [];
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot = await devices.get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> result = document.data() as Map<String, dynamic>;
      DeviceModel temp = DeviceModel(
          result['device_name'], result['powerOn'], result['uuid'],
          iconPath: result['iconPath'], type: result['type']);
      data.add(temp);
    }
    return data;
  }

  Future<void> updateDeviceData(DeviceModel device) async {
    CollectionReference devices =
        FirebaseFirestore.instance.collection('devices');
    QuerySnapshot querySnapshot =
        await devices.where('uuid', isEqualTo: device.uuid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = devices.doc(documentSnapshot.id);

      Map<String, dynamic> updatedData = {
        'uuid': device.uuid,
        'device_name': device.name,
        'iconPath': device.iconPath,
        'powerOn': device.powerOn,
      };
      await documentReference.update(updatedData);
    } else {
      await FirebaseFirestore.instance.collection('devices').add({
        'uuid': device.uuid,
        'device_name': device.name,
        'iconPath': device.iconPath,
        'powerOn': device.powerOn,
      });
    }
  }

  Future<void> addDevice(String uuid, String type, String deviceName,
      String iconPath, bool powerOn) async {
    database.collection('devices').add({
      "type": type,
      "uuid": uuid,
      "device_name": deviceName,
      "iconPath": iconPath,
      "powerOn": powerOn,
    });
  }
}
