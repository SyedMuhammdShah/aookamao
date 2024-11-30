import 'package:aookamao/user/modules/widgets/dialogs/order_confirmed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/checkout/components/address_card.dart';
import 'package:aookamao/user/modules/checkout/components/cart_item_card.dart';
import 'package:aookamao/user/modules/checkout/components/drag_sheet.dart';
import 'package:aookamao/user/modules/checkout/components/payment_method_card.dart';
import 'package:aookamao/user/modules/checkout/components/payment_product_card.dart';
import 'package:aookamao/user/modules/checkout/components/select_payment_method.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:aookamao/user/modules/widgets/dialogs/payment_success_dialog.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/home_controller.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});


  @override
  Widget build(BuildContext context) {
    final _cartController = Get.find<CartController>();
    final _homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Payment',
          style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
        ),
      ),
      body: Obx(() => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: AppSpacing.twentyVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address', style: AppTypography.kSemiBold16),
              SizedBox(height: AppSpacing.tenVertical),
              const AddressCard(),
              SizedBox(height: AppSpacing.fifteenVertical),
              Text(
                'Products (${_cartController.cartItems.length})',
                style: AppTypography.kSemiBold16,
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              ListView.separated(
                itemCount: _cartController.cartItems.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSpacing.twentyVertical),
                itemBuilder: (context, index) {
                  return PaymentProductCard(
                    product: _homeController.productsList[_cartController.cartItems[index].productListIndex],
                    quantity: _cartController.cartItems[index].quantity,
                  );
                },
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              Text(
                'Payment Method',
                style: AppTypography.kSemiBold16,
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              PaymentMethodCard(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSpacing.radiusThirty),
                      ),
                    ),
                    builder: (context) {
                      return const SelectPaymentMethod();
                    },
                  );
                },
              ),

              SizedBox(height: AppSpacing.fifteenVertical),
               CustomPaymentDetails(
                heading: 'Shipping Charges',
                amount: _cartController.shippingCharges.value,
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
               CustomPaymentDetails(
                heading: 'Total Amount',
                amount: _cartController.getTotal(),
                 isTotal: true,
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              _cartController.isLoading.value
                  ?  const Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
                      color: AppColors.kPrimary,
                  ))
                  : PrimaryButton(
                onTap: () =>_cartController.placeOrder(),
                color: _cartController.paymentType.value ==null ? AppColors.kGrey40 : AppColors.kPrimary,
                text: 'Confirm Order',
              ),


            ],
          ),
        ),
      ),
    );
  }
}
