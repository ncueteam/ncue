// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';

// class FileService {
//   final storage =
//       FirebaseStorage.instanceFor(bucket: "gs://ncueapp.appspot.com");
//   final ref = FirebaseStorage.instance.ref();

//   Future<void> upload(File file) async {}

//   Future<Directory> getApplicationDocumentsDirectory() async {
//     final String? path = await getApplicationDocumentsPath();
//     if (path == null) {
//       throw MissingPlatformDirectoryException(
//           'Unable to get application documents directory');
//     }
//     return Directory(path);
//   }
// }
