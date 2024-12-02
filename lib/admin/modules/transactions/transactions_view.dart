import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/admin/modules/transactions/approved_transactions.dart';
import 'package:aookamao/admin/modules/transactions/pending_transactions.dart';
import 'package:aookamao/admin/modules/transactions/rejected_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../user/data/constants/app_assets.dart';
import '../../../user/data/constants/app_colors.dart';
import '../../../user/data/constants/app_typography.dart';
import '../../../user/modules/notification/notification_view.dart';
import '../../components/admin_drawer.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: const AdminDrawer(),
          appBar: AppBar(
            title: Text(
                'Transactions',
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
                      PendingTransactions(),
                      ApprovedTransactions(),
                      RejectedTransactions()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
