import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../constants/constants.dart';
import '../../../../enums/referral_account_type.dart';
import '../../../../enums/user_roles.dart';
import '../../../../models/referral_model.dart';
import '../../../../services/referral_service.dart';

class AdminDashboardController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _referralService = Get.find<ReferralService>();
  RxInt usersCount = 0.obs;
  RxInt retailerCount = 0.obs;
  RxInt ordersCount = 0.obs;
  RxList<Referee> get allReferessList =>_referralService.allReferessList;



  getUsersCount() {
    _firestore.collection(Constants.usersCollection).where('role',isEqualTo: userRoleToString(UserRoles.user)).snapshots()
        .listen((event) {
      usersCount.value = event.docs.length;
      print('Users count: ${event.docs.length}');
    });

  }

  // Method to get total suppliers count
   getRetailersCount() {
    _firestore.collection(Constants.usersCollection).where('role',isEqualTo: userRoleToString(UserRoles.retailer)).snapshots()
        .listen((event) {
      retailerCount.value = event.docs.length;
      print('Retailers count: ${event.docs.length}');
    });
   }

  // Method to get total orders count
   getOrdersCount() {
    _firestore.collection('orders').snapshots().listen((event) {
      ordersCount.value = event.docs.length;
    });
  }


  getAllReferess() {
    _referralService.getAllRetailersReferees();
  }

}