import 'package:aookamao/user/models/cart_model.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/home/components/quantity_card.dart';
import 'package:aookamao/user/modules/home/product_detail_view.dart';

import '../../../controllers/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  final Rx<ProductModel> product;
  final VoidCallback removeCallback;
  final VoidCallback onProductDetail;
  final int cartIndex;
  const CartItemCard({
    required this.product,
    required this.removeCallback,
    required this.cartIndex,
    super.key, required this.onProductDetail,
  });

  @override
  Widget build(BuildContext context) {
    CartController cc = Get.find<CartController>();
    return Obx(() =>  Row(
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
              //SizedBox(height: AppSpacing.fiveVertical),
              InkWell(
                onTap: () => onProductDetail(),
                borderRadius: BorderRadius.circular(AppSpacing.radiusTen),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'View Details',
                    style: AppTypography.kMedium12
                        .copyWith(color: AppColors.kGrey70, ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  product.value.stockQuantity == 0
                      ?  Text(
                    'Out of Stock',
                    style: AppTypography.kMedium12
                        .copyWith(color: AppColors.kError),
                  )
                      : QuantityCard(
                     stockQuantity: product.value.stockQuantity!.obs,
                    quantity: cc.cartItems[cartIndex].quantity.obs,
                    onChanged: (value) {
                      cc.cartItems[cartIndex].quantity = value;
                      cc.cartItems.refresh();
                    },
                    ),
                  RichText(
                    text: TextSpan(
                      text: r'Rs. ',
                      style: AppTypography.kMedium14
                      .copyWith(
                      color:AppColors.kSecondary,
                    ),
                      children: [
                        TextSpan(
                          text: product.value.price.toString(),
                          style: AppTypography.kSemiBold16.copyWith(
                            color:AppColors.kSecondary,
                          ),
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
    );
  }
}
