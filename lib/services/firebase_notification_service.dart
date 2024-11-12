

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../firebase_options.dart';
import '../models/push_notification_model.dart';
import 'package:http/http.dart' as http;

import 'get_server_key.dart';

class FirebasePushNotificationService extends GetxService{

  final  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final  FirebaseFirestore _fireStore=  FirebaseFirestore.instance;
  late PushNotification _pushNotification;
  late NotificationSettings _notificationSettings;
  String _devicetoken = "";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  PushNotification get pushNotification => _pushNotification;

  //String get devicetoken => _devicetoken;




  Future<FirebasePushNotificationService> init() async {
    await initialise();
    return this;
  }

  Future initialise() async {

    FirebasePushNotificationService().getDeviceToken();
    ///Configure notification permissions

    //Android
    _notificationSettings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${_notificationSettings
        .authorizationStatus}');

    if (_notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('User granted permission');
      firebaseInit();
      setupInteractMessage();
    }
    else {
      print('User declined or has not accepted permission');
    }
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        _initLocalNotifications(message);
        showNotification(message);
      }
    });
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void _initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          // handle interaction when app is active for android
          handleMessage(message);
        });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage() async {
    // // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });

    // Handle terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
        RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(message);
      }
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: Constants.androidchanneldes,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
        sound: channel.sound
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    });
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> handleMessage(RemoteMessage message,) async {
    print(
        "Navigating to appointments screen. Hit here to handle the message. Message data: ${message
            .data}");

    /* Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(message: message),
      ),
    );*/

    // if (message.data['screen'] == 'cart') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const CartScreen(),
    //     ),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NotificationScreen(message: message),
    //     ),
    //   );
    // }
  }

  Future<String> getDeviceToken({int maxRetires = 3}) async {
    try {
      _devicetoken = await _fcm.getToken() ?? "";
      // await _firebaseService.storePlayerDeviceToken(token: _devicetoken, id: id);
      print("getUserDeviceToken: $_devicetoken");
      await saveTokentoFirestore(token: _devicetoken);
      return _devicetoken;
    }
    catch (e) {
      print("failed to get device token: ${e.toString()}");
      if (maxRetires > 0) {
        print("try after 10 sec");
        await Future.delayed(Duration(seconds: 10));
        return getDeviceToken(maxRetires: maxRetires - 1);
      } else {
        print("failed to get device token after 3 retries");
        return "";
      }
    }
  }

  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<void> saveTokentoFirestore({required String token}) async {
    bool isUserLoggedin = await isLoggedIn();
    print("User is logged in $isUserLoggedin");
    if (isUserLoggedin) {
      await _fireStore.collection(Constants.usersCollection)
          .doc(_auth.currentUser!.uid)
          .set({
        'device_token': token,
      }, SetOptions(merge: true));
    }
    // also save if token changes
    _fcm.onTokenRefresh.listen((event) async {
      if (isUserLoggedin) {
        await _fireStore.collection(Constants.usersCollection)
            .doc(_auth.currentUser!.uid)
            .set({
          'device_token': token,
        });
        print("save to firestore");
      }
    });
  }

  Future<void> sendNotificationUsingApi({
    required Map<String, dynamic> notificationdata,
  }) async {
    try {
      String serverKey = await GetServerKey().getServerKeyToken();
      print("notification server key => ${serverKey}");

      var headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      };

      //hit api
      final http.Response response = await http.post(
        Uri.parse(Constants.fcmSendNotificationUrl),
        headers: headers,
        body: jsonEncode(notificationdata),
      );
      print("notification response => ${response.body}");
      if (response.statusCode == 200) {
        print("Notification Send Successfully!");
      } else {
        print("Notification not send!");
      }
    }
    catch (e) {
      print("failed to send notification: ${e.toString()}");
    }
  }
}

