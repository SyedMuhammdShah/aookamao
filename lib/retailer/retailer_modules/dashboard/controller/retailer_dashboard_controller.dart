import 'package:aookamao/models/wallet_model.dart';
import 'package:get/get.dart';

import '../../../../models/referral_model.dart';
import '../../../../models/reward_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/order_service.dart';
import '../../../../services/referral_service.dart';

class RetailerDashboardController extends GetxController {
  final _referralService = Get.find<ReferralService>();
  final _orderService = Get.find<OrderService>();
  final _authService = Get.find<AuthService>();
  RxBool isLoading = false.obs;
  Rx<WalletModel> retailerWallet = WalletModel(walletId: '',balance: 0.00).obs;
  RxList<Referee>  refereesList = <Referee>[].obs;
  RxList<Referee>  thisMonthRefereesList = <Referee>[].obs;
  RxList<Rx<RewardModel>> retailerRewards = <Rx<RewardModel>>[].obs;


  @override
  void onInit() {
    super.onInit();

    refereesList.bindStream(_referralService.getRetailerReferees());
    retailerWallet.bindStream(_orderService.getWalletData());
    retailerRewards.bindStream(_orderService.getRewards());
    ever(refereesList,(callback) {
      final DateTime now = DateTime.now();
      thisMonthRefereesList.value = callback.where((element) {
        return element.referralDate.toDate().month == now.month && element.referralDate.toDate().year == now.year;
      }).toList();
    });

  }

  @override
  void dispose() {
    super.dispose();
    retailerWallet.close();
    refereesList.close();
    thisMonthRefereesList.close();
    retailerRewards.close();
    isLoading.close();
  }

}