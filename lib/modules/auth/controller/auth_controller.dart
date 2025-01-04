import 'dart:io';


import 'package:aookamao/admin/modules/dashboard/admin_dashboard.dart';
import 'package:aookamao/enums/user_bank_type.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/models/user_model.dart';
import 'package:aookamao/modules/auth/referral_view.dart';
import 'package:aookamao/user/modules/landingPage/landing_page.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/subscription_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_notification_service.dart';
import '../../../retailer/retailer_modules/dashboard/retailer_dashboard.dart';
import '../../../services/referral_service.dart';
import '../../../bindings/home_binding.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final _authService = Get.find<AuthService>();
  final _referralService = Get.find<ReferralService>();
  final GlobalKey<FormState> signup_formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> referral_formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> update_formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  //final TextEditingController cnicController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController accountHolderNameController = TextEditingController();


  Rx<File> cnicFrontFile = File('').obs;
  Rx<File> cnicBackFile = File('').obs;
  Rx<UserRoles> selectedRole = UserRoles.user.obs;
  RxBool isLoading = false.obs;
  RxBool isRemember = false.obs;
  UserBankType? selectedBankType;

  Future<void> registerRetailer() async {
    isLoading.value = true;
    var userdetail = UserModel(
        uid: '',
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        role: UserRoles.retailer,
        registered_at: Timestamp.now(),
        password: confirmPasswordController.text.trim(),
    );
    bool isreg = await _authService.registerUser( userdetails: userdetail);
    isLoading.value = false;
    if (isreg) {
      clearfields();
      Get.offAll(() => const RetailerDashboard());
    }
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    var userdetail = UserModel(
      uid: '',
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      role: UserRoles.user,
      address: addressController.text.trim(),
      registered_at: Timestamp.now(),
      password: confirmPasswordController.text.trim(),
    );
    bool isreg = await _authService.registerUser(userdetails: userdetail);
    isLoading.value = false;
    if (isreg) {
      clearfields();
      //Get.offAll(() => const LandingPage());
      Get.offAll(() => const ReferralView());
    }
  }

  void pickCnicImage(
      {required bool isFront, required ImageSource imagesource}) async {
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

  void clearfields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    //cnicController.clear();
    cnicFrontFile.value = File('');
    cnicBackFile.value = File('');
  }

  // Function to login user and store data
  Future<void> loginUser() async {
    isLoading.value = true;
    bool islogin = await _authService.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        isremember: isRemember.value);
    isLoading.value = false;
    if (islogin) {
      clearfields();

      if (_authService.currentUser.value?.role == UserRoles.retailer) {
        Get.offAll(() => const RetailerDashboard());
      }
      else if (_authService.currentUser.value?.role == UserRoles.user) {
        Get.offAll(() => const LandingPage());
      }
      else if (_authService.currentUser.value?.role == UserRoles.admin) {
        Get.offAll(() => AdminDashboard());
      }
      else {
        showErrorSnackbar("Something went wrong please try again!");
      }
    }
  }

  Future<void> addUserToReferral() async {
    isLoading.value = true;
    bool isvalidcode = await _referralService.validateReferralCode(
        code: referralController.text.trim());
    isLoading.value = false;
    if (isvalidcode) {
      showSuccessSnackbar(
          "Your Successfully Added To Aookamao Referral Program.");
      Get.offAll(() => const LandingPage());
    }
  }

  Future updateUserDetails() async {
    isLoading.value = true;
    var userdetail = UserModel(
      uid: _authService.currentUser.value!.uid,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      userBankType: selectedBankType,
      role: _authService.currentUser.value!.role,
      accountNumber: accountNumberController.text.trim(),
      accountHolderName: accountHolderNameController.text.trim()
    );
     await _authService.updateUserDetails(userdetails: userdetail);
    isLoading.value = false;
    Get.back();
    showSuccessSnackbar("Your Profile Updated Successfully");
  }

  void populateUserDetails() {
    nameController.text = _authService.currentUser.value?.name ?? '';
    emailController.text = _authService.currentUser.value?.email ?? '';
    addressController.text = _authService.currentUser.value?.address ?? '';
    selectedBankType = _authService.currentUser.value?.userBankType;
    accountNumberController.text = _authService.currentUser.value?.accountNumber ?? '';
    accountHolderNameController.text = _authService.currentUser.value?.accountHolderName ?? '';
  }
}
