import 'package:aookamao/modules/auth/controller/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';

import 'components/agree_terms_text_card.dart';
import 'components/auth_appbar.dart';
import 'components/auth_field.dart';
import 'components/remember_me_card.dart';
import 'forget_password.dart';
import 'signup_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AuthAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Text('Sign you in', style: AppTypography.kBold24),
                SizedBox(height: AppSpacing.fiveVertical),
                Text(
                  'Sign in to your account to continue',
                  style: AppTypography.kMedium14.copyWith(
                    color: AppColors.kGrey60,
                  ),
                ),
                SizedBox(height: AppSpacing.thirtyVertical),
                // Email Field.
                AuthField(
                  title: 'Email Address',
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
                // Password Field.
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
                SizedBox(height: AppSpacing.tenVertical),
                Row(
                    children: [
                      RememberMeCard(
                        onChanged: (value) {
                          _authController.isRemember.value = value;
                        },
                      ),
                      /*const Spacer(),
                      CustomTextButton(
                        onPressed: () {
                          Get.to<Widget>(() => const ForgetPassword());
                        },
                        text: 'Forget Password',
                      ),*/
                    ],
                  ),
                SizedBox(height: AppSpacing.fifteenVertical),
               Obx(()=> _authController.isLoading.value ?
               const Center(child: CircularProgressIndicator(color: AppColors.kPrimary,)) :
                PrimaryButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                       _authController.loginUser();
                      // Get.to<Widget>(() => const ChooseInterestView());
                    }
                  },
                  text: 'Sign In',
                ),
               ),
                SizedBox(height: AppSpacing.twentyVertical),
                RichText(
                  text: TextSpan(
                    text: 'Don’t have an account? ',
                    style: AppTypography.kSemiBold16
                        .copyWith(color: AppColors.kGrey70),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to<Widget>(() => const SignUpView());
                          },
                        style: AppTypography.kSemiBold16
                            .copyWith(color: AppColors.kPrimary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.twentyVertical),

                const AgreeTermsTextCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
