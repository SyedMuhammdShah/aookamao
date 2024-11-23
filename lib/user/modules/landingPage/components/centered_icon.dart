import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aookamao/user/data/constants/constants.dart';

class CenteredIcon extends StatelessWidget {
  final bool isSelected;
  const CenteredIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.h),
      margin: EdgeInsets.only(top: 5.h),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.kPrimary,
            AppColors.kWhite,
            AppColors.kPrimary,
          ],
        ),
      ),
      child: Container(
        height: 50.h,
        width: 50.w,
        padding: EdgeInsets.all(13.h),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.kPrimary,
        ),
        child: isSelected?Icon(CupertinoIcons.gift_fill, color: AppColors.kWhite):Icon(CupertinoIcons.gift, color: AppColors.kWhite),
      ),
    );
  }
}
