import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/checkout/components/location_card.dart';
import 'package:aookamao/user/modules/checkout/payment_view.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:aookamao/user/modules/widgets/textfields/search_field.dart';

import '../../../constants/constants.dart';
import '../../../modules/auth/components/auth_field.dart';
import '../../controllers/cart_controller.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
 final _cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Address',
          style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: AppSpacing.twentyVertical,
        ),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _cartController.addressFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthField(
                controller: _cartController.nameController,
                hintText: 'Enter you name',
                title: 'Your Name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              AuthField(
                controller: _cartController.phoneController,
                hintText: '+92 334137345',
                title: 'Your Phone',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your City',
                    style: AppTypography.kMedium16.copyWith(
                      color: AppColors.kGrey70,
                    ),
                  ),
                  SizedBox(height: AppSpacing.fiveVertical),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Your City',
                      hintStyle: AppTypography.kSemiBold14.copyWith(color: AppColors.kGrey60),
                      fillColor: const Color(0xFFF6F6F6),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.twentyHorizontal,
                        vertical: 18.h,
                      ),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusThirty),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.kPrimary),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusThirty),
                      ),
                      border: OutlineInputBorder(

                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusThirty),
                      ),
                    ),
                    items: Constants.orderCities
                        .map(
                          (city) => DropdownMenuItem(
                            value: city,
                            child: Text(
                              city,
                              style: AppTypography.kMedium14.copyWith(
                                color: AppColors.kGrey70,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => _cartController.selectedCity.value = value??'',
                  validator: (value) {
                    if (value == null) {
                      return 'Select your city';
                    }
                    return null;
                  },
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              AuthField(
                controller: _cartController.addressController,
                hintText: 'Enter your address',
                title: 'Your Address',
                maxLines: 6,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.twentyVertical),


            /*  Text('Select Location', style: AppTypography.kSemiBold16),
              SizedBox(height: AppSpacing.fifteenVertical),
              SearchField(
                controller: _locationSearchController,
                hintText: 'Search Location',
                isFilterIcon: false,
                filterCallback: () {},
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              const LocationCard(),
              SizedBox(height: AppSpacing.twentyVertical),*/
              PrimaryButton(
                onTap: () {
                  if (_cartController.addressFormKey.currentState!.validate()) {
                    Get.to<Widget>(() => const PaymentView());
                  }
                },
                text: 'Confirm',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
