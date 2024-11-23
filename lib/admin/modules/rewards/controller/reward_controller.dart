import 'package:aookamao/enums/rewarded_to.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

import '../../../../enums/reward_status.dart';
import '../../../../models/reward_model.dart';
import '../../../../services/order_service.dart';

class RewardController extends GetxController{

  RxList<Rx<RewardModel>> rewardsList = <Rx<RewardModel>>[].obs;
  final _orderService = Get.find<OrderService>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    rewardsList.bindStream(_orderService.getAllRewards());
  }

  Future<void> updateRewardStatus({required String rewardId,required RewardStatus status,required String rewardUserId,required RewardedTo rewardedTo}) async {
    isLoading.value = true;
    await _orderService.updateRewardStatus(rewardId: rewardId, status: status, rewardUserId: rewardUserId,rewardedTo: rewardedTo);
    if(status==RewardStatus.approved){
      showSuccessSnackbar('Reward Approved');
    }
    else if(status==RewardStatus.rejected){
      showSuccessSnackbar('Reward Rejected');
    }
    isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    rewardsList.close();
    isLoading.close();
  }

}