import 'package:aookamao/user/models/cart_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/home/components/quantity_card.dart';
import 'package:aookamao/user/modules/home/product_detail_view.dart';

import '../../../controllers/home_controller.dart';

class CartItemCard extends StatelessWidget {
  final Rx<CartModel> cartItem;
  final VoidCallback removeCallback;
  final VoidCallback onProductDetail;
  const CartItemCard({
    required this.cartItem,
    required this.removeCallback,
    super.key, required this.onProductDetail,
  });

  @override
  Widget build(BuildContext context) {
    final _homeController = Get.find<HomeController>();
    final Rx<ProductModel> product = _homeController.productsList[cartItem.value.productListIndex];
    return Obx(() =>  GestureDetector(
        onTap: () => onProductDetail(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      height: 92.h,
                      width: 92.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusTen),
                        child: CachedNetworkImage(
                          imageUrl:product.value.imageUrls?[0] ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(width: AppSpacing.tenHorizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.value.name??'',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.kSemiBold18,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      IconButton(
                        onPressed: removeCallback,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.kError,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.fiveVertical),
                  Text(
                    'By Leopar Zega',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.kMedium14
                        .copyWith(color: AppColors.kGrey70, fontSize: 10.sp),
                  ),
                  SizedBox(height: AppSpacing.tenHorizontal),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuantityCard(
                      quantity: cartItem.value.quantity.obs,
                        stockQuantity: product.value.stockQuantity??0,
                      ),
                      RichText(
                        text: TextSpan(
                          text: r'Rs. ',
                          style: AppTypography.kMedium14
                              .copyWith(color: AppColors.kGrey100),
                          children: [
                            TextSpan(
                              text: product.value.price.toString(),
                              style: AppTypography.kSemiBold24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
