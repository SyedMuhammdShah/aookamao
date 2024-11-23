import 'package:aookamao/enums/order_status.dart';
import 'package:aookamao/models/order_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/my_purchase/my_purchase_detail.dart';
import 'package:aookamao/user/modules/tracking/tracking_order.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_outlined_button.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';

class MyPurchaseCard extends StatelessWidget {
  final MyPurchaseModel myPurchase;
  final bool isDetailView;
  const MyPurchaseCard({
    required this.myPurchase,
    this.isDetailView = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusTen),
        border: Border.all(
          color: AppColors.kLine,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: CachedNetworkImage(
                imageUrl: myPurchase.imageUrl??'',
                height: 71.h,
                width: 71.w,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                     CircularProgressIndicator(value: downloadProgress.progress, color: AppColors.kPrimary),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
              SizedBox(width: AppSpacing.tenHorizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myPurchase.productName??'',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.kMedium16,
                    ),
                    Text(
                      'Qty: ${myPurchase.quantity}',
                      style: AppTypography.kMedium14
                          .copyWith(color: AppColors.kGrey70, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if(myPurchase.orderStatus == OrderStatus.pending)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0.r),
                        border: Border.all(color: AppColors.kWarning),
                      ),
                      child: Text(
                        'Processing',
                        style: AppTypography.kLight10
                            .copyWith(color: AppColors.kWarning),
                      ),
                    ),
                    if(myPurchase.orderStatus == OrderStatus.delivered)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0.r),
                        border: Border.all(color: AppColors.kSuccess),
                      ),
                      child: Text(
                        'Delivered',
                        style: AppTypography.kLight10
                            .copyWith(color: AppColors.kSuccess),
                      ),
                    ),
                    if(myPurchase.orderStatus == OrderStatus.cancelled)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0.r),
                        border: Border.all(color: AppColors.kError),
                      ),
                      child: Text(
                        'Cancelled',
                        style: AppTypography.kLight10
                            .copyWith(color: AppColors.kError),
                      ),
                    ),
                    if(myPurchase.orderStatus == OrderStatus.confirmed)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0.r),
                        border: Border.all(color: AppColors.kBlue),
                      ),
                      child: Text(
                        'On Process',
                        style: AppTypography.kLight10
                            .copyWith(color: AppColors.kBlue),
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    RichText(
                      text: TextSpan(
                        text: 'Rs.',
                        style: AppTypography.kMedium14.copyWith(
                          color: AppColors.kGrey100,
                          fontSize: 12.sp,
                        ),
                        children: [
                          TextSpan(
                            text: '${myPurchase.price}',
                            style: AppTypography.kSemiBold16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.twentyVertical),
          if (!isDetailView)
            Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    onTap: () {
                      Get.to<Widget>(() => MyPurchaseDetail(
                         productDetails: myPurchase.obs,
                        orderIndex: myPurchase.indexOfOrder,
                          ));
                    },
                    width: 115.0.w,
                    borderRadius: 30.0.r,
                    height: 40.0.h,
                    fontSize: 13.0.sp,
                    text: 'Detail',
                    color: AppColors.kPrimary,
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    onTap: () {
                      Get.to<Widget>(() =>  TrackingOrder(orderIndex:myPurchase.indexOfOrder));
                    },
                    width: 115.w,
                    borderRadius: 30.r,
                    height: 40.h,
                    fontSize: 13.sp,
                    text: 'Tracking',
                  ),
                ),
              ],
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}

