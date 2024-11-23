import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/home/components/quantity_card.dart';
import 'package:get/get.dart';

class PaymentProductCard extends StatelessWidget {
  final Rx<ProductModel> product;
  final int quantity;
  const PaymentProductCard({
    required this.product,
    super.key, required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 72.h,
          width: 72.w,
          child: CachedNetworkImage(
            imageUrl: product.value.imageUrls?[0],
            fit: BoxFit.cover,
           progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        SizedBox(width: AppSpacing.tenHorizontal),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.value.name??'',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.kSemiBold16,
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'x $quantity',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.kMedium14
                        .copyWith(color: AppColors.kGrey70),
                  ),
                  RichText(
                    text: TextSpan(
                      text: r'Rs.',
                      style: AppTypography.kMedium14
                          .copyWith(color: AppColors.kGrey100,fontSize: 12.sp),
                      children: [
                        TextSpan(
                          text: "${product.value.price! * quantity}",
                          style: AppTypography.kSemiBold16,
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
    );
  }
}
