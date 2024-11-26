import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/order_status.dart';
import 'package:aookamao/enums/referral_account_type.dart';
import 'package:aookamao/models/order_model.dart';
import 'package:aookamao/models/reward_model.dart';
import 'package:aookamao/models/wallet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../enums/referred_by.dart';
import '../enums/reward_status.dart';
import '../enums/rewarded_to.dart';
import '../models/push_notification_model.dart';
import '../models/referral_model.dart';
import 'auth_service.dart';
import 'firebase_notification_service.dart';

class OrderService extends GetxService {
  final _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _firebasePushNotificationService =
      Get.find<FirebasePushNotificationService>();

  Future<OrderService> init() async {
    return this;
  }

  //function to place order
  Future<void> placeOrder(
      {required OrderModel orderData,
      required ReferralModel referralDetails}) async {
  try{
      //get the current user id
      final userId = _authService.currentUser.value!.uid;
      //save the order data to the database
      DocumentReference orderdoc = await _firestore
          .collection(Constants.ordersCollection)
          .add(orderData.toMap());

      //reward the Customer if the order is eligible for reward
      print('referralDetails.referredBy: ${referralDetails.referredBy}');
      print('referralDetails.retailerId: ${referralDetails.retailerId}');
      print('referralDetails.userReferredById: ${referralDetails.userReferredById}');
      print('orderdoc.id: ${orderdoc.id}');
      print('referralDetails.referredBy: ${referralDetails.referralId}');


      if (referralDetails.referredBy == ReferredBy.Retailer) {
        print('rewarding customer and retailer');
        Future.wait([
          rewardToCustomer(orderId: orderdoc.id),
          rewardToRetailer(
            orderId: orderdoc.id,
            retailerId: referralDetails.retailerId!,
          ),
          notifyAdmin()
        ]);
        return;
      } else {
        print('rewarding referral user and retailer');
        Future.wait([
          rewardToRetailer(
              orderId: orderdoc.id, retailerId: referralDetails.retailerId!),
          rewardTOReferralUser(
              orderId: orderdoc.id,
              referralUserId: referralDetails.userReferredById!),
          notifyAdmin()
        ]);
        return;
      }
    } catch (e) {
      print(e);
      return;
    }

  }

  //function to reward the user for placing an order
  Future<void> rewardToCustomer({
    required String orderId,
  }) async {
    try {
      //get the current user id
      final userId = _authService.currentUser.value!.uid;
      var rewardData = RewardModel(
        rewardUserId: userId,
        orderId: orderId,
        rewardAmount: Constants.customerRewardAmount,
        rewardDate: Timestamp.now(),
        rewardStatus: RewardStatus.pending,
        rewardUserName: _authService.currentUser.value!.name,
        rewardedTo: RewardedTo.Customer,
      ).toMap();
      //get the user data from the database
      await _firestore.collection(Constants.rewardCollection).add(rewardData);
      print('Customer rewarded');
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  //function to reward the retailer for referring the user
  Future<void> rewardToRetailer(
      {required String orderId, required String retailerId}) async {
    try{
      var retailerUserData = await _firestore
          .collection(Constants.usersCollection)
          .doc(retailerId)
          .get();
      String? retailerName = retailerUserData.get('user_name') ?? '';
      var rewardData = RewardModel(
        rewardUserId: retailerId,
        orderId: orderId,
        rewardAmount: Constants.retailerRewardAmount,
        rewardDate: Timestamp.now(),
        rewardStatus: RewardStatus.pending,
        rewardUserName: retailerName,
        rewardedTo: RewardedTo.RETAILER,
      ).toMap();
      //get the user data from the database
      await _firestore.collection(Constants.rewardCollection).add(rewardData);
      print('Retailer rewarded');
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  //function to reward the referral user for referring the user
  Future<void> rewardTOReferralUser(
      {required String orderId, required String referralUserId}) async {
try{
      var referralUserData = await _firestore
          .collection(Constants.usersCollection)
          .doc(referralUserId)
          .get();
      String? userName = referralUserData.get('user_name') ?? '';
      //get the current user id
      final userId = _authService.currentUser.value!.uid;
      var rewardData = RewardModel(
        rewardUserId: referralUserId,
        orderId: orderId,
        rewardAmount: Constants.referralUserRewardAmount,
        rewardDate: Timestamp.now(),
        rewardStatus: RewardStatus.pending,
        rewardUserName: userName,
        rewardedTo: RewardedTo.REFFERAL_USER,
      ).toMap();
      //get the user data from the database
      await _firestore.collection(Constants.rewardCollection).add(rewardData);
      print('Referral User rewarded');
      return;
    } catch (e) {
      print(e);
      return;
    }

  }

  //function to notify the admin about the order
  Future<void> notifyAdmin() async {
    try {
      String adminToken = await _authService.fetchToken(isAdminToken: true);
      if (adminToken != '') {
        var notificationData = PushNotification(
          title: 'New Order Placed',
          body:
              'A new order has been placed by a ${_authService.currentUser.value!.name}.',
          token: adminToken,
        ).toJsonNoData();
        //send the notification to the admin
        await _firebasePushNotificationService.sendNotificationUsingApi(
            notificationdata: notificationData);
        print('Admin notified');
        return;
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  Stream<RxList<Rx<OrderModel>>> getCustomerOrders() {
    final customerId = _authService.currentUser.value!.uid;
    return _firestore
        .collection(Constants.ordersCollection)
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data()).obs)
            .toList()
            .obs);
  }

  Stream<RxList<Rx<OrderModel>>> getAllOrders() {
    return _firestore.collection(Constants.ordersCollection).orderBy('orderStatus',descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromDoc(doc).obs)
            .toList()
            .obs);
  }

  Stream<RxList<Rx<RewardModel>>> getAllRewards() {
    return _firestore.collection(Constants.rewardCollection).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => RewardModel.fromDoc(doc).obs)
            .toList()
            .obs);
  }

  Future<void> updateOrderStatus(
      {required String orderId, required OrderStatus orderstatus,required String customer_id}) async {
    try {
      await _firestore
          .collection(Constants.ordersCollection)
          .doc(orderId)
          .update({'orderStatus': orderStatusToString(orderstatus)});
      await notifyCustomer(orderId: orderId, orderStatus: orderstatus, customer_id: customer_id);
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> notifyCustomer(
      {required String orderId, required OrderStatus orderStatus,required String customer_id}) async {
    try {
      String customerToken = await _authService.fetchToken(isAdminToken: false, uid: customer_id);
      if (customerToken != '') {
        if (orderStatus == OrderStatus.delivered) {
          var notificationData = PushNotification(
            title: 'Order Delivered',
            body: 'Your order with order id $orderId has been delivered.',
            token: customerToken,
          ).toJsonNoData();
          //send the notification to the customer
          await _firebasePushNotificationService.sendNotificationUsingApi(
              notificationdata: notificationData);
          print('Customer notified');
          return;
        } else if (orderStatus == OrderStatus.cancelled) {
          var notificationData = PushNotification(
            title: 'Order Cancelled',
            body: 'Your order with order id $orderId has been cancelled.',
            token: customerToken,
          ).toJsonNoData();
          //send the notification to the customer
          await _firebasePushNotificationService.sendNotificationUsingApi(
              notificationdata: notificationData);
          print('Customer notified');
          return;
        } else if (orderStatus == OrderStatus.confirmed) {
          var notificationData = PushNotification(
            title: 'Order Processed',
            body: 'Your order with order id $orderId has been processed.',
            token: customerToken,
          ).toJsonNoData();
          //send the notification to the customer
          await _firebasePushNotificationService.sendNotificationUsingApi(
              notificationdata: notificationData);
          print('Customer notified');
          return;
        }
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> updateRewardStatus(
      {required String rewardId,
      required RewardStatus status,
      required String rewardUserId,
      required RewardedTo rewardedTo}) async {
    try {
      await _firestore
          .collection(Constants.rewardCollection)
          .doc(rewardId)
          .update({'rewardStatus': rewardStatusToString(status)});
      if (status == RewardStatus.approved) {
        Future.wait([
          addRewardToWallet(rewardUserId: rewardUserId, rewardedTo: rewardedTo),
          notifyRewardUser(rewardUserId: rewardUserId, rewardStatus: status)
        ]);
      }
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> notifyRewardUser(
      {required String rewardUserId,
      required RewardStatus rewardStatus}) async {
    try {
      String rewardUserToken =
          await _authService.fetchToken(isAdminToken: false, uid: rewardUserId);
      if (rewardUserToken != '') {
        if (rewardStatus == RewardStatus.approved) {
          var notificationData = PushNotification(
            title: 'Reward Approved',
            body: 'Your reward has been approved.',
            token: rewardUserToken,
          ).toJsonNoData();
          //send the notification to the customer
          await _firebasePushNotificationService.sendNotificationUsingApi(
              notificationdata: notificationData);
          print('Reward User notified');
          return;
        }
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  //function add reward to wallet
  Future<void> addRewardToWallet(
      {required String rewardUserId, required RewardedTo rewardedTo}) async {
    try {
      if (rewardedTo == RewardedTo.Customer) {
        var walletData = WalletModel(
          walletId: rewardUserId,
          balance: Constants.customerRewardAmount,
        ).toMapIncrementBalance();
        _firestore
            .collection(Constants.walletCollection)
            .doc(rewardUserId)
            .set(walletData, SetOptions(merge: true));
        return;
      } else if (rewardedTo == RewardedTo.RETAILER) {
        var walletData = WalletModel(
          walletId: rewardUserId,
          balance: Constants.retailerRewardAmount,
        ).toMapIncrementBalance();
        _firestore
            .collection(Constants.walletCollection)
            .doc(rewardUserId)
            .set(walletData, SetOptions(merge: true));
        return;
      } else if (rewardedTo == RewardedTo.REFFERAL_USER) {
        var walletData = WalletModel(
          walletId: rewardUserId,
          balance: Constants.referralUserRewardAmount,
        ).toMapIncrementBalance();
        _firestore
            .collection(Constants.walletCollection)
            .doc(rewardUserId)
            .set(walletData, SetOptions(merge: true));
        return;
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  //function to get the total earnings of the user
  Stream<WalletModel> getWalletData() {
    final userId = _authService.currentUser.value!.uid;
    return _firestore
        .collection(Constants.walletCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => WalletModel.fromMap(doc.data()??{} ));
  }

  //function to get rewards of the user
  Stream<RxList<Rx<RewardModel>>> getRewards() {
    final userId = _authService.currentUser.value!.uid;
    return _firestore
        .collection(Constants.rewardCollection)
        .where('rewardUserId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RewardModel.fromDoc(doc).obs)
            .toList()
            .obs);
  }
}
