import 'package:aookamao/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/notification/notification_view.dart';


class RetailerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user; // Changed from user_name to user
  final String? title;
  const RetailerAppBar({
    required this.user, // required user data
    this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60.w,
      //backgroundColor: AppColors.kPrimary,
      // leading: GestureDetector(
      //   onTap: () {
      //     Get.to<Widget>(() => const EditProfile());
      //   },
      //   child: Padding(
      //     padding: EdgeInsets.only(
      //       left: 10.w,
      //       top: 5.h,
      //     ),
      //     // You can add a profile image here if available
      //   ),
      // ),
      /*title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            user.name, // Display the user's name dynamically
            style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
          ),
          Text(
            user.email,
            style: AppTypography.kLight10.copyWith(color: AppColors.kGrey80),
          ),
        ],
      ),*/

      centerTitle: true,
      title: Text(
        title ?? '',
        style: AppTypography.kSemiBold18.copyWith(color: AppColors.kGrey100),
      ),
      actions: [

        CustomIcons(
          onTap: () {
            Get.to<Widget>(() => const NotificationView());
          },
          icon: AppAssets.kNotification,
        ),
        SizedBox(width: 20.0.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

//referal reward balance widget
 Widget referalRewardBalance() {
    return Container(
      height: 44.h,
      //width: 44.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: const BoxDecoration(
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xffF6F6F6),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wallet,
            color: AppColors.kGrey100,
            size: 20.r,
          ),
          SizedBox(width: 5.w),
          Text(
            '0.00',
            style: AppTypography.kSemiBold12.copyWith(color: AppColors.kGrey100),
          ),
        ],
      ),
    );
  }

class CustomIcons extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const CustomIcons({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        width: 44.w,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffF6F6F6),
        ),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
