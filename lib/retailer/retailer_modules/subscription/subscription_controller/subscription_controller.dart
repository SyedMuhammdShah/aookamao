import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/models/push_notification_model.dart';
import 'package:aookamao/retailer/models/subscription_model.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_snackbar.dart';

class SubscriptionController extends GetxController{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebasePushNotificationService _firebasePushNotificationService = FirebasePushNotificationService();
  Rx<SubscriptionModel> currentSubscription = Rx<SubscriptionModel>(SubscriptionModel(uid: '', subscriptionStatus: SubscriptionStatus.none));

  Future activateSubscription({required SubscriptionModel subscriptiondetails})async{
    //await Firebase.initializeApp();
    try {
      //Activate subscription
      await fireStore
          .collection('subscription')
          .doc(subscriptiondetails.uid)
          .set(subscriptiondetails.toMap());

      currentSubscription.value = subscriptiondetails;
      //Send notification to admin
      var notificationdata = PushNotification(
          title: "New Subscription",
          body: "New subscription request from ${subscriptiondetails.uid}",
        token: "e2WfmI_9RS6kVOb26S_TlF:APA91bG5Hvi8jBrJQ9ytq3W6QaLwCiaqM7FBRBD47Wt0dIzLzJCRzg5P3G_BlVtnDQE1vrJpEsLRc-kfHUdbzMAy4UswUnd9jfQbcudXNP59SBQi5-Z2jeY",
      data: subscriptiondetails.toMap()
      ).toJsonWithData();
      await _firebasePushNotificationService.sendNotificationUsingApi(notificationdata: notificationdata);

      showSuccessSnackbar("Your subscription is waiting for approval");

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

}