import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:aookamao/user/modules/widgets/gradients/custom_gradient_card.dart';

import '../auth/selection_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.kOnboardingThird),
            fit: BoxFit.cover,
          ),
        ),
        child: CustomGradientCard(
          gradient: AppColors.customOnboardingGradient,
          child: Column(
            children: [
              const Spacer(),
              RichText(
                text: TextSpan(
                  text: "Welcome to ",
                  style: AppTypography.kSemiBold24
                      .copyWith(color: AppColors.kWhite),
                  children: [
                    TextSpan(
                      text: 'Aookamao',
                      style: AppTypography.kSemiBold24
                          .copyWith(color: AppColors.kPrimary),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.tenVertical),
              Text(
                'The best way to buy and sell products',
                textAlign: TextAlign.center,
                style:
                    AppTypography.kMedium14.copyWith(color: AppColors.kWhite),
              ),
              SizedBox(height: AppSpacing.thirtyVertical),
              PrimaryButton(
                onTap: () {
                  Get.to<Widget>(() => const SelectionScreen());
                },
                text: 'Get Started',
              ),
              SizedBox(height: AppSpacing.twentyVertical),
              /*RichText(
                text: TextSpan(
                  text: 'Don’t have an account? ',
                  style: AppTypography.kSemiBold16
                      .copyWith(color: AppColors.kWhite),
                  children: [
                    TextSpan(
                      text: 'Register',
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
              SizedBox(height: AppSpacing.thirtyVertical),*/
            ],
          ),
        ),
      ),
    );
  }
}
