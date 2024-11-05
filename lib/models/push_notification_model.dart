import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotification {
  PushNotification({
    @required this.notification,
    @required this.data,
    this.sentTime,
    this.token
  });

  FNotification? notification;
  Data? data;
  DateTime? sentTime;
  String? token;

  factory PushNotification.fromJson(Map<String, dynamic> json) => PushNotification(
    notification: FNotification.fromJson(json["notification"]),
    data: Data.fromJson(json["data"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "notification": notification?.toJson(),
    "data": data?.toJson(),
    "to": token,
  };
}

class Data {
  Data({
    @required this.payloadFor,
    @required this.requestedPlayer,
    @required this.playerId,
    @required this.playerToken,
  });

  String? payloadFor;
  String? requestedPlayer;
  String? playerId;
  String? playerToken;


  factory Data.fromJson(Map<String, dynamic> json) => Data(
    payloadFor: json["Payload For"],
    requestedPlayer: json["Requested Player"],
    playerId: json["PlayerId"],
    playerToken: json["Player token"],
  );

  Map<String, dynamic> toJson() => {
    "Payload For": payloadFor,
    "Requested Player": requestedPlayer,
    "PlayerId": playerId,
    "Player token": playerToken,
  };
}

class FNotification {
  FNotification({
    @required this.body,
    @required this.title,
  });

  String? body;
  String? title;

  factory FNotification.fromJson(RemoteNotification? notification) => FNotification(
    body: notification?.body,
    title: notification?.title,
  );

  Map<String, dynamic> toJson() => {
    "body": body,
    "title": title,
  };
}



