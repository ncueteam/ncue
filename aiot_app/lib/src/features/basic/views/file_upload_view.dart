import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/features/basic/services/file_service.dart';
import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

class FileUploadView extends RouteView {
  const FileUploadView({super.key})
      : super(routeIcon: Icons.upload_file, routeName: "/upload_page");

  @override
  State<FileUploadView> createState() => _FileUploadViewState();
}

class _FileUploadViewState extends State<FileUploadView> {
  late FileService fileService;

  @override
  void initState() {
    fileService = FileService(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.routeName)),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("選擇圖片並上傳!"),
            ),
            Expanded(
              child: fileService.getInterface(context),
            ),
            ElevatedButton(
              onPressed: () =>
                  fileService.displayImageFromFirestore('server-icon.png'),
              child: const Text('Display Image'),
            ),
          ],
        ));
  }
}
