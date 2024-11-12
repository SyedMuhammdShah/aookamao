import 'package:aookamao/modules/auth/components/auth_appbar.dart';
import 'package:aookamao/modules/auth/components/auth_field.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../user/modules/widgets/buttons/primary_button.dart';
import 'controller/auth_controller.dart';

class ReferralView extends StatelessWidget {
  const ReferralView({super.key});

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
      return Scaffold(
        appBar:AuthAppBar(),
        body:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _authController.referral_formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/referral.svg'),
                Text(
                  'Use a Referral Code',
                  style: AppTypography.kBold24
                ),
                SizedBox(height: 0.01.sh),
                Text(
                  'Enter a referral code below to earn rewards and start saving on your next purchase!',
                  style: AppTypography.kMedium14.copyWith(
                    color: AppColors.kGrey70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 0.01.sh),
                AuthField(
                  title: '',
                  controller: TextEditingController(),
                  keyboardType: TextInputType.text,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Referral code is required!';
                    }
                    if(value.length < 6){
                      return 'Invalid referral code!';
                    }
                    return null;
                  }, hintText: 'Enter referral code',
                ),
                SizedBox(height: 0.05.sh),
                PrimaryButton(
                 text: 'Submit',
                  onTap: () {},
                ),
                SizedBox(height: 0.05.sh),
                CustomTextButton(
                  text: 'Skip for now',
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      );
    }
  }
