import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../enums/payment_type.dart';
import '../../enums/subscription_status.dart';
import '../../models/subscription_model.dart';
import '../../services/auth_service.dart';
import '../../user/data/constants/app_assets.dart';
import '../../user/data/constants/app_colors.dart';
import '../../user/data/constants/app_spacing.dart';
import '../../user/data/constants/app_typography.dart';
import '../../user/modules/search/components/filter_sheet.dart';
import '../../user/modules/widgets/buttons/primary_button.dart';
import '../../widgets/custom_snackbar.dart';
import '../retailer_modules/subscription/subscription_controller/subscription_controller.dart';

class SubscriptionPayment extends StatelessWidget {
  const SubscriptionPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final _subscriptionController = Get.find<SubscriptionController>();
    final _authService = Get.find<AuthService>();
    return Obx(() =>  Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.kGrey20,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusThirty),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomDivider(),
          SizedBox(height: AppSpacing.thirtyVertical),
          Text(
            'Payment Method',
            style: AppTypography.kSemiBold16,
          ),
          Text('Note: Please share a screenshot after completing your online payment.',style: AppTypography.kSemiBold12.copyWith(color: AppColors.kError)),
          SizedBox(height: AppSpacing.twentyVertical),
          SelectPaymentMethodCard(
            onTap: () =>_subscriptionController.paymentType.value=PaymentType.meezanBank,
            accountHolderName: 'Abdul wahab naveed',
            accountNumber: '10170106543780',
            cardName: 'Meezan Bank',
            icon:'assets/icons/meezan_logo.svg',
            isSelected: _subscriptionController.paymentType.value == PaymentType.meezanBank,
          ),
          SizedBox(height: AppSpacing.twentyVertical),
          SelectPaymentMethodCard(
            onTap: () =>_subscriptionController.paymentType.value=PaymentType.easyPaisa,
            accountHolderName: 'Abdul wahab naveed',
            accountNumber: '03182388024',
            cardName: 'EasyPaisa',
            icon: 'assets/icons/easypaisa_logo.svg',
            isSelected: _subscriptionController.paymentType.value == PaymentType.easyPaisa,
          ),
          SizedBox(height: AppSpacing.twentyVertical),
          SelectPaymentMethodCard(
            onTap: () =>_subscriptionController.paymentType.value=PaymentType.jazzCash,
            accountHolderName: 'Abdul wahab naveed',
            accountNumber:'03042796791',
            cardName: 'JazzCash',
            icon: 'assets/icons/jazz_cash_logo.svg',
            isSelected: _subscriptionController.paymentType.value == PaymentType.jazzCash,
          ),
          SizedBox(height: AppSpacing.twentyVertical),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: (){
                if(_subscriptionController.paymentType.value == null){
                  showErrorSnackbar('Please select a payment method !');
                  return;
                }
                _subscriptionController.sendPaymentSS();},
              label: Text('Share Screenshot', style: AppTypography.kSemiBold14.copyWith(color: AppColors.kWhite)),
              icon: FaIcon(FontAwesomeIcons.whatsapp, color: AppColors.kWhite),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kSuccess,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.twentyVertical),


            PrimaryButton(
              onTap: () {
                if(_subscriptionController.paymentType.value == null){
                  showErrorSnackbar('Please select a payment method !');
                  return;
                }
                SubscriptionModel subscriptiondetails = SubscriptionModel(uid:_authService.currentUser.value!.uid, subscriptionStatus: SubscriptionStatus.pending,subscriptionDate: Timestamp.now());
                _subscriptionController.activateSubscription(subscriptiondetails: subscriptiondetails);

                Get.back();
              },
              text: 'Confirm Payment',
            ),

        ],
      ),
    ),
    );
  }
}

class SelectPaymentMethodCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final String cardName;
  final String icon;
  final String accountHolderName;
  final String accountNumber;
  final bool isCod;
  const SelectPaymentMethodCard({
    required this.onTap,
    required this.isSelected,
    required this.cardName,
    required this.icon,
    required this.accountHolderName,
    this.isCod = false,
    Key? key, required this.accountNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Container(
              height: 60.h,
              width: 60.w,
              padding: EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.kLine,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(width: AppSpacing.tenHorizontal),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardName,
                  style: AppTypography.kSemiBold14,
                ),
                SizedBox(height: AppSpacing.fiveVertical),
                if (isCod)
                  Text(
                    'Pay when you receive the product',
                    style: AppTypography.kMedium14
                        .copyWith(color: AppColors.kGrey70, fontSize: 12.sp),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Account Holder: ',
                            style: AppTypography.kMedium12
                                .copyWith(color: AppColors.kGrey70),
                          ),
                          Text(
                            accountHolderName,
                            style: AppTypography.kSemiBold12,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.fiveVertical),
                      Row(
                        children: [
                          Text(
                            'Account Number: ',
                            style: AppTypography.kMedium12
                                .copyWith(color: AppColors.kGrey70),
                          ),
                          Text(
                            accountNumber,
                            style: AppTypography.kSemiBold12,
                          ),
                          SizedBox(width: AppSpacing.fiveHorizontal),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10.r),
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(text: accountNumber));
                                showSuccessSnackbar('Account number copied');
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.copy,
                                  color: AppColors.kGrey70,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            const Spacer(),
            Container(
              height: 20.h,
              width: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: isSelected ? AppColors.kPrimary : AppColors.kWhite,
                border: Border.all(
                  color: isSelected ? AppColors.kPrimary : AppColors.kLine,
                ),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 12,
                color: AppColors.kWhite,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
