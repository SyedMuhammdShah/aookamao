import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/home/components/quantity_card.dart';

class PaymentProductCard extends StatelessWidget {
  final ProductModel product;
  const PaymentProductCard({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 72.h,
          width: 72.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusTen),
            image: DecorationImage(
              image: AssetImage(product.imageUrls[0]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.tenHorizontal),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.kSemiBold16,
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'By Leopar Zega',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.kMedium14
                        .copyWith(color: AppColors.kGrey70, fontSize: 10.sp),
                  ),
                  RichText(
                    text: TextSpan(
                      text: r'$ ',
                      style: AppTypography.kMedium14
                          .copyWith(color: AppColors.kGrey100,fontSize: 12.sp),
                      children: [
                        TextSpan(
                          text: product.currentPrice.toString(),
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
