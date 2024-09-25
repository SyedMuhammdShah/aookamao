
import 'package:aookamao/app/modules/auth/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/app/data/constants/constants.dart';
import 'package:aookamao/app/modules/auth/components/components.dart';
import 'package:aookamao/app/modules/widgets/buttons/primary_button.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AuthAppBar(),
      body:  SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child:  Center(
            child: Column(
              children: [
                // Title
                Text('Create Account', style: AppTypography.kBold24),
                SizedBox(height: AppSpacing.fiveVertical),
                // Subtitle
                Text(
                  'Lorem ipsum dolor sit amet, consectetur',
                  style: AppTypography.kMedium14.copyWith(
                    color: AppColors.kGrey60,
                  ),
                ),
                SizedBox(height: AppSpacing.thirtyVertical),

                // Full Name Field
                AuthField(
                  title: 'Full Name',
                  hintText: 'Enter your name',
                  controller: authController.nameController,
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
                  controller: authController.emailController,
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

                // Address Field
                AuthField(
                  title: 'Address',
                  hintText: 'Enter your address',
                  controller: authController.addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.fifteenVertical),

                // Password Field
                AuthField(
                  title: 'Password',
                  hintText: 'Enter your password',
                  controller: authController.passwordController,
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
                SizedBox(height: AppSpacing.thirtyVertical),

                // Submit Button
                PrimaryButton(
                  onTap: () {
                 
                      authController.registerUser();
                  
                  },
                  text: 'Create An Account',
                ),

                SizedBox(height: AppSpacing.thirtyVertical),

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
                ),

                SizedBox(height: AppSpacing.twentyVertical),

                // Terms and Conditions
                const AgreeTermsTextCard(),
              ],
            ),
          ),
        
      ),
    );
  }
}
