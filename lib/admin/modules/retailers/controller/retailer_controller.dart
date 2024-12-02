import 'package:aookamao/admin/models/retailer_model.dart';
import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/enums/user_bank_type.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../models/subscription_model.dart';
import '../../../../retailer/retailer_modules/subscription/subscription_controller/subscription_controller.dart';
import '../../../../services/auth_service.dart';

class RetailerController extends GetxController {
  final _subscriptionController = Get.find<SubscriptionController>();
  final _authService = Get.find<AuthService>();
  var retailerList = <RetailerModel>[].obs;
  var isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    getAllRetailers();
  }

  Future<void> getAllRetailers() async {
    //fetch all retailers with their subscription details
    try{
    isLoading(true);
    var snapshot = await FirebaseFirestore.instance.collection(Constants.usersCollection)
        .where('role', isEqualTo: 'retailer')
        .get();
    var subscriptionSnapshot = await FirebaseFirestore.instance.collection(Constants.subscriptionsCollection).get();
    print('Retailer List: ${snapshot.docs.length}');
    print('subscriptionSnapshot List: ${subscriptionSnapshot.docs.length}');
    retailerList.clear();
    for (var user in snapshot.docs) {
      var subscription = subscriptionSnapshot.docs.firstWhere((
          element) => element.id == user.id);
      print('user: ${user.id}');
      retailerList.add(RetailerModel(
        uid: user.id,
        name: user.get('user_name'),
        email: user.get('user_email'),
        registered_at: user.get('registered_at'),
        accountNumber: user.data()['accountNumber'],
        accountHolderName: user.data()['accountHolderName'],
        userBankType: stringToUserBankType(user.data()['userBankType']??''),
        subscription_status: stringToSubscriptionStatus(subscription.get('subscription_status')),
        subscription_date: subscription.get('subscription_date')??Timestamp(0,0),
      ));
    }
    }catch(e){
      showErrorSnackbar('Error fetching retailers');
    }finally{
      isLoading(false);
    }


  }

  Future<void> approveRetailer({required SubscriptionModel subdetail}) async {
   await _subscriptionController.activateSubscription(subscriptiondetails: subdetail);
      showSuccessSnackbar('Supplier subscription has been approved successfully');
  }

  @override
  void dispose() {
    super.dispose();
    retailerList.close();
    isLoading.close();
  }
}