import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class FileUploadView extends RouteView {
  const FileUploadView({super.key})
      : super(routeIcon: Icons.upload_file, routeName: "/upload_page");

  @override
  State<FileUploadView> createState() => _FileUploadViewState();
}

class _FileUploadViewState extends State<FileUploadView> {
  PlatformFile? pickedFile;

  UploadTask? uploadTask;

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.path!}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    debugPrint('link: $urlDownload');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (pickedFile != null) Expanded(child: Text(pickedFile!.name)),
          ElevatedButton(
              onPressed: selectImage, child: const Text("select file")),
          ElevatedButton(
              onPressed: uploadFile, child: const Text("upload file")),
        ]),
      ),
    );
  }
}
