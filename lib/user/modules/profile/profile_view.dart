import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/user_model.dart';
import 'package:aookamao/user/modules/profile/components/fade_animation.dart';
import 'package:aookamao/user/modules/profile/components/profile_header_card.dart';
import 'package:aookamao/user/modules/profile/components/setting_tile.dart';
import 'package:aookamao/user/modules/profile/help_support_view.dart';
import 'package:aookamao/user/modules/profile/languages_view.dart';
import 'package:aookamao/user/modules/profile/notification_settings_view.dart';
import 'package:aookamao/user/modules/profile/security_view.dart';
import 'package:aookamao/user/modules/profile/your_card.dart';
import 'package:aookamao/user/modules/welcome/welcome_view.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:aookamao/user/modules/widgets/dialogs/logout_dialog.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
get dummyUser => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Profile',
          style: AppTypography.kSemiBold18.copyWith(color: AppColors.kGrey100),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        children: [
          FadeAnimation(
            delay: 1,
            child: ProfileHeaderCard(
               user: dummyUser,
            ),
          ),
          SizedBox(height: AppSpacing.thirtyVertical),
          FadeAnimation(
            delay: 1,
            child: Text(
              'Settings',
              style: AppTypography.kSemiBold14.copyWith(color: AppColors.kGrey60),
            ),
          ),
          SizedBox(height: AppSpacing.tenVertical),
          FadeAnimation(
            delay: 1,
            child: SettingTile(
              onTap: () {
                Get.to<Widget>(() => const YourCard());
              },
              icon: AppAssets.kWallet,
              title: 'Your Card',
            ),
          ),
          FadeAnimation(
            delay: 1,
            child: SettingTile(
              onTap: () {
                Get.to<Widget>(() => const SecurityView());
              },
              icon: AppAssets.kSecurity,
              title: 'Security',
            ),
          ),
          FadeAnimation(
            delay: 1,
            child: SettingTile(
              onTap: () {
                 Get.to<Widget>(() => const NotificationSettingsView());
              },
              icon: AppAssets.kNotification,
              title: 'Notifications',
            ),
          ),
          FadeAnimation(
            delay: 1,
            child: SettingTile(
              onTap: () {
                   Get.to<Widget>(() => const LanguagesView());
              },
              icon: AppAssets.kWorld,
              title: 'Languages',
            ),
          ),
          FadeAnimation(
            delay: 1,
            child: SettingTile(
              onTap: () {
                Get.to<Widget>(()=>const HelpSupportView());
              },
              icon: AppAssets.kInfo,
              title: 'Help and Support',
            ),
          ),
          SizedBox(height: AppSpacing.thirtyVertical),
          FadeAnimation(
            delay: 1,
            child: Center(
              child: CustomTextButton(
                onPressed: () {
                  Get.dialog<void>(LogoutDialog(
                    logoutCallback: () {
                      Get.offAll<Widget>(() => const WelcomeView());
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
    );
  }
}
