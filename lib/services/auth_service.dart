import 'dart:io';

import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../enums/subscription_status.dart';
import '../models/push_notification_model.dart';
import '../models/subscription_model.dart';
import '../models/user_model.dart';
import '../widgets/custom_snackbar.dart';

class AuthService extends GetxService{
  RxBool isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebasePushNotificationService _firebasePushNotificationService = FirebasePushNotificationService();
  Rx<SubscriptionModel> currentSubscription = Rx<SubscriptionModel>(SubscriptionModel(uid: '', subscriptionStatus: SubscriptionStatus.none));


  Future<AuthService> init() async {
    await Firebase.initializeApp();
    return this;
  }



  Future<bool> registerUser(File? cnicFrontFile,File? cnicBackFile,{required UserModel userdetails}) async {
    isLoading.value = true;

    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userdetails.email,
        password: userdetails.password!,
      );

      if(userCredential.user == null){
        print('User not created!');
        return false;
      }
      userdetails = userdetails.copyWith(uid: userCredential.user!.uid);

      if(userdetails.role == UserRoles.retailer){
        await _uploadCnic(userdetails: userdetails,cnicFrontFile:cnicFrontFile!,cnicBackFile: cnicBackFile!);
        await _firestore
            .collection(Constants.usersCollection)
            .doc(userdetails.uid)
            .set(userdetails.toMapRegisterRetailer());
        var subscriptiondetails = SubscriptionModel(uid:userdetails.uid, subscriptionStatus: SubscriptionStatus.none);
        await activateSubscription(subscriptiondetails:subscriptiondetails);
        await FirebasePushNotificationService().getDeviceToken();
        currentUser.value = userdetails;
        showSuccessSnackbar('Your are registered as a retailer');
        return true;
      }
      else if(userdetails.role == UserRoles.user){
        await _firestore
            .collection(Constants.usersCollection)
            .doc(userdetails.uid)
            .set(userdetails.toMapRegisterUser());
        await FirebasePushNotificationService().getDeviceToken();
        currentUser.value = userdetails;
        showSuccessSnackbar('Your are registered as a user');
        return true;
      }
      return false;

    } catch (e) {
      showSuccessSnackbar('Error ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loginUser({required String email,required String password})async{
    isLoading.value = true;
    try {
      await Firebase.initializeApp();
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(userCredential.user == null){
        showErrorSnackbar('Your email or password is incorrect');
        return false;
      }
      String userId = userCredential.user!.uid;

      DocumentSnapshot userDoc = await _firestore.collection(Constants.usersCollection).doc(userId).get();

      if (userDoc.exists) {
         if(userDoc.get('role') == userRoleToString(UserRoles.retailer)){
           currentUser.value = UserModel.fromMapRetailer(userDoc.data() as Map<String, dynamic>);
           currentUser.value = currentUser.value!.copyWith(uid: userId);
            await getSubscriptionDetails(uid: userId);
            await _firebasePushNotificationService.getDeviceToken();
            showSuccessSnackbar('Login Successful');
            return true;
         }
         currentUser.value = UserModel.fromMapUser(userDoc.data() as Map<String, dynamic>);
         currentUser.value = currentUser.value!.copyWith(uid: userId);
         await _firebasePushNotificationService.getDeviceToken();
         showSuccessSnackbar('Login Successful');
         return true;

      } else {
        showErrorSnackbar('User not found');
        return false;
      }

    } catch (e) {
      showErrorSnackbar('Error ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel> _uploadCnic({required UserModel userdetails,required File cnicFrontFile,required File cnicBackFile})async{
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('cnic_images/${userdetails.uid}/cnicfrontimg.jpg');
      TaskSnapshot task = await storageRef.putFile(cnicFrontFile);
      var cnicFrontUrl = await task.ref.getDownloadURL();
      print("cnicFrontUrl: $cnicFrontUrl");
      Reference storageRef2 = FirebaseStorage.instance.ref().child(
          'cnic_images/${userdetails.uid}/cnicbackimg.jpg');
      TaskSnapshot task2 = await storageRef2.putFile(cnicBackFile);
      var cnicBackUrl = await task2.ref.getDownloadURL();
      print("cnicBackUrl: $cnicBackUrl");
      return userdetails=userdetails.copyWith(cnic_front_image_url: cnicFrontUrl,cnic_back_image_url: cnicBackUrl);
    }
    catch(e){
      showErrorSnackbar('Error ${e.toString()}');
      print("error in uploadCnic: $e");
      return userdetails;
    }
  }

  Future activateSubscription({required SubscriptionModel subscriptiondetails,String? retailer_name})async{
    //await Firebase.initializeApp();
    try {
      //Activate subscription
      await _firestore
          .collection(Constants.subscriptionsCollection)
          .doc(subscriptiondetails.uid)
          .set(subscriptiondetails.toMap());

      currentSubscription.value = subscriptiondetails;

      if(subscriptiondetails.subscriptionStatus == SubscriptionStatus.none){
        //fetch admin token

        var adminToken = await fetchToken(isAdminToken: true);
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
        var adminToken = await fetchToken(isAdminToken: true);
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

        var retailerToken = await fetchToken(uid: subscriptiondetails.uid,isAdminToken: false);
        print(retailerToken);
        if(retailerToken!=null) {
          //Send notification to admin
          var notificationdata = PushNotification(
            title: "Subscription Approved",
            body: "Your subscription has been approved",
            token: retailerToken,
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

  Future<String> fetchToken({String? uid,required bool isAdminToken})async{
    try {
      //Get device token
      if(isAdminToken){
        var snapshot = await _firestore
            .collection(Constants.usersCollection)
            .where('role', isEqualTo: userRoleToString(UserRoles.admin))
            .get();
        return snapshot.docs.first.get('device_token');
      }
      else{
        var snapshot = await _firestore
            .collection(Constants.usersCollection)
            .doc(uid)
            .get();
        return snapshot.get('device_token');
      }
    }
    catch(e){
      print(e);
      return '';
    }
  }

  Future<void> getSubscriptionDetails({required String uid})async{
    await Firebase.initializeApp();
    try {
      //Get subscription details
      var snapshot = await _firestore
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