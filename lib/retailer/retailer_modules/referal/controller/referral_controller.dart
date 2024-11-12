import 'dart:math';

import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/models/referral_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../enums/referral_account_type.dart';
import '../../../../modules/auth/controller/auth_controller.dart';
import '../../../../services/auth_service.dart';

class ReferralController extends GetxController {
  final _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString referralCode = ''.obs;


  // Function to generate a random alphanumeric code
  String _generateRandomCode(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
  }

  // Function to check if the code already exists in the database
  Future<bool> _doesCodeExist(String code) async {
    final querySnapshot = await _firestore.collection(Constants.referralsCollection).where('referralCode', isEqualTo: code).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Main function to generate a unique code and check for uniqueness
  Future<String> generateUniqueReferralCode(int length) async {
    String referralCode;
    bool isUnique = false;

    do {
      referralCode = _generateRandomCode(length);
      isUnique = !(await _doesCodeExist(referralCode));
    } while (!isUnique);
    print('Referral code generated: $referralCode');
    return referralCode;
  }

  // Function to get the referral code of the current user
  Future<void> getReferralCode() async {
    final querySnapshot = await _firestore.collection(Constants.referralsCollection).doc(_authService.currentUser.value!.uid).get();
    if (querySnapshot.exists) {
      referralCode.value= querySnapshot.get('referralCode');
      return;
    } else {
      referralCode.value = await generateUniqueReferralCode(6);
      saveReferralCode(referralCode: referralCode.value);
      return;
    }
  }

  // Function to save the referral code to the database
  Future<void> saveReferralCode({required String referralCode}) async {
    try {
      var data =ReferralModel(
          referralId:_authService.currentUser.value!.uid,
          referralCode: referralCode,
          referees: [],
          accountType: ReferralAccountType.Retailer,
          retailerId: '',
          userReferredById: ''
      ).toMapSaveRetailerReferralCode();
      await _firestore.collection(Constants.referralsCollection).doc(_authService.currentUser.value!.uid).set(data);
    } catch (e) {
      print('Error saving referral code: $e');
    }
  }
}