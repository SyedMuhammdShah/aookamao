import 'package:aookamao/retailer/components/retailer_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../components/retailer_drawer.dart';
import '../../components/reward_card.dart';
import '../dashboard/controller/retailer_dashboard_controller.dart';

class RetailerRewardsView extends StatelessWidget {
  const RetailerRewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final _dashboardController = Get.find<RetailerDashboardController>();
    return Scaffold(
      appBar: const RetailerAppBar(title: 'Rewards'),
      drawer: const RetailerDrawer(),
      body: Obx(
        () => ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _dashboardController.retailerRewards.length,
            itemBuilder: (context, index) {
              return RewardCard(
                  reward: _dashboardController.retailerRewards[index]);
            }),
      ),
    );
  }
}
