import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/reward_status.dart';
import 'package:aookamao/retailer/components/referal_card.dart';
import 'package:aookamao/retailer/retailer_modules/dashboard/controller/retailer_dashboard_controller.dart';
import 'package:aookamao/retailer/retailer_modules/wallet/wallet_view.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:aookamao/enums/subscription_status.dart';
import 'package:aookamao/modules/auth/controller/auth_controller.dart';

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
import '../../../admin/modules/profile/components/fade_animation.dart';
import '../../../enums/referral_types.dart';
import '../../../modules/auth/selection_view.dart';
import '../../../services/auth_service.dart';
import '../../../services/referral_service.dart';
import '../../../user/modules/widgets/dialogs/logout_dialog.dart';
import '../../components/retailer_appbar.dart';
import '../../components/retailer_drawer.dart';
import '../Reward/rewards_view.dart';
import '../referal/refer_now.dart';
import '../referrals/all_referrals_view.dart';

class RetailerDashboard extends StatefulWidget {
  const RetailerDashboard({super.key});

  @override
  State<RetailerDashboard> createState() => _RetailerDashboardState();
}

class _RetailerDashboardState extends State<RetailerDashboard> {
  final _authService = Get.find<AuthService>();
  final _dashboardController = Get.find<RetailerDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Scaffold(
      appBar: const RetailerAppBar(),
      drawer: _dashboardController.currentSubscription.value.subscriptionStatus == SubscriptionStatus.active ? const RetailerDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
            children: [
              if(_dashboardController.currentSubscription.value.subscriptionStatus == SubscriptionStatus.none)
               //half screen
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
                            color: AppColors.kWhite,
                            borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/splash_icon.svg',height: 0.1.sh,),
                            SizedBox(height: 10.h,),
                            Text('Welcome To ${Constants.appName}',style: AppTypography.kSemiBold20,),
                            SizedBox(height: 10.h,),
                            Text(_authService.currentUser.value!.name,style: AppTypography.kBold24)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.2.sh,
                    ),
                    Text("Activate your subscription to continue using our services",style: AppTypography.kMedium12.copyWith(color: Colors.grey),),
                    TextButton(onPressed: (){
                      Get.to(()=>const SubscriptionScreen());
                    }, child: Text("Activate Subscription",style: AppTypography.kMedium14.copyWith(color: AppColors.kPrimary),)),
                    SizedBox(height: 10.h,),
                    FadeAnimation(
                      delay: 1,
                      child: Center(
                        child: CustomTextButton(
                          onPressed: () {
                            Get.dialog<void>(LogoutDialog(
                              logoutCallback: () async {
                                await _authService.signOut();
                                Get.offAll<Widget>(() => const SelectionScreen());
                              },
                            ));
                          },
                          text: 'Logout',
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              if(_dashboardController.currentSubscription.value.subscriptionStatus == SubscriptionStatus.pending)
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
                            color: AppColors.kWhite,
                            borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/splash_icon.svg',height: 0.1.sh,),
                            SizedBox(height: 10.h,),
                            Text('Welcome To ${Constants.appName}',style: AppTypography.kSemiBold20,),
                            SizedBox(height: 10.h,),
                            Text(_authService.currentUser.value!.name,style: AppTypography.kBold24),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.2.sh,
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

                    SizedBox(height: 10.h,),
                    FadeAnimation(
                      delay: 1,
                      child: Center(
                        child: CustomTextButton(
                          onPressed: () {
                            Get.dialog<void>(LogoutDialog(
                              logoutCallback: () async {
                                await _authService.signOut();
                                Get.offAll<Widget>(() => const SelectionScreen());
                              },
                            ));
                          },
                          text: 'Logout',
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
        
              if(_dashboardController.currentSubscription.value.subscriptionStatus == SubscriptionStatus.active)
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
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/splash_icon.svg',height: 0.1.sh,),
                            SizedBox(height: 10.h,),
                            Text('Welcome To ${Constants.appName}',style: AppTypography.kSemiBold20,),
                            SizedBox(height: 10.h,),
                            Text(_authService.currentUser.value!.name,style: AppTypography.kBold24)
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
                        _dashboardcard(title: 'Wallet', subtitle: _dashboardController.retailerWallet.value.balance.toString(), icon: Icons.wallet,onTap:() => Get.to<Widget>(()=>const WalletView())),
                        _dashboardcard(title: 'Referrals', subtitle: _dashboardController.refereesList.length.toString(), icon: Icons.people,onTap:() => Get.to<Widget>(()=>const AllReferralsView())),
                        _dashboardcard(title: 'Rewards', subtitle: _dashboardController.retailerRewards.where((p0) => p0.value.rewardStatus == RewardStatus.approved).length.toString(), icon: Icons.card_giftcard,onTap:() => Get.to<Widget>(()=>const RetailerRewardsView())),
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
                              ],
                            ),
                          ),
                          const Divider(),
                          _dashboardController.thisMonthRefereesList.isEmpty
                              ? Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No Referrals Yet",style: AppTypography.kMedium16.copyWith(color: Colors.grey),),
                              ))
                              : ListView.builder(
                            itemCount: _dashboardController.thisMonthRefereesList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                              final DateTime now = DateTime.now();
                              final referee = _dashboardController.refereesList.where((element) {
                                return element.referralDate.toDate().month == now.month && element.referralDate.toDate().year == now.year;
                              }).toList();
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
Widget _dashboardcard({required String title, required String subtitle, required IconData icon,required VoidCallback onTap}){
  {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 0.15.sh,
          width: 0.28.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.kPrimary, size: 30.sp,),
              SizedBox(height: 10.h,),
              Text(subtitle, style: AppTypography.kSemiBold20.copyWith(
                  color: AppColors.kSecondary),),
              Text(title, style: AppTypography.kSemiBold16,),
            ],
          ),
        ),
      ),
    );
  }
}