import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {

  Future<String> getServerKeyToken() async {
  final scopes = [
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/firebase.database',
  'https://www.googleapis.com/auth/firebase.messaging',
  ];

  final client = await clientViaServiceAccount(
    //load file from assets
  ServiceAccountCredentials.fromJson(
  await loadJsonFromAssets('assets/service_account_key.json')
  ),
  scopes,
  );
  final accessServerKey = client.credentials.accessToken.data;
  print("accessServerKey: $accessServerKey");
  return accessServerKey;
  }

  Future<Map<String, dynamic>> loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }
}