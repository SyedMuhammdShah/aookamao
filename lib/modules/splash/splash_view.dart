import 'package:aookamao/admin/modules/dashboard/admin_dashboard.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/modules/auth/selection_view.dart';
import 'package:aookamao/modules/auth/signin_view.dart';
import 'package:aookamao/retailer/retailer_modules/dashboard/retailer_dashboard.dart';
import 'package:aookamao/services/auth_service.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:aookamao/user/modules/landingPage/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';

import '../../constants/constants.dart';
import '../onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _authService = Get.find<AuthService>();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
    if(_authService.isAppOpened.isTrue){
      if(_authService.isUserLoggedIn.value) {

        print('current user name: ${_authService.currentUser.value?.name}');
        print('current user role: ${_authService.currentUser.value?.role}');
        switch (_authService.currentUser.value?.role) {
          case UserRoles.user:
            Get.offAll<Widget>(() => const LandingPage());
            break;
          case UserRoles.admin:
            Get.offAll<Widget>(() => AdminDashboard());
            break;
          case UserRoles.retailer:
            Get.offAll<Widget>(() => const RetailerDashboard());
            break;
          default:
            Get.offAll<Widget>(() => const SelectionScreen());
        }
      }
      else{
          Get.offAll<Widget>(() => const SelectionScreen());
      }
    }else{
      Get.offAll<Widget>(() => const OnboardingView());
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.kSplashBG),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/icons/splash_icon.svg',
                /*height: 64.h,
                width: 64.w,*/
              ),
            ),
            SizedBox(height: AppSpacing.fiftyVertical),
            SizedBox(height: AppSpacing.fiftyVertical),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
            ),

          ],
        ),
      ),
    );
  }
}
