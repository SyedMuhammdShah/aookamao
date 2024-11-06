import 'dart:io';

import 'package:aookamao/admin/admin_dashboard.dart';
import 'package:aookamao/app/models/user_model.dart';
import 'package:aookamao/app/modules/home/home_view.dart';
import 'package:aookamao/app/modules/landingPage/landing_page.dart';
import 'package:aookamao/retailer/models/retailer_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../retailer/screens/retailer_dashboard.dart';
import '../../../../services/firebase_notification_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  RxBool isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);


  Future<void> registerUser() async {
    isLoading.value = true;

    try {
      // Ensure Firebase is initialized before proceeding
      await Firebase.initializeApp();

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Save user details in Firestore
      await fireStore
          .collection('user_details')
          .doc(userCredential.user!.uid)
          .set({
        'user_name': nameController.text,
        'user_email': emailController.text,
        'address': addressController.text,
        'password': passwordController.text,
        'role': "user",
      });
      await FirebasePushNotificationService().getDeviceToken();
      Get.snackbar('Success', 'Registration Successful');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Function to login user and store data
  Future<void> loginUser() async {
    isLoading.value = true; // Show loading indicator
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the logged-in user's ID
      String userId = userCredential.user!.uid;

      // Fetch user details from Firestore
      DocumentSnapshot userDoc =
          await fireStore.collection('user_details').doc(userId).get();

      if (userDoc.exists) {
        // Retrieve role and user_name from Firestore
        String role = userDoc['role'];
        String userName =
            userDoc['user_name']; // Fetch user_name from Firestore
        String address = userDoc['address']; // Fetch address from Firestore

        print("User Role: $role");
        print("User Name: $userName");

        // Save user data in the currentUser variable
        currentUser.value = UserModel(
          uid: userId,
          email: userCredential.user!.email!,
          role: role,
          user_name: userName, // Use the user_name from Firestore
          address: address, // Use the address from Firestore
        );
        await FirebasePushNotificationService().getDeviceToken();
        // Navigate based on role
        if (role == 'admin') {
          Get.snackbar('Success', 'Welcome Admin');
          Get.offAll(() => AdminDashboard());
        } else if (role == 'user') {
          Get.snackbar('Success', 'Welcome User');
          Get.to(() => const LandingPage());
        } else {
          Get.snackbar('Error', 'Invalid role');
        }
      } else {
        Get.snackbar('Error', 'User data not found');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }



}
