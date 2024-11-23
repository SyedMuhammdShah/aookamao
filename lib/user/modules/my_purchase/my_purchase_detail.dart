import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/checkout/components/address_card.dart';
import 'package:aookamao/user/modules/checkout/components/dotted_divider.dart';
import 'package:aookamao/user/modules/checkout/components/drag_sheet.dart';
import 'package:aookamao/user/modules/my_purchase/components/my_purchase_card.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_outlined_button.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:get/get.dart';

import '../../../models/order_model.dart';
import '../../controllers/home_controller.dart';
import '../tracking/tracking_order.dart';

class MyPurchaseDetail extends StatelessWidget {
  final Rx<MyPurchaseModel> productDetails;
  final int orderIndex;
  const MyPurchaseDetail({ Key? key, required this.productDetails, required this.orderIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _homeController = Get.find<HomeController>();
    RxList<Rx<OrderModel>> customerOrdersList = _homeController.customerOrdersList;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Detail',
          style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
        ),
      ),
      body: Obx(() => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: AppSpacing.twentyVertical,
          ),
          child: Column(
            children: [
              MyPurchaseCard(
                myPurchase: productDetails.value,
                isDetailView: true,
              ),
              SizedBox(height: AppSpacing.twentyVertical),
               AddressCard(
                isDetailView: true,
                order: customerOrdersList[orderIndex].value,
              ),
              SizedBox(height: AppSpacing.fiftyVertical),
              Container(
                padding: EdgeInsets.all(2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: AppColors.kLine),
                ),
                child: Row(
                  children: [
                    SizedBox(width: AppSpacing.twelveHorizontal),
                    Text(
                      'Shipping',
                      style: AppTypography.kSemiBold14,
                    ),
                    const Spacer(),
                    PrimaryButton(
                      onTap: ()=>Get.to(()=>TrackingOrder(orderIndex: orderIndex)),
                      text: 'Detail',
                      width: 97.w,
                      height: 36.h,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.fiftyVertical),
               CustomPaymentDetails(
                heading: 'Subtotal',
                amount: productDetails.value.price! * productDetails.value.quantity!,
              ),
              SizedBox(height: AppSpacing.tenVertical),
               CustomPaymentDetails(
                heading: 'Shipping',
                amount: customerOrdersList[orderIndex].value.shippingCharges!,
              ),
              SizedBox(height: AppSpacing.tenVertical),
              const DottedDivider(),
              SizedBox(height: AppSpacing.tenVertical),
               CustomPaymentDetails(
                heading: 'Total Amount',
                amount: productDetails.value.price! * productDetails.value.quantity! + customerOrdersList[orderIndex].value.shippingCharges!,
              ),
              /*const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      onTap: () {},
                      width: 115.0.w,
                      text: 'Rate Now',
                      color: AppColors.kPrimary,
                    ),
                  ),
                  Expanded(
                    child: PrimaryButton(
                      onTap: () {},
                      width: 115.w,
                      text: 'Buy Now',
                    ),
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
