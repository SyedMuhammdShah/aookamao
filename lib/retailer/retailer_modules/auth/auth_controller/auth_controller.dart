import 'dart:io';

import 'package:aookamao/admin/admin_dashboard.dart';
import 'package:aookamao/app/models/user_model.dart';
import 'package:aookamao/app/modules/home/home_view.dart';
import 'package:aookamao/app/modules/landingPage/landing_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/retailer_model.dart';
import '../../../screens/retailer_dashboard.dart';

class RetailerAuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final GlobalKey<FormState> retailer_signup_formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  Rx<File> cnicFrontFile = File('').obs;
  Rx<File> cnicBackFile = File('').obs;
  RxBool isLoading = false.obs;
  String cnicFrontUrl = '';
  String cnicBackUrl = '';
  late RetailerModel retailerUser;

  Future<void> registerRetailer()async{
    isLoading.value = true;
    try {
      // Ensure Firebase is initialized before proceeding
      await Firebase.initializeApp();

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await _uploadCnic(userCredential.user!.uid);
      // Save user details in Firestore
      await fireStore
          .collection('user_details')
          .doc(userCredential.user!.uid)
          .set({
        'user_name': nameController.text,
        'user_email': emailController.text,
        'cnic_number': cnicController.text,
        'cnic_front_image_url': cnicFrontUrl,
        'cnic_back_image_url': cnicBackUrl,
        'registered_at': Timestamp.now(),
        'role': "retailer",
      });

      await fireStore
          .collection('subscription')
          .doc(userCredential.user!.uid)
          .set({
        'user_id': userCredential.user!.uid,
        'subscription_status': 'none',
      });
      retailerUser = RetailerModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: nameController.text,
        cnic_number: cnicController.text,
        cnic_front_image_url: cnicFrontUrl,
        cnic_back_image_url: cnicBackUrl,
        subscription_status: 'none',
      );
      Get.offAll(() => RetailerDashboard());
      Get.snackbar('Success', 'Registration Successful');
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("error in registerRetailer: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _uploadCnic(String userid)async{
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('cnic_images/$userid/cnicfrontimg.jpg');
      TaskSnapshot task = await storageRef.putFile(cnicFrontFile.value);
      cnicFrontUrl = await task.ref.getDownloadURL();
      print("cnicFrontUrl: $cnicFrontUrl");
      Reference storageRef2 = FirebaseStorage.instance.ref().child(
          'cnic_images/$userid/cnicbackimg.jpg');
      TaskSnapshot task2 = await storageRef2.putFile(cnicBackFile.value);
      cnicBackUrl = await task2.ref.getDownloadURL();
      print("cnicBackUrl: $cnicBackUrl");
    }
    catch(e){
      Get.snackbar('Error', e.toString());
      print("error in uploadCnic: $e");
    }
  }
  void pickCnicImage({required bool isFront,required ImageSource imagesource}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: imagesource);
    if (image != null) {
      if (isFront) {
        cnicFrontFile.value = File(image.path);
      } else {
        cnicBackFile.value = File(image.path);
      }
    }
  }

  void removeCnicImage({required bool isFront}) {
    if (isFront) {
      cnicFrontFile.value = File('');
    } else {
      cnicBackFile.value = File('');
    }
  }

  void clearfields(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    addressController.clear();
    cnicController.clear();
    cnicFrontFile.value = File('');
    cnicBackFile.value = File('');
    cnicBackUrl='';
    cnicFrontUrl='';
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

    String userId = userCredential.user!.uid;

    DocumentSnapshot userDoc = await fireStore.collection('user_details').doc(userId).get();
    DocumentSnapshot subDoc = await fireStore.collection('subscription').doc(userId).get();

    if (userDoc.exists) {
      String role = userDoc['role'];
      String userName = userDoc['user_name'];
      String userEmail = userDoc['user_email'];
      String cnicNumber = userDoc['cnic_number'];
      String cnicFrontUrl = userDoc['cnic_front_image_url'];
      String cnicBackUrl = userDoc['cnic_back_image_url'];
      String subscriptionStatus = subDoc['subscription_status'];

      retailerUser = RetailerModel(
        uid: userId,
        email: userEmail,
        name: userName,
        cnic_number: cnicNumber,
        cnic_front_image_url: cnicFrontUrl,
        cnic_back_image_url: cnicBackUrl,
        subscription_status: subscriptionStatus,
      );
      Get.offAll(() => RetailerDashboard());
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
