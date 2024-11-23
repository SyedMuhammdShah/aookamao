import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_spacing.dart';
import '../../../data/constants/app_typography.dart';
import '../../my_purchase/my_purchase_view.dart';
import '../buttons/custom_outlined_button.dart';
import '../buttons/primary_button.dart';

class OrderConfirmedDialog extends StatelessWidget {
  const OrderConfirmedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/order_delivery.svg', height: 250.h),
          Text('Order Confirmed', style: AppTypography.kSemiBold16),
          SizedBox(height: AppSpacing.fiveVertical),
          Text(
            'Your order placed successfully. You can track your order in the tracking section.',
            textAlign: TextAlign.center,
            style: AppTypography.kMedium14.copyWith(color: AppColors.kGrey60),),
          SizedBox(height: AppSpacing.twentyVertical),
          Row(
            children: [
              Expanded(
                child:  CustomOutlinedButton(
                  onTap: () {
                    Get.back<void>();
                  },
                  width: 115.0.w,
                  borderRadius: 30.0.r,
                  height: 46.0.h,
                  fontSize: 14.0.sp,
                  text: 'Close',
                  color: AppColors.kPrimary,
                ),
              ),
              Expanded(
                child: PrimaryButton(
                  onTap: () {
                    Get.to<Widget>(() => const MyPurchaseView());
                  },
                  width: 115.w,
                  borderRadius: 30.r,
                  height: 46.h,
                  fontSize: 14.sp,
                  text: 'Tracking',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
