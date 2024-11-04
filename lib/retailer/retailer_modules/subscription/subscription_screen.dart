import 'package:aookamao/admin/admin_dashboard.dart';
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:aookamao/app/data/constants/app_typography.dart';
import 'package:aookamao/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text('Rs. 1000', style: AppTypography.kSemiBold32.copyWith(color: AppColors.kGrey60)),
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
            PrimaryButton(onTap: () {}, text: "Pay Now",width: 0.8.sw,),
          ],
        ),
      ),
    );
  }
}
