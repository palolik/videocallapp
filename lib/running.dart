// import 'dart:async';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// const appId = "79ffc2d7dbc7434da06ad1351535dc85";
// const token = "007eJxTYKhfuWtZyhPPo/YOXQJnVF7pvvl0Wf/WmZe1jBFCJ+w+eigoMJhbpqUlG6WYpyQlm5sYm6QkGpglphgamxqaGpumJFuY6stbpzUEMjJEHMpkZmSAQBCflSEvsazSiIEBAMQ3H/k=";
// const channel = "navy2";
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // Initialize local notifications
//   final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//   try {
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   } catch (e) {
//     print('Error initializing notifications: $e');
//   }
//
//   // Set up Firebase Cloud Messaging
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   runApp(const MaterialApp(home: MyApp()));
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Handle incoming FCM messages here
//   if (message.notification != null) {
//     print('Background message received: ${message.notification!.title}');
//     _showNotification(message.notification!.title ?? '', message.notification!.body ?? '');
//   }
// }
//
// Future<void> _showNotification(String title, String body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'call_channel',
//     'Notifications for incoming calls',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _localUserJoined = false;
//   bool _isInCall = false;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//     _initializeFirebaseMessaging();
//   }
//
//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone].request();
//
//     // create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));
//
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _isInCall = true;
//           });
//           _showNotification('Incoming Call', 'You have an incoming call');
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _isInCall = false;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );
//
//     await _engine.enableAudio(); // Enable audio only
//     await _engine.joinChannel(
//       token: token,
//       channelId: channel,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   void _makeCall() {
//     // Logic to make a call
//     // For simplicity, let's assume that making a call means joining the channel
//     _joinChannel();
//   }
//
//   void _receiveCall() {
//     // Logic to receive the call
//     // For simplicity, let's assume that receiving the call means joining the channel
//     _joinChannel();
//   }
//
//   void _endCall() {
//     // Logic to end the call
//     // For simplicity, let's assume that ending the call means leaving the channel
//     _leaveChannel();
//   }
//
//   Future<void> _joinChannel() async {
//     await _engine.joinChannel(token: token, channelId: channel, uid: 0, options: const ChannelMediaOptions());
//     setState(() {
//       _isInCall = true;
//     });
//   }
//
//   Future<void> _leaveChannel() async {
//     await _engine.leaveChannel();
//     setState(() {
//       _isInCall = false;
//     });
//   }
//
//   void _initializeFirebaseMessaging() {
//     FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Audio Call Test'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _localUserJoined
//                 ? _isInCall
//                 ? const Text('In a call')
//                 : Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: _makeCall,
//                   child: const Text('Make Call'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _receiveCall();
//                   },
//                   child: const Text('Receive Call'),
//                 ),
//               ],
//             )
//                 : const CircularProgressIndicator(),
//             if (_isInCall)
//               ElevatedButton(
//                 onPressed: _endCall,
//                 child: const Text('End Call'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
