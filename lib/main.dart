import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class FCMService {
  static Future<void> sendNotificationToUser(
    String userId,
    String title,
    String body,
  ) async {
    try {
      await Firebase.initializeApp();
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        print('FCM token not found for user: $userId');
        return;
      }
      final Map<String, dynamic> notificationData = {
        'notification': {'title': title, 'body': body},
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        }
      };

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAnP25oUw:APA91bFamovJSeDLP-JAu_ZCx4nJVWp1sBv5qPGxfAkKAW4wfzxKqv1TBwFxfhoIBYv2kjBWcWmK_eyHYLsgt1I01KyZaDcA7jCoJLgg1m9i0KUyoHxbrTSkYL7Ir2Td44Gj2fsV1qjO', // Replace with your server key
        },
        body: jsonEncode(
          <String, dynamic>{
            'to': token,
            ...notificationData,
          },
        ),
      );
      print('Notification sent successfully to user: $userId');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}

// Example usage:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('Permission granted: ${settings.authorizationStatus}');
  messaging.getToken().then((token) {
    print("Device Token: $token");
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print('Handling a foreground message: ${message.messageId}');
    // print('Message data: ${message.data}');
    // print('Message notification: ${message.notification?.title}');
    // print('Message notification: ${message.notification?.body}');
    showNotification(flutterLocalNotificationsPlugin, message.notification!);
  });

  runApp(MyApp());
  initializeNotifications(flutterLocalNotificationsPlugin);
  configureNotifications(flutterLocalNotificationsPlugin);
}

void initializeNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: null);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void configureNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationChannel(
    'your_channel_id',
    'your_channel_name',
    description: 'your_channel_description',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidPlatformChannelSpecifics);
}

Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteNotification remoteNotification) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: null,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    remoteNotification.title,
    remoteNotification.body,
    platformChannelSpecifics,
    payload: 'Custom_Sound',
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Send Notification Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Replace 'USER_ID' with the actual ID of the user you want to send the notification to
              FCMService.sendNotificationToUser(
                'USER_ID',
                'Test Notification',
                'This is a test notification',
              );
            },
            child: Text('Send Notification'),
          ),
        ),
      ),
    );
  }
}
