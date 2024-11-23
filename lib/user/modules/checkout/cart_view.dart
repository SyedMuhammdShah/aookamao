import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/controllers/cart_controller.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/checkout/components/cart_item_card.dart';
import 'package:aookamao/user/modules/checkout/components/drag_sheet.dart';
import 'package:aookamao/user/modules/checkout/components/no_item_card.dart';

import '../../controllers/home_controller.dart';
import '../home/product_detail_view.dart';

class CartView extends StatelessWidget {
  CartController cc = Get.find<CartController>();
  final _homeController = Get.find<HomeController>();
  CartView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: Text(
          'Cart',
          style: AppTypography.kSemiBold18.copyWith(color: AppColors.kGrey100),
        ),
      ),
      body: Obx(() =>
          cc.cartItems.isEmpty
            ? const NoItemCard()
            : Stack(
                children: [
                  SizedBox(
                    height: cc.isDragSheetOpen.value
                        ? Get.height - 0.5.sh
                        : Get.height,
                    child: ListView.separated(
                      itemCount: cc.cartItems.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: AppSpacing.twentyVertical,
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSpacing.twentyVertical),
                      itemBuilder: (context, index) {
                        return CartItemCard(
                          cartIndex: index,
                          product: _homeController.productsList[cc.cartItems[index].productListIndex],
                          removeCallback: () {
                            cc.removeFromCart(index);
                          },
                          onProductDetail: () {
                            Get.to<Widget>(() => ProductDetailView(
                                  productListIndex: cc.cartItems[index].productListIndex,
                                ));
                          },
                        );
                      },
                    ),
                  ),
                  DragSheet(
                    shipping:cc.shippingCharges.value,
                    subtotal: cc.getSubtotal(),
                    totalAmount: cc.getTotal() ,
                  ),
                ],
              )),
    );
  }
}
