// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
//
//
// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //
// //   final Future<FirebaseApp> _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //       future: _initialization,
// //       builder: (context, snapshot) {
// //         // CHeck for Errors
// //         if (snapshot.hasError) {
// //           print("Something went Wrong");
// //         }
// //         // once Completed, show your application
// //         if (snapshot.connectionState == ConnectionState.done) {
// //           return MaterialApp(
// //             debugShowCheckedModeBanner: false,
// //             home: MainScreen(),
// //           );
// //         }
// //         return CircularProgressIndicator();
// //       },
// //     );
// //   }
// // }
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   _MainScreenState createState() => _MainScreenState();
//
// }
//
// class _MainScreenState extends State<MainScreen> {
//   TextEditingController username = TextEditingController();
//   TextEditingController title = TextEditingController();
//   TextEditingController body = TextEditingController();
//   late AndroidNotificationChannel channel;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   String? mtoken = " ";
//
//   @override
//   void initState() {
//     super.initState();
//
//     requestPermission();
//
//     loadFCM();
//
//     listenFCM();
//
//     getToken();
//     Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
//     FirebaseMessaging.instance.subscribeToTopic("Animal");
//   }
//
//   void getTokenFromFirestore() async {
//
//   }
//
//   void saveToken(String token) async {
//     await FirebaseFirestore.instance.collection("users").doc("kmHvC3RtYBXvmfHtNNvYMxKUSd72").update({
//       'token' : token,
//     });
//   }
//
//   void sendPushMessage(String token, String body, String title) async {
//     try {
//       await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'key=AAAAnP25oUw:APA91bFamovJSeDLP-JAu_ZCx4nJVWp1sBv5qPGxfAkKAW4wfzxKqv1TBwFxfhoIBYv2kjBWcWmK_eyHYLsgt1I01KyZaDcA7jCoJLgg1m9i0KUyoHxbrTSkYL7Ir2Td44Gj2fsV1qjO',
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'notification': <String, dynamic>{
//               'body': body,
//               'title': title
//             },
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'id': '1',
//               'status': 'done'
//             },
//             "to": token,
//           },
//         ),
//       );
//     } catch (e) {
//       print("error push notification");
//     }
//   }
//
//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then(
//             (token) {
//           setState(() {
//             mtoken = token;
//           });
//
//           // saveToken(token!);
//         }
//     );
//   }
//
//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
//
//   void listenFCM() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null && !kIsWeb) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               // TODO add a proper drawable resource to android, for now using
//               //      one that already exists in example app.
//               icon: 'launch_background',
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   void loadFCM() async {
//     if (!kIsWeb) {
//       channel = const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         importance: Importance.high,
//         enableVibration: true,
//       );
//
//       flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//       /// Create an Android Notification Channel.
//       ///
//       /// We use this channel in the `AndroidManifest.xml` file to override the
//       /// default FCM channel to enable heads up notifications.
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//
//       /// Update the iOS foreground notification presentation options to allow
//       /// heads up notifications.
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: username,
//             ),
//             TextFormField(
//               controller: title,
//             ),
//             TextFormField(
//               controller: body,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 String name = username.text.trim();
//                 String titleText = title.text;
//                 String bodyText = body.text;
//
//                 if(name != "") {
//                   DocumentSnapshot snap =
//                   await FirebaseFirestore.instance.collection("users").doc(name).get();
//
//                   String token = snap['token'];
//                   print(token);
//
//                   sendPushMessage(token, titleText, bodyText);
//                 }
//               },
//               child: Container(
//                 height: 40,
//                 width: 200,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }