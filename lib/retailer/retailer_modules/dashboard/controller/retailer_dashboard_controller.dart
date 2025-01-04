import 'dart:io';

import 'package:aookamao/models/transaction_model.dart';
import 'package:aookamao/models/wallet_model.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/constants.dart';
import '../../../../enums/payment_type.dart';
import '../../../../enums/subscription_status.dart';
import '../../../../enums/transaction_status.dart';
import '../../../../enums/transaction_types.dart';
import '../../../../models/referral_model.dart';
import '../../../../models/reward_model.dart';
import '../../../../models/subscription_model.dart';
import '../../../../models/various_charges_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/order_service.dart';
import '../../../../services/referral_service.dart';
import '../../../../services/transaction_service.dart';
import '../../../../user/modules/widgets/dialogs/confirm_withdraw_dialog.dart';

class RetailerDashboardController extends GetxController {
  final _referralService = Get.find<ReferralService>();
  final _orderService = Get.find<OrderService>();
  final _authService = Get.find<AuthService>();
  final _transactionService = Get.find<TransactionService>();
  final TextEditingController amountController = TextEditingController();
  RxBool isLoading = false.obs;
  Rx<WalletModel> retailerWallet = WalletModel(walletId: '',balance: 0.00).obs;
  RxList<Referee>  refereesList = <Referee>[].obs;
  RxList<Referee>  thisMonthRefereesList = <Referee>[].obs;
  RxList<Rx<RewardModel>> retailerRewards = <Rx<RewardModel>>[].obs;
  RxList<TransactionModel> retailerTransactions = <TransactionModel>[].obs;
  Rx<SubcriptionCharges?> supplierSubcriptionCharges = SubcriptionCharges().obs;
  Rx<SubscriptionModel> currentSubscription = Rx<SubscriptionModel>(SubscriptionModel(uid: '', subscriptionStatus: SubscriptionStatus.none));
  Rx<PaymentType?> paymentType = Rx<PaymentType?>(null);



  @override
  void onInit() {
    super.onInit();
    refereesList.bindStream(_referralService.getRetailerReferees());
    retailerWallet.bindStream(_orderService.getWalletData());
    retailerRewards.bindStream(_orderService.getRewards());
    retailerTransactions.bindStream(_transactionService.getTransactionsByWallet(walletId: _authService.currentUser.value!.uid));
    supplierSubcriptionCharges.bindStream(_authService.getSubscriptionCharges());
    currentSubscription.bindStream(_authService.getSubscriptionDetailsStream(uid: _authService.currentUser.value!.uid));
    ever(refereesList,(callback) {
      final DateTime now = DateTime.now();
      thisMonthRefereesList.value = callback.where((element) {
        return element.referralDate.toDate().month == now.month && element.referralDate.toDate().year == now.year;
      }).toList();
    });

  }

  bool isUserHaveAccount() {
    print("user bank type: ${_authService.currentUser.value!.userBankType}");
    return  _authService.currentUser.value!.userBankType != null;
  }

  void requestForSubscription({required SubscriptionModel subscription}) async {
    isLoading.value = true;
    await _authService.activateSubscription(subscriptiondetails: subscription,retailer_name: _authService.currentUser.value?.name ?? '');
    //showSuccessSnackbar('Subscription request sent for approval');
    Get.back();
    isLoading.value = false;
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

  Future<void> withDrawMoney() async {
    TransactionModel transaction = TransactionModel(
      transactionStatus: TransactionStatus.pending,
      transactionType: TransactionType.Withdrawal,
      transactionAmount: double.parse(amountController.text),
      transactionDate:Timestamp.now(),
      walletId: retailerWallet.value.walletId,
      userName: _authService.currentUser.value!.name,
      userRole: _authService.currentUser.value!.role,
    );
    await _transactionService.addTransaction(transaction);
    amountController.clear();
    Get.dialog(const ConfirmWithDrawDialog());
  }

  @override
  void dispose() {
    super.dispose();
    retailerWallet.close();
    refereesList.close();
    thisMonthRefereesList.close();
    retailerRewards.close();
    retailerTransactions.close();
    supplierSubcriptionCharges.close();
    currentSubscription.close();
    amountController.dispose();
    isLoading.close();
  }

}