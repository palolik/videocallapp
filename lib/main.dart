import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class FCMService {
  static Future<String?> getTokenForUser(String userId) async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
var userId = 'MYCXmjkoXIU6MQTuz0nCoSlyFPp2';
      // Reference to the user's document in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Retrieve the FCM token from the document
        return userDoc['token']; // Assuming 'token' is the field name where FCM token is stored
      } else {
        print('User document not found for user: $userId');
        return null;
      }
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> sendNotificationToUser(
      String userId,
      String title,
      String body,
      ) async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Retrieve the FCM token for the user
      String? token = await getTokenForUser(userId);
      if (token == null) {
        print('FCM token not found for user: $userId');
        return;
      }

      // Prepare the notification payload
      final Map<String, dynamic> notificationData = {
        'notification': {'title': title, 'body': body},
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        }
      };

      // Send the notification to the user via FCM
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAnP25oUw:APA91bFamovJSeDLP-JAu_ZCx4nJVWp1sBv5qPGxfAkKAW4wfzxKqv1TBwFxfhoIBYv2kjBWcWmK_eyHYLsgt1I01KyZaDcA7jCoJLgg1m9i0KUyoHxbrTSkYL7Ir2Td44Gj2fsV1qjO', // Replace with your server key
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
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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