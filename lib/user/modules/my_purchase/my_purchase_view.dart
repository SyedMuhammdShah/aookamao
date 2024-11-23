import 'package:aookamao/user/modules/my_purchase/processing_purchases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/my_purchase/components/my_purchase_card.dart';
import 'package:aookamao/user/modules/my_purchase/delivered_purchases.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import 'cancelled_purchases.dart';

class MyPurchaseView extends StatefulWidget {
  const MyPurchaseView({super.key});

  @override
  State<MyPurchaseView> createState() => _MyPurchaseViewState();
}

class _MyPurchaseViewState extends State<MyPurchaseView> {
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    _homeController.getOrders();
  }
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'My Purchase',
              style:
                  AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: TabBar(
                indicatorColor: AppColors.kPrimary,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppColors.kGrey100,
                unselectedLabelColor: AppColors.kGrey70,
                tabs: [
                  Tab(
                    child: Text('Processing'),
                  ),
                  Tab(
                    child: Text('Delivered'),
                  ),
                  Tab(
                    child: Text('Cancelled'),
                  ),
                ],
              ),
            ),
          ),
          body:
             Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: AppSpacing.twentyVertical,
                ),
                child:   const TabBarView(
                  children: [
                    ProcessingPurchases(),
                    DeliveredPurchases(),
                    CancelledPurchases(),
                  ],
                ),
              ),
          ),

    );
  }
}
