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

  Future selectImage(BuildContext context) async {
    await FilePicker.platform.pickFiles().then((value) {
      if (value == null) return;
      pickedFile = value.files.first;
      callback();
      if (['jpg', 'jpeg', 'png'].contains(pickedFile!.extension)) {
        displayImageFromFirestore(context, pickedFile!.name);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          pickedFile!.name,
                          style: const TextStyle(
                              color: Colors.white70,
                              decoration: TextDecoration.none),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          uploadFile();
                        },
                        child: Text(AppLocalizations.of(context)!.uploadFile)),
                  ],
                ),
              ));
            });
      }
    });
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

  Future<void> displayImageFromFirestore(context, String imageId) async {
    final imageUrl = await fetchImageUrl(imageId);
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
            onTapUp: (details) {
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ],
            ));
      },
    );
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
            ElevatedButton(
                onPressed: () => selectImage(context),
                child: Text(AppLocalizations.of(context)!.selectFile)),
            // ElevatedButton(
            //     onPressed: uploadFile,
            //     child: Text(AppLocalizations.of(context)!.uploadFile)),
          ],
        ),
      ),
    );
  }
}
