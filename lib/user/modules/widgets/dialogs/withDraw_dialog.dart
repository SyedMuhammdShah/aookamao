import 'dart:ui';

import 'package:aookamao/modules/auth/components/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_outlined_button.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';

import '../../../controllers/home_controller.dart';

class WithDrawDialog extends StatelessWidget {
  final VoidCallback withDrawCallBack;
  final TextEditingController amountController;
  final double balance;
   WithDrawDialog({required this.withDrawCallBack,super.key, required this.balance, required this.amountController});

  @override
  Widget build(BuildContext context) {
    GlobalKey dialogformKey = GlobalKey<FormState>();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        content: Form(
          key: dialogformKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/with_draw.svg',height: 200.h,),
              SizedBox(height: AppSpacing.twentyVertical),
              Text('WithDraw', style: AppTypography.kSemiBold16),
              SizedBox(height: AppSpacing.fiveVertical),
              Text(
                'Withdraw your money from your wallet',
                style: AppTypography.kMedium14.copyWith(color: AppColors.kGrey60),
              ),
              SizedBox(height: AppSpacing.twentyVertical),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter amount';
                  }
                  if(double.parse(value) < 100){
                    return 'Minimum amount is 100';
                  }
                  if (double.parse(value) > balance) {
                    return 'Insufficient balance';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  hintStyle: AppTypography.kMedium14.copyWith(color: AppColors.kGrey60),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    borderSide: BorderSide(color: AppColors.kSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    borderSide: BorderSide(color: AppColors.kSecondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    borderSide: BorderSide(color: AppColors.kSecondary),
                  ),
                ),
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
                      onTap: () {
                        if ((dialogformKey.currentState as FormState).validate()) {
                          Get.back();
                          withDrawCallBack();
                        }
                      },
                      width: 115.w,
                      borderRadius: 30.r,
                      height: 46.h,
                      fontSize: 14.sp,
                      text: 'Withdraw',
                      color: AppColors.kSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
