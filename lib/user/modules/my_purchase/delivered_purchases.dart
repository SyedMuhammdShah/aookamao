import 'package:flutter/material.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/my_purchase/components/my_purchase_card.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../enums/order_status.dart';
import '../../controllers/home_controller.dart';

class DeliveredPurchases extends StatelessWidget {
  const DeliveredPurchases({super.key});

  @override
  Widget build(BuildContext context) {
    final _homeController = Get.find<HomeController>();
    return Obx(() =>
        ListView.separated(
          itemBuilder: (ctx, i) {
            return MyPurchaseCard(
              myPurchase: _homeController.myPurchasesList.where((element) => element.orderStatus == OrderStatus.delivered).toList()[i],
            );
          },
          separatorBuilder: (ctx, i) => SizedBox(height: AppSpacing.twentyVertical),
          // itemCount: dummyProductList.length - 2,
          itemCount: _homeController.myPurchasesList.where((element) => element.orderStatus == OrderStatus.delivered).length,
        ),
    );
  }
}
