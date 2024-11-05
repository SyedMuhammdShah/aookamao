import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/retailer/models/subscription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_snackbar.dart';

class SubscriptionController extends GetxController{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
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