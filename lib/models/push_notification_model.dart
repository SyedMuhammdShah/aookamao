import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotification {
  final String title;
  final String body;
  final Map<String,dynamic>? data;
  final String token;

  PushNotification({
    required this.title,
    required this.body,
    this.data,
    required this.token,
  });

  Map<String, dynamic> toJsonWithData() {
    return {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data,
      }
    };
  }

  Map<String, dynamic> toJsonNoData() {
    return {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
      }
    };
  }

}



