import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }

  Future<void> displayImageFromFirestore(context, String imageId) async {
    final imageUrl = await fetchImageUrl(imageId);
    showDialog(
      context: context,
      builder: (context) {
        return displayImage(imageUrl);
      },
    );
    displayImage(imageUrl);
    callback();
  }

  Future<void> downloadImage(String imageId) async {
    final imageUrl = await fetchImageUrl(imageId);
    final response = await get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = '$imageId.png';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(bytes);

    Image.file(file, width: double.infinity);
  }

  Widget getUnit(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
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
      ),
    );
  }
}
