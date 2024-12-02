import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/constants/app_assets.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_spacing.dart';
import '../../../data/constants/app_typography.dart';
import '../buttons/custom_outlined_button.dart';
import '../buttons/primary_button.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback deleteAccountCallback;
  const DeleteAccountDialog({super.key, required this.deleteAccountCallback});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.kHelp),
            SizedBox(height: AppSpacing.twentyVertical),
            Text('Are You Sure?', style: AppTypography.kSemiBold16),
            SizedBox(height: AppSpacing.fiveVertical),
            Text(
              'Do you want to Delete This Account ?',
              style: AppTypography.kSemiBold14.copyWith(color: AppColors.kError),
            ),
            Text(
              'This action cannot be undone!',
              style: AppTypography.kMedium14.copyWith(color: AppColors.kError),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    onTap: () {
                      Get.back<void>();
                    },
                    width: 115.0.w,
                    borderRadius: 30.0.r,
                    height: 46.0.h,
                    fontSize: 14.0.sp,
                    text: 'Cancel',
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    onTap: deleteAccountCallback,
                    color: AppColors.kError,
                    width: 115.w,
                    borderRadius: 30.r,
                    height: 46.h,
                    fontSize: 14.sp,
                    text: 'Delete',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
