import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FileService {
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://ncueapp.appspot.com");
  final ref = FirebaseStorage.instance.ref();
  final void Function() callback;

  PlatformFile? pickedFile;

  UploadTask? uploadTask;

  FileService(this.callback);

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    pickedFile = result.files.first;
    pickedFile = result.files.first;
    callback();
  }

  Future uploadFile() async {
    if (pickedFile != null) {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {
        callback();
      });
      final urlDownload = await snapshot.ref.getDownloadURL();

      debugPrint('link: $urlDownload');
      pickedFile = null;
    }
    callback();
  }

  Future<String> fetchImageUrl(String imageId) async {
    final ref = FirebaseStorage.instance.ref().child('files/$imageId');

    final urlDownload = await ref.getDownloadURL();

    return urlDownload;
  }

  Widget displayImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.contain,
    );
  }

  Future<void> displayImageFromFirestore(String imageId) async {
    final imageUrl = await fetchImageUrl(imageId);
    displayImage(imageUrl);
  }

  Widget getInterface(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (pickedFile != null)
            if (['jpg', 'jpeg', 'png'].contains(pickedFile!.extension))
              Expanded(
                  child: Image.file(
                File(pickedFile!.path!),
                width: double.infinity,
                fit: BoxFit.contain,
              ))
            else
              Text(pickedFile!.name),
          ElevatedButton(
              onPressed: selectImage,
              child: Text(AppLocalizations.of(context)!.selectFile)),
          ElevatedButton(
              onPressed: uploadFile,
              child: Text(AppLocalizations.of(context)!.uploadFile)),
        ],
      ),
    );
  }
}
