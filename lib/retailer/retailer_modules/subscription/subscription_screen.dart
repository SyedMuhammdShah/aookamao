
import 'package:aookamao/retailer/components/subscription_payment.dart';
import 'package:aookamao/retailer/retailer_modules/dashboard/controller/retailer_dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../models/subscription_model.dart';
import '../../../services/auth_service.dart';
import '../../../user/data/constants/app_colors.dart';
import '../../../user/data/constants/app_spacing.dart';
import '../../../user/data/constants/app_typography.dart';
import '../../../user/modules/checkout/components/payment_method_card.dart';
import '../../../user/modules/checkout/components/select_payment_method.dart';
import '../../../user/modules/widgets/buttons/primary_button.dart';
import '../../../enums/subscription_status.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../modules/auth/controller/auth_controller.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final retailerDashboardController = Get.find<RetailerDashboardController>();
    return Scaffold(
      backgroundColor: AppColors.kGrey20,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                InkWell(borderRadius: BorderRadius.circular(50), onTap: () => Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    )),
                SizedBox(width: 0.23.sw),
                Text("Subscription", style: AppTypography.kSemiBold20),
              ],
            ),
            SizedBox(height: 20.h),
            SvgPicture.asset("assets/icons/lock.svg"),
            SizedBox(height: 20.h),
            Container(
              width: 0.7.sw,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text('Pay', style: AppTypography.kSemiBold20),
                  SizedBox(height: 20.h),
                  Obx(()=> Text('Rs. ${retailerDashboardController.supplierSubcriptionCharges.value?.amount ?? ''}', style: AppTypography.kSemiBold32.copyWith(color: AppColors.kGrey60))),
                  SizedBox(height: 20.h),
                  Text('One Time', style: AppTypography.kSemiBold20),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                Text("About Subscription", style: AppTypography.kSemiBold20),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                Icon(Icons.check),
                SizedBox(width: 10.w),
                Text("Refer And Earn", style: AppTypography.kMedium14),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                Icon(Icons.check),
                SizedBox(width: 10.w),
                Text("Earn Upto Rs.1000 On Every Referral", style: AppTypography.kMedium14),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                Icon(Icons.check),
                SizedBox(width: 10.w),
                Text("Earn Exciting Rewards", style: AppTypography.kMedium14),
              ],
            ),
            SizedBox(height: 30.h),
            PrimaryButton(
              onTap: ()  {

                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusThirty),
                    ),
                  ),
                  builder: (context) {
                    return const SubscriptionPayment();
                  },
                );

            }, text: "Pay Now",width: 0.8.sw,),
          ],
        ),
      ),
    );
  }
}
