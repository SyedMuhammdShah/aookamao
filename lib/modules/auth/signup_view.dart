
import 'dart:io';

import 'package:aookamao/modules/auth/controller/auth_controller.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../enums/user_roles.dart';
import 'components/cnic_textfield.dart';
import 'components/image_picker.dart';
import 'components/agree_terms_text_card.dart';
import 'components/auth_appbar.dart';
import 'components/auth_field.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final  _authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AuthAppBar(),
      body:  SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child:  Center(
            child: Form(
              key: _authController.signup_formKey,
              autovalidateMode:AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // Title
                  Text('Create Account', style: AppTypography.kBold24),
                  SizedBox(height: AppSpacing.fiveVertical),
                  // Subtitle
                  Text(
                    'Create an account as a ${_authController.selectedRole.value == UserRoles.retailer ? 'Retailer' : 'User'}',
                    style: AppTypography.kMedium14.copyWith(
                      color: AppColors.kGrey60,
                    ),
                  ),
                  SizedBox(height: AppSpacing.thirtyVertical),

                  // Full Name Field
                  AuthField(
                    title: 'Full Name',
                    hintText: 'Enter your name',
                    controller: _authController.nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.fifteenVertical),

                  // Email Field
                  AuthField(
                    title: 'E-mail',
                    hintText: 'Enter your email address',
                    controller: _authController.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!value.isEmail) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.fifteenVertical),
                  //address Field
                  if(_authController.selectedRole.value == UserRoles.user)
                  AuthField(
                    title: 'Address',
                    hintText: 'Enter your address',
                    controller: _authController.addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  // Password Field
                  AuthField(
                    title: 'Password',
                    hintText: 'Enter your password',
                    controller: _authController.passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 8) {
                        return 'Password should be at least 8 characters long';
                      }
                      return null;
                    },
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: AppSpacing.fifteenVertical),

                  AuthField(
                    title: 'Confirm Password',
                    hintText: 'Enter your password',
                    controller: _authController.confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required';
                      } else if (_authController.passwordController.text != value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: AppSpacing.fifteenVertical),
                  if(_authController.selectedRole.value == UserRoles.retailer)
                  Column(
                    children: [
                      CNICTextField(
                        title: "CNIC number",
                        controller: _authController.cnicController,
                        validator:(value) {
                          // Check if the value is empty
                          if (value == null || value.isEmpty) {
                            return 'CNIC number is required';
                          }

                          // Check if the CNIC matches the pattern "#####-#######-#"
                          final cnicPattern = RegExp(r'^\d{5}-\d{7}-\d{1}$');
                          if (!cnicPattern.hasMatch(value)) {
                            return 'Enter a valid CNIC (#####-#######-#)';
                          }

                          return null; // Valid CNIC
                        }),

                  SizedBox(height: AppSpacing.fifteenVertical),
                      Row(
                        children: [
                          Text(
                            "Upload Documents",
                            style: AppTypography.kMedium16.copyWith(
                              color:  AppColors.kGrey70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      Obx(() =>  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImagePickerDashed(onaddpressed: ()=>_showbottomsheet(isFront: true), title: 'CNIC Front', imagefile:_authController.cnicFrontFile.value, onremovepressed: ()=>_authController.removeCnicImage(isFront: true),),
                            SizedBox(width: AppSpacing.fifteenHorizontal),
                            ImagePickerDashed(onaddpressed: ()=>_showbottomsheet(isFront: false), title: 'CNIC Back', imagefile:_authController.cnicBackFile.value, onremovepressed: () =>_authController.removeCnicImage(isFront: false),),

                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.thirtyVertical),
                  // Submit Button
                  Obx(() =>  _authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator(color: AppColors.kPrimary,))
                        : PrimaryButton(
                      onTap: () async {
                        if(_authController.signup_formKey.currentState!.validate()){
                          if (_authController.selectedRole.value == UserRoles.retailer) {
                            if(_authController.cnicFrontFile.value.path.isEmpty || _authController.cnicBackFile.value.path.isEmpty){
                              showErrorSnackbar('Please upload Required Documents');
                              return;
                            }
                            await _authController.registerRetailer();
                          }
                          else if(_authController.selectedRole.value == UserRoles.user){
                            await _authController.registerUser();
                          }
                        }

                      },
                      text: 'Create An Account',
                    ),
                  ),

                 /* SizedBox(height: AppSpacing.thirtyVertical),

                  // Divider and Social Login Buttons
                  const TextWithDivider(),
                  SizedBox(height: AppSpacing.twentyVertical),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomSocialButton(
                        onTap: () {},
                        icon: AppAssets.kGoogle,
                      ),
                      CustomSocialButton(
                        onTap: () {},
                        icon: AppAssets.kApple,
                      ),
                      CustomSocialButton(
                        onTap: () {},
                        icon: AppAssets.kFacebook,
                      ),
                    ],
                  ),*/

                  SizedBox(height: AppSpacing.twentyVertical),

                  // Terms and Conditions
                  const AgreeTermsTextCard(),
                ],
              ),
            ),
          ),
        
      ),
    );

  }

}
void _showbottomsheet({required bool isFront}){
  final AuthController authController = Get.find<AuthController>();
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          Text(
            'Choose an option',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Get.back();
              authController.pickCnicImage(isFront: isFront,imagesource: ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Camera'),
            onTap: () {
              Get.back();
              authController.pickCnicImage(isFront: isFront,imagesource: ImageSource.camera);
            },
          ),
        ],
      ),
    ),
  );
}
