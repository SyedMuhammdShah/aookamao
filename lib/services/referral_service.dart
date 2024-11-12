import 'dart:math';

import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../enums/referral_account_type.dart';
import '../enums/referral_types.dart';
import '../models/referral_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class ReferralService extends GetxService{
  final _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString referralCode = ''.obs;
  RxString referralUserId = ''.obs;
  Rx<UserModel?> referralUserDetail = Rx<UserModel?>(null);


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

  // validate the referral code
  Future<bool> validateReferralCode(String code) async {
    try {
      final querySnapshot = await _firestore.collection(
          Constants.referralsCollection)
          .where('referralCode', isEqualTo: code)
          .get();
      if(querySnapshot.docs.isNotEmpty) {
        referralUserId.value =
            querySnapshot.docs.first.get('referralId'); // get the retailer id
        print('Retailer ID: ${referralUserId.value}');
        fetchDetailsOfReferralUser();
        return true;
      }
    }
    catch (e) {
     showErrorSnackbar('Invalid referral code!');
     print('Error validating referral code: $e');
      return false;
    }
    return false;
  }

  //fetch of the referral user
  Future<void> fetchDetailsOfReferralUser() async {
    try {
      final querySnapshot = await _firestore.collection(Constants.usersCollection).doc(referralUserId.value).get();
      if(querySnapshot.exists) {
        print('Retailer details: ${querySnapshot.data()}');
        UserRoles role = stringToUserRole(querySnapshot.get('role'));
        if(role == UserRoles.retailer){
          referralUserDetail.value = UserModel.fromMapRetailer(querySnapshot.data() as Map<String, dynamic>);
          referralUserDetail.value = referralUserDetail.value!.copyWith(uid: referralUserId.value);
        }
        else if(role == UserRoles.user) {
          referralUserDetail.value = UserModel.fromMapUser(
              querySnapshot.data() as Map<String, dynamic>);
          referralUserDetail.value = referralUserDetail.value!.copyWith(uid: referralUserId.value);
        }
        if(referralUserDetail.value != null) {
          print('Referral user details: ${referralUserDetail.value!.name}');
          addReferee();
        }
      }
    } catch (e) {
      print('Error fetching retailer details: $e');
    }
  }

  //add the user to the referral list of referees
  Future<void> addReferee() async {
    try {
      var data;
      if(referralUserDetail.value!.role == UserRoles.retailer){
        data = ReferralModel(
            referralId: '',
            referralCode: '',
            referees: [
              Referee(
                refereeId: _authService.currentUser.value!.uid,
                referalType: ReferalTypes.DirectReferal,
                referralDate: Timestamp.now(),
              )
            ],
            accountType: ReferralAccountType.Retailer,
            retailerId: '',
            userReferredById: ''
        ).toMapRetailerDirectReferral();
      }
      else if(referralUserDetail.value!.role == UserRoles.user) {
        data = ReferralModel(
            referralId: '',
            referralCode: '',
            referees: [
              Referee(
                refereeId: _authService.currentUser.value!.uid,
                referalType: ReferalTypes.DirectReferal,
                referralDate: Timestamp.now(),
              )
            ],
            accountType: ReferralAccountType.USER,
            retailerId: referralUserId.value,
            userReferredById: ''
        ).toMapUserReferral();
      }

      await _firestore.collection(Constants.referralsCollection).doc(referralUserId.value).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error adding referee to retailer: $e');
      showErrorSnackbar('Error adding referee to retailer');
    }
  }

  //send notification to the refrerral user
  Future<void> sendNotificationToReferralUser() async {
    try {
      //send notification to the referral user

    } catch (e) {
      print('Error sending notification to referral user: $e');
    }
  }

  //get admin token
  Future<String> getAdminToken() async {
    try {
      var snapshot = await _firestore
          .collection(Constants.usersCollection)
          .where('role', isEqualTo: userRoleToString(UserRoles.admin))
          .get();
      if(snapshot.docs.isEmpty) {
        print('Admin token not found');
        return '';
      }
      return snapshot.docs.first.get('device_token');
    } catch (e) {
      print('Error getting admin token: $e');
      return '';
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