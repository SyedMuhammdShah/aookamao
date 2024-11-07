import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:aookamao/user/models/user_model.dart';
import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/retailer/retailer_modules/auth/auth_controller/auth_controller.dart';
import 'package:aookamao/retailer/retailer_modules/auth/components/retailer_appbar.dart';
import 'package:aookamao/retailer/retailer_modules/auth/components/retailer_drawer.dart';
import 'package:aookamao/retailer/retailer_modules/subscription/subscription_controller/subscription_controller.dart';
import 'package:aookamao/retailer/retailer_modules/subscription/subscription_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../admin/components/admin_drawer.dart';
import '../models/subscription_model.dart';

class RetailerDashboard extends StatefulWidget {
  const RetailerDashboard({super.key});

  @override
  State<RetailerDashboard> createState() => _RetailerDashboardState();
}

class _RetailerDashboardState extends State<RetailerDashboard> {
  RetailerAuthController authController =  Get.find<RetailerAuthController>();
  SubscriptionController subscriptionController = Get.find<SubscriptionController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RetailerAppBar(user: authController.retailerUser),
      drawer: RetailerDrawer(),
      body:
      Obx(()=>Column(
          children: [
            if(subscriptionController.currentSubscription.value.subscriptionStatus == SubscriptionStatus.none)
             //half screen
              Column(
                children: [
                  SizedBox(
                    height: 0.4.sh,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,color: Colors.red,size: 30.sp,),
                      SizedBox(width: 10.w,),
                      Text("Your subscription is not active!",style:AppTypography.kMedium20),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Text("Activate your subscription to continue using our services",style: AppTypography.kMedium12.copyWith(color: Colors.grey),),
                  TextButton(onPressed: (){
                    Get.to(()=>const SubscriptionScreen());
                  }, child: Text("Activate Subscription",style: AppTypography.kMedium14.copyWith(color: AppColors.kPrimary),))
                ],
              ),
            if(subscriptionController.currentSubscription.value.subscriptionStatus == SubscriptionStatus.pending)
              Column(
                children: [
                  SizedBox(
                    height: 0.4.sh,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time,color: Colors.yellow,size: 30.sp,),
                      SizedBox(width: 10.w,),
                      Text("Your subscription is pending!",style:AppTypography.kMedium20),
                    ],
                  ),
                  SizedBox(height: 10.h,),

                  SizedBox(
                    width: 0.74.sw,
                      child: Text("Your subscription is under review. You will be notified once it is approved.",style: AppTypography.kMedium12.copyWith(color: Colors.grey),textAlign: TextAlign.center,)),
                ],
              ),

            TextButton(onPressed: () {
              subscriptionController.activateSubscription(subscriptiondetails: SubscriptionModel(uid: authController.retailerUser.uid, subscriptionStatus: SubscriptionStatus.none));
            }, child: Text('reset subscription')),
          ],
        ),
      )
    );
  }
}