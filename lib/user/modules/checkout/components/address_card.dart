import 'package:aookamao/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';

import '../../../controllers/cart_controller.dart';

class AddressCard extends StatelessWidget {
  final bool isDetailView;
  final OrderModel? order;
  const AddressCard({this.isDetailView = false, super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final _cartController = Get.find<CartController>();

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusTwenty),
        border: Border.all(color: AppColors.kLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.h,
            width: 40.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kLine,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.kGrey100,
            ),
          ),
          SizedBox(width: AppSpacing.tenHorizontal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isDetailView?order!.customerName??"" :_cartController.nameController.text, style: AppTypography.kSemiBold14, overflow: TextOverflow.ellipsis, maxLines: 1),
                SizedBox(height: AppSpacing.tenVertical),
                Text(isDetailView?order!.customerAddress??"" : _cartController.addressController.text,style: AppTypography.kMedium14.copyWith(
                    color: AppColors.kGrey60,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: AppSpacing.tenVertical),
                Text(isDetailView?order!.customerPhone??"" :
                  _cartController.phoneController.text,
                  style: AppTypography.kMedium14,
                ),
              ],
            ),
          ),
          if (!isDetailView)
            IconButton(
              onPressed: () {
                Get.back<void>();
              },
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(AppAssets.kEditIcon),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
