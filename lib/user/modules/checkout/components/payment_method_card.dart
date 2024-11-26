import 'package:aookamao/enums/payment_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:get/get.dart';

import '../../../controllers/cart_controller.dart';

class PaymentMethodCard extends StatelessWidget {
  final VoidCallback onTap;
  const PaymentMethodCard({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cartController = Get.find<CartController>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.kLine),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Obx(() =>
          Row(
            children: [
              if(_cartController.paymentType.value==PaymentType.cod)
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.w,
                    padding: EdgeInsets.all(5),
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
                        'You Selected COD for Payment',
                        style: AppTypography.kMedium14
                            .copyWith(color: AppColors.kGrey70, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
              if(_cartController.paymentType.value==PaymentType.meezanBank)
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.w,
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.kLine,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/icons/meezan_logo.svg'),
                  ),
                  SizedBox(width: AppSpacing.tenHorizontal),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meezan Bank',
                        style: AppTypography.kMedium14,
                      ),
                      SizedBox(height: AppSpacing.fiveVertical),
                      Text(
                        'You Selected Meezan Bank for Payment',
                        style: AppTypography.kMedium14
                            .copyWith(color: AppColors.kGrey70, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
              if(_cartController.paymentType.value==PaymentType.easyPaisa)
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.w,
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.kLine,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/icons/easypaisa_logo.svg'),
                  ),
                  SizedBox(width: AppSpacing.tenHorizontal),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EasyPaisa',
                        style: AppTypography.kMedium14,
                      ),
                      SizedBox(height: AppSpacing.fiveVertical),
                      Text(
                        'You Selected EasyPaisa for Payment',
                        style: AppTypography.kMedium14
                            .copyWith(color: AppColors.kGrey70, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
              if(_cartController.paymentType.value==PaymentType.jazzCash)
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.w,
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.kLine,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/icons/jazz_cash_logo.svg'),
                  ),
                  SizedBox(width: AppSpacing.tenHorizontal),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JazzCash',
                        style: AppTypography.kMedium14,
                      ),
                      SizedBox(height: AppSpacing.fiveVertical),
                      Text(
                        'You Selected JazzCash for Payment',
                        style: AppTypography.kMedium14
                            .copyWith(color: AppColors.kGrey70, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
              if(_cartController.paymentType.value == null)
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.kLine,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(AppAssets.kWallet),
                  ),
                  SizedBox(width: AppSpacing.tenHorizontal),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please Select Payment Method',
                        style: AppTypography.kMedium14,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_right_outlined,
                  color: AppColors.kGrey60),
            ],
          ),
        ),
      ),
    );
  }
}
