import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/admin/components/admin_drawer.dart';
import 'package:aookamao/admin/components/retailer_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../user/data/constants/app_colors.dart';
import 'controller/retailer_controller.dart';

class RetailersScreen extends StatefulWidget {
  const RetailersScreen({super.key});

  @override
  State<RetailersScreen> createState() => _RetailersScreenState();
}

class _RetailersScreenState extends State<RetailersScreen> {
  //final _retailerController = Get.find<RetailerController>();
  final _retailerController = Get.put(RetailerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const adminAppBar(Title: 'Retailers',),
      drawer: AdminDrawer(),
      body: Obx(() {
        if (_retailerController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: _retailerController.retailerList.length,
            itemBuilder: (context, index) {
             return RetailerCard(retailer: _retailerController.retailerList[index]);
            },
          );
        }
      }),
    );
  }

}
