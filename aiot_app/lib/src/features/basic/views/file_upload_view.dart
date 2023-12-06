// import 'package:flutter/material.dart';
// import 'package:ncue.aiot_app/src/features/basic/services/file_service.dart';
// import 'package:ncue.aiot_app/src/features/basic/views/route_view.dart';

// class FileUploadView extends RouteView {
//   const FileUploadView({key})
//       : super(key, routeIcon: Icons.upload_file, routeName: "/upload_page");

//   @override
//   State<FileUploadView> createState() => _FileUploadViewState();
// }

// class _FileUploadViewState extends State<FileUploadView> {
//   late FileService fileService;

//   @override
//   void initState() {
//     fileService = FileService(() {
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text(widget.routeName)),
//         body: Column(
//           children: [
//             Expanded(
//               child: fileService.getUnit(context),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 fileService.displayImageFromFirestore(
//                     context, 'server-icon.png');
//                 fileService.downloadImage('server-icon.png');
//               },
//               child: const Text('Display Image'),
//             ),
//           ],
//         ));
//   }
// }
