import 'package:aookamao/admin/components/admin_drawer.dart';
import 'package:aookamao/admin/modules/dashboard/controller/admin_dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/adminAppBar.dart';
import '../../components/referee_card.dart';

class AllRefereesView extends StatefulWidget {
  const AllRefereesView({super.key});

  @override
  State<AllRefereesView> createState() => _AllRefereesViewState();
}

class _AllRefereesViewState extends State<AllRefereesView> {
  final dashboardController = Get.find<AdminDashboardController>();
  @override
  void initState() {
    super.initState();
    dashboardController.getAllReferess();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const adminAppBar(Title: 'All Referees'),
      drawer: AdminDrawer(),
      body: Obx(() => ListView.builder(
          itemCount: dashboardController.allReferessList.length,
          itemBuilder: (context, index) {
            return RefereeCard(
            refereeName: dashboardController.allReferessList[index].refereeName??'',
            referalType: dashboardController.allReferessList[index].referalType,
            referalDate: dashboardController.allReferessList[index].referralDate,
              referedByName: dashboardController.allReferessList[index].referedByName,
            );
          }),
      ),
    );
  }
}
