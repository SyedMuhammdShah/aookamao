import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/retailer/components/referal_card.dart';
import 'package:aookamao/retailer/retailer_modules/dashboard/controller/retailer_dashboard_controller.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/modules/auth/controller/auth_controller.dart';

import 'package:aookamao/retailer/retailer_modules/subscription/subscription_controller/subscription_controller.dart';
import 'package:aookamao/retailer/retailer_modules/subscription/subscription_screen.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../admin/components/admin_drawer.dart';
import '../../../enums/referral_types.dart';
import '../../../services/auth_service.dart';
import '../../../services/referral_service.dart';
import '../../components/retailer_appbar.dart';
import '../../components/retailer_drawer.dart';
import '../referal/refer_now.dart';

class RetailerDashboard extends StatefulWidget {
  const RetailerDashboard({super.key});

  @override
  State<RetailerDashboard> createState() => _RetailerDashboardState();
}

class _RetailerDashboardState extends State<RetailerDashboard> {
  SubscriptionController subscriptionController = Get.find<SubscriptionController>();
  final _authService = Get.find<AuthService>();
  final _dashboardController = Get.find<RetailerDashboardController>();

  @override
  void initState() {
    subscriptionController.getSubscriptionDetails(uid: _authService.currentUser.value!.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RetailerAppBar(user: _authService.currentUser.value!),
      drawer: RetailerDrawer(),
      body: Obx(()=>SingleChildScrollView(
        child: Column(
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
        
              if(subscriptionController.currentSubscription.value.subscriptionStatus == SubscriptionStatus.active)
               Column(
                 children: [
                   SizedBox(
                     height: 0.02.sh,
                   ),
                   Center(
                     child: Container(
                       height: 0.2.sh,
                        width: 0.9.sw,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary,
                          borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Welcome To Aoo Kamao',style: AppTypography.kSemiBold20.copyWith(color: Colors.white),),
                            SizedBox(height: 10.h,),
                            Text(_authService.currentUser.value!.name,style: AppTypography.kBold24.copyWith(color: Colors.white),)
                          ],
                        ),
                     ),
                   ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _dashboardcard(title: 'Wallet', subtitle: '0.00', icon: Icons.wallet),
                        _dashboardcard(title: 'Referrals', subtitle: _dashboardController.totalReferrals.value, icon: Icons.people),
                        _dashboardcard(title: 'Orders', subtitle: '0', icon: Icons.shopping_cart),
                      ],
                    ),
                    SizedBox(
                      height: 0.04.sh,
                    ),
                   SvgPicture.asset('assets/icons/refer-friend.svg',height: 0.32.sh,),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Text("Refer Now and Earn Up to Rs 1000!",style: AppTypography.kMedium16.copyWith(color: Colors.grey),),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                   CustomTextButton(
                     onPressed: () =>Get.to(()=>const ReferNow()),
                     text: 'Refer Now',
                     fontSize: 18.sp,
                     color: AppColors.kPrimary,
                   ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                   //your this month referres list
                    Container(
                      //height: 0.3.sh,
                      width: 0.9.sw,
                      decoration: BoxDecoration(
                        color: AppColors.kGrey10,
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("This Month Referrals",style: AppTypography.kMedium16,),
                                Text("View All",style: AppTypography.kMedium12.copyWith(color: AppColors.kPrimary),)
                              ],
                            ),
                          ),
                          Divider(),
                          ListView.builder(
                            itemCount: _dashboardController.thisMonthRefereesList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){

                              return ReferalCard(
                                refereeName: _dashboardController.thisMonthRefereesList[index].refereeName??'',
                                referalType: _dashboardController.thisMonthRefereesList[index].referalType,
                                referalDate:_dashboardController.thisMonthRefereesList[index].referralDate,
                                referedByName: _dashboardController.thisMonthRefereesList[index].referedByName,
                              );

                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                 ],
               )
            ],
          ),
      ),
      )
    );
  }
}
Widget _dashboardcard({required String title, required String subtitle, required IconData icon}) {
  return Container(
    height: 0.15.sh,
    width: 0.28.sw,
    decoration: BoxDecoration(
        color: AppColors.kPrimary,
      borderRadius: BorderRadius.circular(10.r)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,color: Colors.white,size: 30.sp,),
        SizedBox(height: 10.h,),
        Text(subtitle,style: AppTypography.kSemiBold20.copyWith(color: Colors.white),),
        Text(title,style: AppTypography.kSemiBold16.copyWith(color: Colors.white),),
      ],
    ),
  );
}