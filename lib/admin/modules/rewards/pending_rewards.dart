import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../enums/reward_status.dart';
import '../../components/reward_card.dart';
import 'controller/reward_controller.dart';

class PendingRewards extends StatelessWidget {
  const PendingRewards({super.key});

  @override
  Widget build(BuildContext context) {
    final _rewardController = Get.find<RewardController>();
    return Obx(() => ListView.builder(
        physics: const BouncingScrollPhysics(),
          itemCount: _rewardController.rewardsList.where((reward) => reward.value.rewardStatus == RewardStatus.pending).length,
      itemBuilder: (context, index) {
      return RewardCard(reward: _rewardController.rewardsList.where((reward) => reward.value.rewardStatus == RewardStatus.pending).elementAt(index));
      }
      ),
    );
  }
}
