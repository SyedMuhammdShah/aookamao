import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

void showSuccessSnackbar(String message) {
  Get.snackbar(
    "Success",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green[400],
    colorText: Colors.white,
    icon: Icon(Icons.check_circle, color: Colors.white),
    margin: EdgeInsets.all(16),
    borderRadius: 8,
    duration: Duration(seconds: 3),
  );
}
void showErrorSnackbar(String message) {
  Get.snackbar(
    "Error",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red[400],
    colorText: Colors.white,
    icon: Icon(Icons.error, color: Colors.white),
    margin: EdgeInsets.all(16),
    borderRadius: 8,
    duration: Duration(seconds: 3),
  );
}