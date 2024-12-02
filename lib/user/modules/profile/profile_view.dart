import 'package:aookamao/modules/auth/signin_view.dart';
import 'package:aookamao/user/modules/my_purchase/my_purchase_view.dart';
import 'package:aookamao/user/modules/tracking/tracking_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/profile/components/fade_animation.dart';
import 'package:aookamao/user/modules/profile/components/profile_header_card.dart';
import 'package:aookamao/user/modules/profile/components/setting_tile.dart';
import 'package:aookamao/user/modules/profile/help_support_view.dart';
import 'package:aookamao/user/modules/profile/languages_view.dart';
import 'package:aookamao/user/modules/profile/notification_settings_view.dart';
import 'package:aookamao/user/modules/profile/security_view.dart';
import 'package:aookamao/user/modules/profile/your_card.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:aookamao/user/modules/widgets/dialogs/logout_dialog.dart';

import '../../../enums/user_roles.dart';
import '../../../modules/auth/selection_view.dart';
import '../../../modules/welcome/welcome_view.dart';
import '../../../services/auth_service.dart';
import '../widgets/dialogs/delete_account_dialog.dart';

class ProfileView extends StatelessWidget {
   const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final _authservice = Get.find<AuthService>();
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
          Obx(
          ()=> FadeAnimation(
              delay: 1,
              child: ProfileHeaderCard(
                 user: _authservice.currentUser.value!,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.thirtyVertical),
          if(_authservice.currentUser.value!.role == UserRoles.user)
          FadeAnimation(
            delay: 1,
            child: SettingTile(
              onTap: () {
                Get.to<Widget>(() => const MyPurchaseView());
              },
              icon: AppAssets.kTruckDelivery,
              title: 'My Purchase',
            ),
          ),
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
          FadeAnimation(
            delay: 1,
            child:  ListTile(
              onTap: () {
                Get.dialog<void>(
                  DeleteAccountDialog(
                    deleteAccountCallback: () async {
                      await _authservice.deleteUserAccount();
                      Get.offAll<Widget>(() => const WelcomeView());
                    },
                  ),
                );
              },
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete, color: AppColors.kError),
              minLeadingWidth: 10.w,
              title: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text("Delete Account", style: AppTypography.kSemiBold14.copyWith(color: AppColors.kError)),
              ),
            )
          ),
          SizedBox(height: AppSpacing.thirtyVertical),
          FadeAnimation(
            delay: 1,
            child: Center(
              child: CustomTextButton(
                onPressed: () {
                  Get.dialog<void>(LogoutDialog(
                    logoutCallback: () async {
                      await _authservice.signOut();
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
    );
  }
}
