import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/modules/auth/selection_view.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:aookamao/user/modules/widgets/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../user/data/constants/app_spacing.dart';
import '../../components/admin_drawer.dart';
import 'components/fade_animation.dart';
import 'components/profile_header_card.dart';

class AdminProfileView extends StatelessWidget {
   const AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final _authservice = Get.find<AuthService>();
    return Scaffold(
      appBar:adminAppBar(Title:'Profile'),
      drawer: AdminDrawer(),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        children: [
          Obx(
          ()=> FadeAnimation(
              delay: 1,
              child:ProfileHeaderCard(user: _authservice.currentUser.value!),
            ),
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
