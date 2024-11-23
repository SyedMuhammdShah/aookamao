import 'package:aookamao/retailer/components/referal_card.dart';
import 'package:aookamao/retailer/components/retailer_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/retailer_drawer.dart';
import '../dashboard/controller/retailer_dashboard_controller.dart';

class AllReferralsView extends StatelessWidget {
  const AllReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<RetailerDashboardController>();
    return Scaffold(
      appBar: const RetailerAppBar(title: 'All Referrals'),
      drawer: const RetailerDrawer(),
      body: Obx(
        () => ListView.builder(
            itemCount: dashboardController.refereesList.length,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            itemBuilder: (context, index) {
              return ReferalCard(
                refereeName:
                    dashboardController.refereesList[index].refereeName ?? '',
                referalType:
                    dashboardController.refereesList[index].referalType,
                referalDate:
                    dashboardController.refereesList[index].referralDate,
                referedByName:
                    dashboardController.refereesList[index].referedByName,
              );
            }),
      ),
    );
  }
}
