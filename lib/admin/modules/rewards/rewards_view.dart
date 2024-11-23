import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/admin/modules/rewards/approved_rewards.dart';
import 'package:aookamao/admin/modules/rewards/pending_rewards.dart';
import 'package:aookamao/admin/modules/rewards/rejected_rewards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../user/data/constants/app_assets.dart';
import '../../../user/data/constants/app_colors.dart';
import '../../../user/data/constants/app_typography.dart';
import '../../../user/modules/notification/notification_view.dart';
import '../../components/admin_drawer.dart';
import 'controller/reward_controller.dart';

class RewardsView extends StatelessWidget {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final _rewardController = Get.find<RewardController>();
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: const AdminDrawer(),
          appBar: AppBar(
            title: Text(
              'Rewards',
                style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100)
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: TabBar(
                indicatorColor: AppColors.kPrimary,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppColors.kGrey100,
                unselectedLabelColor: AppColors.kGrey70,
                tabs: const [
                  Tab(
                    child: Text('Pending'),
                  ),
                  Tab(
                    child: Text('Approved'),
                  ),
                  Tab(
                    child: Text('Rejected'),
                  ),
                ],
              ),
            ),
            actions: [
              CustomIcons(
                onTap: () {
                  Get.to<Widget>(() => const NotificationView());
                },
                icon: AppAssets.kNotification,
              ),
              SizedBox(width: 20.0.w),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      PendingRewards(),
                      ApprovedRewards(),
                      RejectedRewards(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
