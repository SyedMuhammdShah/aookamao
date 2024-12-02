import 'dart:math';

import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/models/wallet_model.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../enums/referral_account_type.dart';
import '../enums/referral_types.dart';
import '../enums/referred_by.dart';
import '../models/push_notification_model.dart';
import '../models/referral_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'firebase_notification_service.dart';

class ReferralService extends GetxService {
  final _authService = Get.find<AuthService>();
  final _pushNotificationService = Get.find<FirebasePushNotificationService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rx<ReferralModel> currentReferralDetails = Rx<ReferralModel>(ReferralModel());
  Rx<String> referralCode = Rx<String>('');
  Rx<UserModel?> referralUserDetail = Rx<UserModel?>(null);
  RxList<Referee> allReferessList = <Referee>[].obs;

  Future<ReferralService> init() async {
    return this;
  }

  String _generateRandomCode(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }

  // Function to check if the code already exists in the database
  Future<bool> _doesCodeExist(String code) async {
    final querySnapshot = await _firestore
        .collection(Constants.referralsCollection)
        .where('referralCode', isEqualTo: code)
        .get();
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
    final querySnapshot = await _firestore
        .collection(Constants.referralsCollection)
        .doc(_authService.currentUser.value!.uid)
        .get();
    if (querySnapshot.exists) {
      referralCode.value = querySnapshot.get('referralCode');
      return;
    } else {
      referralCode.value = await generateUniqueReferralCode(6);
      saveReferralCode(referralCode: referralCode.value);
      return;
    }
  }

  // validate the referral code
  Future<bool> validateReferralCode({required String code}) async {
    final querySnapshot = await _firestore
        .collection(Constants.referralsCollection)
        .where('referralCode', isEqualTo: code)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      currentReferralDetails.value = ReferralModel.fromMapAllReferrals(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      print('referralId ID: ${currentReferralDetails.value.referralId}');
      await fetchDetailsOfReferralUser();
      await saveReferralCodeToNewUser();
      await createWallet();
      return true;
    }
    if (querySnapshot.docs.isEmpty) {
      showErrorSnackbar('Invalid referral code!');
      return false;
    }
    return false;
  }

  //fetch of the referral user
  Future<void> fetchDetailsOfReferralUser() async {
    try {
      final querySnapshot = await _firestore
          .collection(Constants.usersCollection)
          .doc(currentReferralDetails.value.referralId)
          .get();
      if (querySnapshot.exists) {
        print('Retailer details: ${querySnapshot.data()}');
        if (currentReferralDetails.value.accountType ==
            ReferralAccountType.RETAILER) {
          referralUserDetail.value = UserModel.fromFirestore(querySnapshot);
          referralUserDetail.value = referralUserDetail.value!
              .copyWith(uid: currentReferralDetails.value.referralId);
        } else if (currentReferralDetails.value.accountType ==
            ReferralAccountType.USER) {
          referralUserDetail.value = UserModel.fromFirestore(querySnapshot);
          referralUserDetail.value = referralUserDetail.value!
              .copyWith(uid: currentReferralDetails.value.referralId);
        }
        if (referralUserDetail.value != null) {
          print('Referral user details: ${referralUserDetail.value!.name}');
          addReferee();
        }
      }
    } catch (e) {
      print('Error fetching retailer details: $e');
    }
  }

  //save the referral code to the user
  Future<void> saveReferralCodeToNewUser() async {
    try {
      referralCode.value = await generateUniqueReferralCode(6);
      var data;
      if (currentReferralDetails.value.accountType ==
          ReferralAccountType.RETAILER) {
        data = ReferralModel(
          referralId: _authService.currentUser.value!.uid,
          referralCode: referralCode.value,
          accountType: ReferralAccountType.USER,
          retailerId: currentReferralDetails.value.referralId,
          referredBy: ReferredBy.Retailer,
        ).toMapSaveUserReferralCodeByRetailer();
      } else if (currentReferralDetails.value.accountType ==
          ReferralAccountType.USER) {
        data = ReferralModel(
          referralId: _authService.currentUser.value!.uid,
          referralCode: referralCode.value,
          accountType: ReferralAccountType.USER,
          userReferredById: currentReferralDetails.value.referralId,
          referredBy: ReferredBy.User,
          retailerId: currentReferralDetails.value.retailerId,
        ).toMapSaveUserReferralCodeByUser();
      }
      await _firestore
          .collection(Constants.referralsCollection)
          .doc(_authService.currentUser.value!.uid)
          .set(data);
      return;
    } catch (e) {
      print('Error saving referral code to user: $e');
    }
  }

  //add the user to the referral list of referees
  Future<void> addReferee() async {
    try {
      if (currentReferralDetails.value.accountType ==
          ReferralAccountType.RETAILER) {
        /* var data = ReferralModel(
          referees: [
            Referee(
              refereeId: _authService.currentUser.value!.uid,
              referalType: ReferalTypes.DirectReferal,
              referralDate: Timestamp.now(),
              refereeName: _authService.currentUser.value!.name,
            )
          ],
        ).toMapAddRefereeDirectReferral();*/

        var data = {
          'referees': FieldValue.arrayUnion([
            Referee(
              refereeId: _authService.currentUser.value!.uid,
              referalType: ReferalTypes.DirectReferal,
              referralDate: Timestamp.now(),
              refereeName: _authService.currentUser.value!.name,
            ).toMap()
          ])
        };

        await _firestore
            .collection(Constants.referralsCollection)
            .doc(currentReferralDetails.value.referralId)
            .set(data, SetOptions(merge: true));
      } else if (currentReferralDetails.value.accountType ==
          ReferralAccountType.USER) {
        /*var data = ReferralModel(
          referees: [
            Referee(
              refereeId: _authService.currentUser.value!.uid,
              referalType: ReferalTypes.DirectReferal,
              referralDate: Timestamp.now(),
              refereeName: _authService.currentUser.value!.name,
            )
          ],
        ).toMapAddRefereeDirectReferral();*/

        var data = {
          'referees': FieldValue.arrayUnion([
            Referee(
              refereeId: _authService.currentUser.value!.uid,
              referalType: ReferalTypes.DirectReferal,
              referralDate: Timestamp.now(),
              refereeName: _authService.currentUser.value!.name,
            ).toMap()
          ])
        };
        //add the user to the list of referees of the referral user
        await _firestore
            .collection(Constants.referralsCollection)
            .doc(referralUserDetail.value!.uid)
            .set(data, SetOptions(merge: true));

        //add the referral user to the list of referees of retailer
        /* var retailerReferralData = ReferralModel(
          referees: [
            Referee(
              refereeId: _authService.currentUser.value!.uid,
              referalType: ReferalTypes.IndirectReferal,
              referralDate: Timestamp.now(),
              referedById: referralUserDetail.value!.uid,
              refereeName: _authService.currentUser.value!.name,
              referedByName: referralUserDetail.value!.name,
            )
          ],
        ).toMapAddRefereeInDirectReferral();*/

        var retailerReferralData = {
          'referees': FieldValue.arrayUnion([
            Referee(
              refereeId: _authService.currentUser.value!.uid,
              referalType: ReferalTypes.IndirectReferal,
              referralDate: Timestamp.now(),
              referedById: referralUserDetail.value!.uid,
              refereeName: _authService.currentUser.value!.name,
              referedByName: referralUserDetail.value!.name,
            ).toMapIndirectReferral()
          ])
        };
        await _firestore
            .collection(Constants.referralsCollection)
            .doc(currentReferralDetails.value.retailerId)
            .set(retailerReferralData, SetOptions(merge: true));
      }

      await sendNotificationToReferralUser();
    } catch (e) {
      print('Error adding referee to retailer: $e');
      showErrorSnackbar('Error adding referee to retailer');
    }
  }

  //send notification to the refrerral user
  Future<void> sendNotificationToReferralUser() async {
    try {
      //send notification to the referral user
      if (referralUserDetail.value!.device_token != '') {
        var notificationdata = PushNotification(
          title: "Your Referral Code Used",
          body:
              "${_authService.currentUser.value!.name} has used your referral code to register.",
          token: referralUserDetail.value!.device_token!,
        ).toJsonNoData();
        await _pushNotificationService.sendNotificationUsingApi(
            notificationdata: notificationdata);
      }
      print('notification sent to referral user');
      //send notification to the admin
      var adminToken = await _authService.fetchToken(isAdminToken: true);
      if (adminToken != '') {
        var notificationdata = PushNotification(
          title: "New User Registered",
          body:
              "${_authService.currentUser.value!.name} has registered using a referral code from ${referralUserDetail.value!.name}",
          token: adminToken,
        ).toJsonNoData();
        await _pushNotificationService.sendNotificationUsingApi(
            notificationdata: notificationdata);
      }

      print('all notifications sent');
      return;
    } catch (e) {
      print('Error sending notification to referral user: $e');
    }
  }

  // Function to save the referral code to the database
  Future<void> saveReferralCode({required String referralCode}) async {
    try {
      var data = ReferralModel(
              referralId: _authService.currentUser.value!.uid,
              referralCode: referralCode,
              referees: [],
              accountType: ReferralAccountType.RETAILER,
              retailerId: '',
              userReferredById: '')
          .toMapSaveRetailerReferralCode();

      await _firestore
          .collection(Constants.referralsCollection)
          .doc(_authService.currentUser.value!.uid)
          .set(data);
    } catch (e) {
      print('Error saving referral code: $e');
    }
  }

  //Function to create user wallet
  Future<void> createWallet() async {
    try {
      var data = WalletModel(
              walletId: _authService.currentUser.value!.uid, balance: 0.00)
          .toMap();
      await _firestore
          .collection(Constants.walletCollection)
          .doc(_authService.currentUser.value!.uid)
          .set(data);
      return;
    } catch (e) {
      print('Error creating user wallet: $e');
      return;
    }
  }

  /*getRetailerReferees()  {
    try {
      final querySnapshot = _firestore.collection(Constants.referralsCollection).doc(_authService.currentUser.value!.uid);
      querySnapshot.snapshots().listen(
              (event) {
            if(event.exists) {
              var data = event.data() as Map<String, dynamic>;
              if(data['referees'] != null) {
                print('Referees: ${data['referees']}');
                refereesList.value = List<Referee>.from(data['referees'].map((referee) => Referee.fromMap(referee)));

                //filterRefereesByMonth;
                final DateTime now = DateTime.now();
                final List<Referee> thisMonthReferees = refereesList.where((referee) {
                  final DateTime refereeDate = referee.referralDate.toDate();
                  return refereeDate.month == now.month && refereeDate.year == now.year;
                }).toList();
                thisMonthRefereesList.assignAll(thisMonthReferees);
              }
            }
          }
      );
    } catch (e) {
      print('Error getting retailer referees: $e');
    }
  }*/

  Stream<RxList<Referee>> getRetailerReferees() {
    return _firestore
        .collection(Constants.referralsCollection)
        .doc(_authService.currentUser.value!.uid)
        .snapshots()
        .map(
          (event) => List<Referee>.from(event
              .data()!['referees']
              .map((referee) => Referee.fromMap(referee))
              .map((e) => e)).toList().obs,
        );
  }

  Future<void> getAllRetailersReferees() async {
    try {
      final querySnapshot = _firestore
          .collection(Constants.referralsCollection)
          .where(
            'accountType',
            isEqualTo:
                referralAccountTypeToString(ReferralAccountType.RETAILER),
          )
          .snapshots();

      querySnapshot.listen((event) {
        if (event.docs.isNotEmpty) {
          List<dynamic> data = event.docs
              .map((e) =>
                  e.data().containsKey('referees') ? e.get('referees') : [])
              .toList();
          allReferessList.value = data
              .expand((element) => element)
              .map((e) => Referee.fromMap(e))
              .toList();
          print('All referrals: ${allReferessList.length}');
        }
      });
    } catch (e) {
      print('Error getting all referrals: $e');
    }
  }

  // Functions get customer referrral details
  Future<bool> getCustomerReferralDetails() async {
    try {
      final querySnapshot = await _firestore
          .collection(Constants.referralsCollection)
          .doc(_authService.currentUser.value!.uid)
          .get();
      if (querySnapshot.exists) {
        return true;
      } else {
        print('No referral details found');
        return false;
      }
    } catch (e) {
      print('Error getting customer referral details: $e');
      return false;
    }
  }

  Stream<ReferralModel> getReferralDetails() {
    return _firestore
        .collection(Constants.referralsCollection)
        .doc(_authService.currentUser.value!.uid)
        .snapshots()
        .map(
          (event) =>
              ReferralModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }
}
