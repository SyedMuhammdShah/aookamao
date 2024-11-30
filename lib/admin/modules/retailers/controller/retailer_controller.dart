import 'package:aookamao/admin/models/retailer_model.dart';
import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../models/subscription_model.dart';
import '../../../../retailer/retailer_modules/subscription/subscription_controller/subscription_controller.dart';

class RetailerController extends GetxController {
  final _subscriptionController = Get.find<SubscriptionController>();
  var retailerList = <RetailerModel>[].obs;
  var isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    getAllRetailers();
  }

  Future<void> getAllRetailers() async {
    //fetch all retailers with their subscription details
    isLoading(true);
    try{
    var snapshot = await FirebaseFirestore.instance.collection('user_details')
        .where('role', isEqualTo: 'retailer')
        .get();
    var subscriptionSnapshot = await FirebaseFirestore.instance.collection(
        'subscription').get();
    print('Retailer List: ${snapshot.docs.length}');
    print('subscriptionSnapshot List: ${subscriptionSnapshot.docs.length}');
    retailerList.clear();
    for (var user in snapshot.docs) {
      var subscription = subscriptionSnapshot.docs.firstWhere((
          element) => element.id == user.id);
      retailerList.add(RetailerModel(
        uid: user.id,
        name: user.get('user_name'),
        email: user.get('user_email'),
        registered_at: user.get('registered_at'),
        subscription_status: stringToSubscriptionStatus(
            subscription.get('subscription_status')),
        cnic_back_image_url: user.get('cnic_back_image_url'),
        cnic_front_image_url: user.get('cnic_front_image_url'),
        cnic_number: user.get('cnic_number'),
        subscription_date: subscription.get('subscription_date')??Timestamp(0,0),
      ));
    }
    }catch(e){
      print('Error: $e');
    }
    finally{
      isLoading(false);
    }
    print('Retailer List: ${retailerList.length}');
    print('Retailer List: ${retailerList[0].name}');

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