// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'auth_service.dart';
// import 'login_button.dart';
// import 'styled_text_field.dart';

// class LoginView extends StatefulWidget {
//   final Function()? onTap;
//   const LoginView({super.key, required this.onTap});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   void signUserIn() async {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//       // SoundPlayer().playLocalAudio("lib/sounds/crystal.mp3");
//     } on FirebaseAuthException catch (e) {
//       Navigator.pop(context);
//       if (e.code == 'user-not-found') {
//         debugPrint('No user found for that email.');
//         wrongMessage("查無此帳號");
//       } else if (e.code == 'wrong-password') {
//         debugPrint('Wrong password provided for that user.');
//         wrongMessage("密碼錯誤");
//       }
//     }
//   }

//   void wrongMessage(String message) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//               title: Center(
//             child: Text(message),
//           ));
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             maintainBottomViewPadding: true,
//             child: SingleChildScrollView(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 50),
//                     const Icon(Icons.login, size: 100),
//                     const SizedBox(height: 50),
//                     const Text(
//                       "歡迎使用本系統",
//                     ),
//                     const SizedBox(height: 10),
//                     StyledTextField(
//                       controller: emailController,
//                       hintText: '使用者名稱',
//                       obscureText: false,
//                     ),
//                     const SizedBox(height: 10),
//                     StyledTextField(
//                       controller: passwordController,
//                       hintText: '密碼',
//                       obscureText: true,
//                     ),
//                     const SizedBox(height: 10),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 25.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             '忘記密碼?',
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 25),
//                     LoginButton(
//                       message: "登入",
//                       onTap: signUserIn,
//                     ),
//                     const SizedBox(height: 25),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 25.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: Divider(
//                             thickness: 5,
//                           )),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               '或用以下方式登入',
//                             ),
//                           ),
//                           Expanded(
//                               child: Divider(
//                             thickness: 5,
//                           ))
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 25),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SquareTile(
//                             onTap: () => AuthService().signInWithGoogle(),
//                             imagePath: 'lib/src/icons/google.png'),
//                         const SizedBox(width: 25),
//                         SquareTile(
//                             onTap: () {}, imagePath: 'lib/src/icons/apple.png')
//                       ],
//                     ),
//                     const SizedBox(height: 50),
//                     GestureDetector(
//                       onTap: widget.onTap,
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '還不是會員?',
//                           ),
//                           SizedBox(width: 4),
//                           Text('現在註冊!',
//                               style: TextStyle(fontWeight: FontWeight.bold))
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
// }
