import 'package:another_stepper/another_stepper.dart';
import 'package:aookamao/enums/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/tracking/components/custom_tracking_stepper_card.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CustomStepper extends StatelessWidget {
  final Rx<OrderStatus> orderStatus;
  const CustomStepper({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Obx(()=>AnotherStepper(
        stepperList: [
          StepperData(
            title: StepperText(
              'Package delivered',
              textStyle: AppTypography.kSemiBold14,
            ),
            /*subtitle: StepperText(
              'St Jackson, San Francisco',
              textStyle: AppTypography.kLight10
                  .copyWith(color: AppColors.kGrey60, fontSize: 12.sp),
            ),*/
            iconWidget: CustomTrackingStepperCard(icon: AppAssets.kBoxTick,
              color: orderStatus.value == OrderStatus.delivered?AppColors.kPrimary:AppColors.kWhite,
            ),
          ),
          StepperData(
            title: StepperText(
              'Package is being sent',
              textStyle: AppTypography.kSemiBold14,
            ),
            /*subtitle: StepperText(
              'With cargo',
              textStyle: AppTypography.kLight10
                  .copyWith(color: AppColors.kGrey60, fontSize: 12.0.sp),
            ),*/
            iconWidget: CustomTrackingStepperCard(
              icon: AppAssets.kTruckDelivery,
              color: orderStatus.value == OrderStatus.confirmed?AppColors.kPrimary:AppColors.kWhite,
            ),
          ),
          StepperData(
            title: StepperText(
              'Package is processed',
              textStyle: AppTypography.kSemiBold14,
            ),
            /*subtitle: StepperText(
              '',
              textStyle: AppTypography.kLight10
                  .copyWith(color: AppColors.kGrey60, fontSize: 12..sp),
            ),*/
            iconWidget: CustomTrackingStepperCard(icon: AppAssets.kBox,color:orderStatus.value == OrderStatus.pending?AppColors.kPrimary:AppColors.kWhite),
          ),
          StepperData(
            title: StepperText(
              'Order is confirmed',
              textStyle: AppTypography.kSemiBold14,
            ),
           /* subtitle: StepperText(
              '',
              textStyle: AppTypography.kLight10
                  .copyWith(color: AppColors.kGrey60, fontSize: 12),
            ),*/
            iconWidget: CustomTrackingStepperCard(icon: AppAssets.kFileText,color: AppColors.kPrimary,iconColor: Colors.black,),
          ),
        ],
        stepperDirection: Axis.vertical,
        iconWidth: 40,
        iconHeight: 40,
        activeBarColor: AppColors.kLine,
        inActiveBarColor: AppColors.kLine,
        verticalGap: 30,
        activeIndex: 1,
        barThickness: 1,
      ),
    );
  }
}
