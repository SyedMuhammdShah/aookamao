import 'package:aookamao/enums/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/tracking/components/custom_stepper.dart';
import 'package:aookamao/user/modules/tracking/tracking_detail.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_outlined_button.dart';

import '../../../models/order_model.dart';
import '../../controllers/home_controller.dart';

class TrackingOrder extends StatelessWidget {
  final int orderIndex;
  const TrackingOrder({super.key, required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    final _homeController = Get.find<HomeController>();
    print('orderIndex: $orderIndex');
    RxList<Rx<OrderModel>> customerOrdersList = _homeController.customerOrdersList;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tracking',
          style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
        ),
      ),
      body: Obx(() => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: AppSpacing.twentyVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(24.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.kLine),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(AppAssets.kTruckDelivery),
                        SizedBox(width: AppSpacing.twentyHorizontal),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${customerOrdersList[orderIndex].value.orderId}',
                              style:
                                  AppTypography.kBold18.copyWith(fontSize: 14.sp),
                            ),
                            SizedBox(height: 2.h),
                            //order status
                            if(customerOrdersList[orderIndex].value.orderStatus ==OrderStatus.pending)
                            Text(
                              'Pending',
                              style: AppTypography.kSemiBold12
                                  .copyWith(color: AppColors.kWarning),
                            ),
                            if(customerOrdersList[orderIndex].value.orderStatus ==OrderStatus.confirmed)
                              Text(
                                'Processing',
                                style: AppTypography.kSemiBold12
                                    .copyWith(color: AppColors.kBlue),
                              ),
                            if(customerOrdersList[orderIndex].value.orderStatus ==OrderStatus.delivered)
                            Text(
                              'Delivered',
                              style: AppTypography.kSemiBold12
                                  .copyWith(color: AppColors.kSuccess),
                            ),
                            if(customerOrdersList[orderIndex].value.orderStatus ==OrderStatus.cancelled)
                            Text(
                              'Cancelled',
                              style: AppTypography.kSemiBold12
                                  .copyWith(color: AppColors.kError),
                            ),

                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: AppColors.kGrey70,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimate delivery',
                              style: AppTypography.kMedium14.copyWith(
                                color: AppColors.kGrey80,
                                fontSize: 12.sp,
                              ),
                            ),
                            Text(
                              '',
                              style: AppTypography.kBold18
                                  .copyWith(fontSize: 14..sp),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shipment',
                              style: AppTypography.kMedium14.copyWith(
                                color: AppColors.kGrey80,
                                fontSize: 12..sp,
                              ),
                            ),
                            Text(
                              'Standard',
                              style: AppTypography.kBold18
                                  .copyWith(fontSize: 14.0.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    /*CustomOutlinedButton(
                      onTap: () {
                        Get.to<Widget>(() => const TrackingDetail());
                      },
                      text: 'Receipt Payment',
                      color: AppColors.kPrimary,
                    ),*/
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.thirtyVertical),
              Text(
                'Delivery Status',
                style: AppTypography.kSemiBold16,
              ),
               CustomStepper(
                orderStatus: customerOrdersList[orderIndex].value.orderStatus!.obs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
