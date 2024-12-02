import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/profile/edit_profile.dart';

import '../../../../enums/user_roles.dart';
import '../../../../models/user_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserModel user;
  const ProfileHeaderCard({ required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40.r,
           backgroundColor: AppColors.kGrey20,
           child: Icon(
            Icons.person,
            size: 40.r,
            color: AppColors.kGrey60,),

        ),
        SizedBox(
          width: AppSpacing.tenHorizontal,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(user.name, style: AppTypography.kSemiBold18),
          SizedBox(height: AppSpacing.fiveVertical),
          Text(
            user.role == UserRoles.user ? 'Customer' : user.role == UserRoles.retailer ? 'Suppiler':'',
            style: AppTypography.kMedium14.copyWith(
              color: AppColors.kGrey60,
            ),
          ),
        ],),
        const Spacer(),
        IconButton(
          icon: SvgPicture.asset(AppAssets.kEdit),
          onPressed: () {
            Get.to<Widget>(()=>const EditProfile());
          },
        ),
      ],
    );
  }
}
