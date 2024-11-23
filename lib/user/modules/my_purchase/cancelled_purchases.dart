import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../enums/order_status.dart';
import '../../controllers/home_controller.dart';
import '../../data/constants/app_spacing.dart';
import 'components/my_purchase_card.dart';

class CancelledPurchases extends StatelessWidget {
  const CancelledPurchases({super.key});

  @override
  Widget build(BuildContext context) {
    final _homeController = Get.find<HomeController>();
    return Obx(() =>
        ListView.separated(
          itemBuilder: (ctx, i) {
            return MyPurchaseCard(
              myPurchase: _homeController.myPurchasesList.where((element) => element.orderStatus == OrderStatus.cancelled).toList()[i],
            );
          },
          separatorBuilder: (ctx, i) => SizedBox(height: AppSpacing.twentyVertical),
          // itemCount: dummyProductList.length - 2,
          itemCount: _homeController.myPurchasesList.where((element) => element.orderStatus == OrderStatus.cancelled).length,
        ),
    );
  }
}
