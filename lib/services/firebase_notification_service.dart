

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/constants.dart';
import '../models/push_notification_model.dart';
import 'package:http/http.dart' as http;

class FirebasePushNotificationService {

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late PushNotification _pushNotification;
  late NotificationSettings _notificationSettings;
  late String _devicetoken;
  late AndroidNotificationChannel _androidNotificationChannel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();

  PushNotification get pushNotification => _pushNotification;
  //String get devicetoken => _devicetoken;



  Future initialise() async {

    ///Configure notification permissions

    //IOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

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
    print('User granted permission: ${_notificationSettings.authorizationStatus}');

    if (_notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {

      // print('User granted permission');

      // For handling the received notifications

      //Get the message from tapping on the notification when app is not in foreground
      RemoteMessage? initialMessage = await  _fcm.getInitialMessage();
      //If the message contains a service, navigate to the admin
      if (initialMessage != null) {
        _pushNotification =PushNotification(notification:FNotification.fromJson(initialMessage.notification) , data: Data.fromJson(initialMessage.data), sentTime: initialMessage.sentTime);
      }
      //This listens for messages when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print("onMessageOpenedApp: ${event.data}");
        _pushNotification =PushNotification(notification:FNotification.fromJson(event.notification) , data: Data.fromJson(event.data),sentTime: event.sentTime);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        _pushNotification =PushNotification(notification:FNotification.fromJson(message.notification) , data: Data.fromJson(message.data),sentTime: message.sentTime);
        onGameRequest(_pushNotification);
        RemoteNotification? remoteNotification = message.notification;
        AndroidNotification? androidNotification = message.notification?.android;

        print("onMessage from: ${message.from}");

        _androidNotificationChannel=  AndroidNotificationChannel(
          Constants.androidchannelid,
          Constants.androidchanneltittle,
          description: Constants.androidchanneldes,
          importance: Importance.max,
          showBadge: true,
          playSound: true,
        );

        await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_androidNotificationChannel);

        if(remoteNotification != null && androidNotification != null){
          flutterLocalNotificationsPlugin.show(
              remoteNotification.hashCode,
              remoteNotification.title,
              remoteNotification.body,
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      _androidNotificationChannel.id,
                      _androidNotificationChannel.name,
                      channelDescription: _androidNotificationChannel.description,
                      icon: "@mipmap/ic_launcher",
                      playSound: _androidNotificationChannel.playSound,
                      channelShowBadge: _androidNotificationChannel.showBadge
                  )
              )
          );
        }

      });

    }
    else {
      print('User declined or has not accepted permission');
    }
  }

  Future<String> getUserDeviceToken(String id) async{
    _devicetoken = await _fcm.getToken()??"";

    await _firebaseService.storePlayerDeviceToken(token: _devicetoken, id: id);
    print("getUserDeviceToken: $_devicetoken");
    return _devicetoken;
  }

  /// todo refreshuserdevicetoken


  ///Send Confirmation Message to User
  Future sendNotificationToUser({required Player selectedPlayer}) async {

    //Our API Key
    var serverKey = dotenv.get('Server_key');

    //selected player device token
    var token= selectedPlayer.device_token;

    print("serverKey: $serverKey");

    if(serverKey.isEmpty&&token.isEmpty)
    {
      return;
    }

    //current player
    var currentPlayer =_authService.getcurrentPlayer;

    //Create Message with Notification Payload
    String constructFCMPayload() {
      return jsonEncode(
          PushNotification(
              notification: FNotification(title: "Request For Game",body: "Hi! ${currentPlayer.username} Wants To Play Game With You Online."),
              data: Data(payloadFor: "Requesting For Game",playerId: currentPlayer.id,playerToken: currentPlayer.device_token,requestedPlayer: currentPlayer.username),
              token:token).toJson()
      );
    }

    try {
      //Send  Message
      http.Response response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: constructFCMPayload());

      print("status: ${response.statusCode} | Message Sent Successfully!");
      if(response.statusCode == 200)
      {
        return true;
      }

    }
    catch (e) {
      print("error push notification $e");
      return e.toString();
    }
  }

  onGameRequest(PushNotification pushNotification) async {
    if(pushNotification.data?.payloadFor=="Requesting For Game"){
      _navigationService.navigateToGameBoardView();

      final dialogresponse =await _dialogService.showCustomDialog(
        variant: DialogType.basic,
        title: pushNotification.data?.requestedPlayer,
        description: pushNotification.data?.payloadFor,
        secondaryButtonTitle: "cancel",
        mainButtonTitle: "Accept",
        hasImage: true,
        imageUrl: "assets/images/logo.png",

      );
      if(dialogresponse!.confirmed){
        /// accept
      }
      else{
        _navigationService.back();
      }
    }
  }


}

