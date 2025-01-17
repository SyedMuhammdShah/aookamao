import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/referred_by.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/checkout/address_view.dart';
import 'package:aookamao/user/modules/checkout/components/dotted_divider.dart';
import 'package:aookamao/user/modules/search/components/filter_sheet.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';

import '../../../controllers/cart_controller.dart';
import '../../../controllers/home_controller.dart';

class DragSheet extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double totalAmount;
   DragSheet({
    required this.shipping,
    required this.subtotal,
    required this.totalAmount,
    super.key,
  });
final _homeController = Get.find<HomeController>();
final _cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context){
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent <=0.3) {
         _cartController.isDragSheetOpen.value = false;
        }
        else {
          _cartController.isDragSheetOpen.value = true;
        }
        return true;
      },
      child: DraggableScrollableSheet(
        minChildSize: 0.1,
        maxChildSize: 0.5,
        initialChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.only(
              top: 10.h,
              left: 24.w,
              right: 24.0.w,
              bottom: 20.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusTwenty),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                const CustomDivider(),
                SizedBox(height: AppSpacing.twentyVertical),
                _homeController.isReferralApplied.value
                    ? Container(
                        //height: 56.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.kLine),
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.kGrey30,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppAssets.kDiscountShape),
                                SizedBox(width: AppSpacing.tenHorizontal),
                                Text(
                                  'Referral Applied',
                                  style: AppTypography.kMedium14.copyWith(
                                    color: AppColors.kGrey70,
                                  ),
                                ),
                              ],
                            ),
                            if(_homeController.currentReferralDetails.value.referredBy == ReferredBy.Retailer)
                              Row(
                                children: [
                                  Text(
                                    'Your Eligible For Rs.${Constants.customerRewardAmount} Cashback On This Order.',
                                    style: AppTypography.kSemiBold12.copyWith(
                                      color: AppColors.kSuccess,
                                    ),
                                  ),
                                ],
                              ),


                          ],
                        ),
                      )
                    : SizedBox(),
                /*Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kLine),
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.kGrey30,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppAssets.kDiscountShape),
                      SizedBox(width: AppSpacing.tenHorizontal),
                      Text(
                        'Enter Promo Code',
                        style: AppTypography.kMedium14.copyWith(
                          color: AppColors.kGrey70,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: AppColors.kGrey70,
                      ),
                    ],
                  ),
                ),*/
                SizedBox(height: AppSpacing.twentyVertical),
                CustomPaymentDetails(amount: subtotal, heading: 'Subtotal'),
                SizedBox(height: AppSpacing.tenVertical),
                CustomPaymentDetails(amount: shipping, heading: 'Shipping'),
                SizedBox(height: AppSpacing.twentyVertical),
                const DottedDivider(),
                SizedBox(height: AppSpacing.twentyVertical),
                CustomPaymentDetails(
                  amount: totalAmount,
                  heading: 'Total Amount',
                  isTotal: true,
                ),
                SizedBox(height: AppSpacing.twentyVertical),
                PrimaryButton(
                  onTap: () {
                    Get.to<Widget>(() => const AddressView());
                  },
                  text: 'Checkout',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomPaymentDetails extends StatelessWidget {
  final String heading;
  final double amount;
  final bool isTotal;
  const CustomPaymentDetails({
    required this.amount,
    required this.heading,
    this.isTotal = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              heading,
              style: AppTypography.kMedium14
                  .copyWith(color: AppColors.kGrey70, fontSize: 14.sp),
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                text: r'Rs.',
                style: AppTypography.kSemiBold12
                    .copyWith(color: AppColors.kSecondary, fontSize: 12.sp),
                children: [
                  TextSpan(
                    text: amount.toString(),
                    style:isTotal? AppTypography.kSemiBold24: AppTypography.kSemiBold16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
