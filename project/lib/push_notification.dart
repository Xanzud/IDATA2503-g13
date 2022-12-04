import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/services/repository.dart';
import 'firebase_options.dart';

class PushNotification extends StatefulWidget {
  PushNotification({required Key key}) : super(key: key); //This is the semi-colon.

@override
_PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {

  @override
  void initState(){
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null) {
         print(message.notification!.body);
         print(message.notification!.title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}