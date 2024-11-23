import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aookamao/user/data/constants/constants.dart';

class PaymentMethodCard extends StatelessWidget {
  final VoidCallback onTap;
  const PaymentMethodCard({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.kLine),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Container(
              height: 46.h,
              width: 46.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.kLine,
                shape: BoxShape.circle,
              ),
              /*child: SvgPicture.asset(AppAssets.kMasterCardIcon),*/
              child: Icon(Icons.credit_card_outlined),
            ),
            SizedBox(width: AppSpacing.tenHorizontal),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash on Delivery',
                  style: AppTypography.kMedium14,
                ),
                SizedBox(height: AppSpacing.fiveVertical),
                Text(
                  'Pay when you receive the product',
                  style: AppTypography.kMedium14
                      .copyWith(color: AppColors.kGrey70, fontSize: 12.sp),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_right_outlined,
                color: AppColors.kGrey60),
          ],
        ),
      ),
    );
  }
}
