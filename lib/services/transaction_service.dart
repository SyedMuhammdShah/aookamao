import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/transaction_status.dart';
import 'package:aookamao/enums/transaction_types.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/push_notification_model.dart';
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';
import 'auth_service.dart';

class TransactionService extends GetxService {
  final _authService = Get.find<AuthService>();
  final _pushNotificationService = Get.find<FirebasePushNotificationService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection(Constants.transactionsCollection);

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _transactions.add(transaction.toMap());
      await updateWalletBalance(transaction);
      await notifyAdmin(transaction);
    } catch (e) {
      print(e);
    }
  }

  Stream<List<TransactionModel>> getTransactions() {
    try {
      return _transactions.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList());
    } catch (e) {
      print(e);
      return Stream.empty();
    }
  }

  Stream<List<TransactionModel>> getTransactionsByWallet({required String walletId}) {
    try {
      return _transactions.where('walletId',isEqualTo: walletId).snapshots().map((snapshot) => snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList());
    } catch (e) {
      print(e);
      return Stream.empty();
    }
  }



  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      print('Transactionid ${transaction.transactionId}');
      print(transaction.toMapUpdate());
      await _transactions
          .doc(transaction.transactionId)
          .update(transaction.toMapUpdate());
      await updateWalletBalance(transaction);
      await notifyUser(transaction);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateWalletBalance(TransactionModel transaction) async {
    try {
      if(await verifyWalletBalance(walletId:transaction.walletId!, transactionAmount:transaction.transactionAmount!)) {
        if (transaction.transactionType == TransactionType.Withdrawal) {
          if(transaction.transactionStatus == TransactionStatus.pending) {
            await _firestore.collection(Constants.walletCollection).doc(
                transaction.walletId)
                .update(WalletModel(walletId: transaction.walletId!,
                balance: transaction.transactionAmount!)
                .toMapDecrementBalance());
          }
          else if(transaction.transactionStatus == TransactionStatus.rejected){
            await _firestore.collection(Constants.walletCollection).doc(
                transaction.walletId)
                .update(WalletModel(walletId: transaction.walletId!,
                balance: transaction.transactionAmount!)
                .toMapIncrementBalance());
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> verifyWalletBalance({required String walletId,required double transactionAmount}) async {
    try {
      WalletModel userwallet = await _firestore.collection(Constants.walletCollection).doc(walletId).get().then((doc) => WalletModel.fromMap(doc.data()??{}));
      return userwallet.balance >= transactionAmount;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> notifyAdmin(TransactionModel transaction) async {
    // Send a notification to the admin
    try {
      var adminToken = await _authService.fetchToken(isAdminToken: true);
      if (adminToken != '') {
        var notificationdata = PushNotification(
          title: "New Transaction Request",
          body:
              "A new transaction request of ${transaction.transactionAmount} has been made by ${transaction.userName} for ${transactionTypesToString(transaction.transactionType!)}.",
          token: adminToken,
        ).toJsonNoData();
        await _pushNotificationService.sendNotificationUsingApi(
            notificationdata: notificationdata);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> notifyUser(TransactionModel transaction) async {
    // Send a notification to the user
    try {
      var userToken = await _authService.fetchToken(
          isAdminToken: false, uid: transaction.walletId);
      if (userToken != '') {
        var notificationdata = PushNotification(
          title: "Transaction Status",
          body:
              "Your transaction request of ${transaction.transactionAmount} for ${transactionTypesToString(transaction.transactionType!)} has been ${transactionStatusToString(transaction.transactionStatus)}.",
          token: userToken,
        ).toJsonNoData();
        await _pushNotificationService.sendNotificationUsingApi(
            notificationdata: notificationdata);
      }
    } catch (e) {
      print(e);
    }
  }
}
