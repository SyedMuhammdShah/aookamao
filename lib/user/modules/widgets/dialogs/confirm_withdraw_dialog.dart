import 'dart:ui';

import 'package:aookamao/enums/user_bank_type.dart';
import 'package:aookamao/modules/auth/components/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_outlined_button.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';

import '../../../../services/auth_service.dart';
import '../../../controllers/home_controller.dart';

class ConfirmWithDrawDialog extends StatelessWidget {
  const ConfirmWithDrawDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = Get.find<AuthService>();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/icons/with_draw.svg',height: 200.h,),
            SizedBox(height: AppSpacing.twentyVertical),
            Text('WithDraw Request', style: AppTypography.kSemiBold16),
            SizedBox(height: AppSpacing.fiveVertical),
            Text(
              'Your withdraw request has been submitted to the Admin. You will receive your money in your following account.',
              style: AppTypography.kMedium14.copyWith(),
            ),
            SizedBox(height: AppSpacing.fiftyVertical),
            Text('Your Account Details', style: AppTypography.kSemiBold16),
            SizedBox(height: AppSpacing.fiveVertical),
            Text(
              'Account Holder Name: ${_authService.currentUser.value!.name}',
              style: AppTypography.kMedium14.copyWith(color: AppColors.kGrey60),
            ),
            SizedBox(height: AppSpacing.fiveVertical),
            Text(
              'Account Number: ${_authService.currentUser.value!.accountNumber}',
              style: AppTypography.kMedium14.copyWith(color: AppColors.kGrey60),
            ),
            SizedBox(height: AppSpacing.fiveVertical),
            Text('Bank Name: ${userBankTypeToString(_authService.currentUser.value!.userBankType)}',
              style: AppTypography.kMedium14.copyWith(color: AppColors.kGrey60),
            ),
            
            SizedBox(height: AppSpacing.twentyVertical),
            CustomOutlinedButton(
              onTap: () {
                Get.back<void>();
              },
              width: 115.0.w,
              borderRadius: 30.0.r,
              height: 46.0.h,
              fontSize: 14.0.sp,
              text: 'Close',
            ),
          ],
        ),
      ),
    );
  }
}
