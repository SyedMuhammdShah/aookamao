import 'dart:io';

import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/models/push_notification_model.dart';
import 'package:aookamao/modules/auth/controller/auth_controller.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/constants.dart';
import '../../../../enums/payment_type.dart';
import '../../../../models/subscription_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../widgets/custom_snackbar.dart';

class SubscriptionController extends GetxController{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final _authService = Get.find<AuthService>();
  final FirebasePushNotificationService _firebasePushNotificationService = FirebasePushNotificationService();
  Rx<SubscriptionModel> currentSubscription = Rx<SubscriptionModel>(SubscriptionModel(uid: '', subscriptionStatus: SubscriptionStatus.none));
  Rx<PaymentType?> paymentType = Rx<PaymentType?>(null);

  @override
  void onInit() {
    super.onInit();
    getSubscriptionDetails(uid: _authService.currentUser.value!.uid);
  }

  Future activateSubscription({required SubscriptionModel subscriptiondetails,String? retailer_name})async{
    //await Firebase.initializeApp();
    try {
      //Activate subscription
      await fireStore
          .collection('subscription')
          .doc(subscriptiondetails.uid)
          .set(subscriptiondetails.toMap());

      currentSubscription.value = subscriptiondetails;

      if(subscriptiondetails.subscriptionStatus == SubscriptionStatus.none){
        //fetch admin token
        var snapshot = await fireStore
            .collection('user_details')
            .where('role', isEqualTo: userRoleToString(UserRoles.admin))
            .get();
        var adminToken = snapshot.docs.first.get('device_token');
        print(adminToken);
        if(adminToken!=null) {
          //Send notification to admin
          var notificationdata = PushNotification(
              title: "New Retailer Registerd",
              body: "$retailer_name has registered as a retailer",
              token: adminToken,
              data: subscriptiondetails.toMap()
          ).toJsonWithData();
          await _firebasePushNotificationService.sendNotificationUsingApi(
              notificationdata: notificationdata);

        }
      }
      else if(subscriptiondetails.subscriptionStatus == SubscriptionStatus.pending){
        //fetch admin token
        var snapshot = await fireStore
            .collection('user_details')
            .where('role', isEqualTo: userRoleToString(UserRoles.admin))
            .get();
        var adminToken = snapshot.docs.first.get('device_token');
        print(adminToken);
        if(adminToken!=null) {
          //Send notification to admin
          var notificationdata = PushNotification(
              title: "New Subscription Request",
              body: "New subscription request from $retailer_name",
              token: adminToken,
              data: subscriptiondetails.toMap()
          ).toJsonWithData();
          await _firebasePushNotificationService.sendNotificationUsingApi(
              notificationdata: notificationdata);
        }
        showSuccessSnackbar("Your subscription is waiting for approval");
      }
      else if(subscriptiondetails.subscriptionStatus == SubscriptionStatus.active){
        var snapshot = await fireStore
            .collection('user_details')
            .doc(subscriptiondetails.uid)
            .get();
        var adminToken = snapshot.get('device_token');
        print(adminToken);
        if(adminToken!=null) {
          //Send notification to admin
          var notificationdata = PushNotification(
              title: "Subscription Approved",
              body: "Your subscription has been approved",
              token: adminToken,
          ).toJsonNoData();
          await _firebasePushNotificationService.sendNotificationUsingApi(
              notificationdata: notificationdata);
          print("Notification sent");
        }
      }
      return;
    }
    catch(e){
      print(e);
      return;
    }

  }

  Future<void> getSubscriptionDetails({required String uid})async{
    await Firebase.initializeApp();
    try {
      //Get subscription details
      var snapshot = await fireStore
          .collection('subscription')
          .doc(uid)
          .get();
      print(snapshot.data());
      currentSubscription.value = SubscriptionModel.fromMap(snapshot.data()!);
      return;
    }
    catch(e){
      print(e);
      return;
    }
  }
  Future<void> sendPaymentSS() async{
    try {
      if (Platform.isAndroid) {
        String url = 'whatsapp://send?phone="${Constants.whatsAppNumber}"&text=ScreenShot of ${paymentTypeToString(paymentType.value!)} payment receipt for order from ${Constants.appName} App';
        await launchUrl(Uri.parse(url),mode: LaunchMode.externalNonBrowserApplication).then((value) => Get.back());

      }
      else if (Platform.isIOS) {
        String url = 'https://wa.me/"${Constants.whatsAppNumber}"/?text=${Uri.parse('ScreenShot of ${paymentTypeToString(paymentType.value!)} payment receipt for order from ${Constants.appName} App')}';
        await launchUrl(Uri.parse(url),mode: LaunchMode.externalNonBrowserApplication).then((value) => Get.back());
      }

    }
    catch (e) {
      print(e);
    }
  }
  @override
  void dispose() {
    super.dispose();
    currentSubscription.close();
  }
}