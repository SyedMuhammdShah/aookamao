import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/checkout/cart_view.dart';
import 'package:aookamao/user/modules/notification/notification_view.dart';

import '../../models/user_model.dart';


class adminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? user;// Changed from user_name to user
  final String? Title;
  const adminAppBar({
    this.user, // required user data
    super.key, this.Title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //leadingWidth: 60.w,
      title:
      Title != null ? Text(Title!, style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),) :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Text(
            'Welcome,', // Static text
            style: AppTypography.kLight10.copyWith(color: AppColors.kGrey80),
          ),
          Text(
            user!.name, // Display the user's name dynamically
            style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
          ),

        ],
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

class CustomIcons extends StatelessWidget {
  final String icon;
  final FaIcon? ficon;
  final VoidCallback onTap;
  const CustomIcons({required this.icon, required this.onTap, super.key, this.ficon});

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
        child: ficon ?? SvgPicture.asset(icon),
      ),
    );
  }
}
