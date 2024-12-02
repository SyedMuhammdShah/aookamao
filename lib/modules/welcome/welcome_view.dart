import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:aookamao/user/modules/widgets/gradients/custom_gradient_card.dart';

import '../../constants/constants.dart';
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
              Row(
                children: [
                  SizedBox(
                    width: ScreenUtil().screenWidth * 0.32,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Welcome to ', style: AppTypography.kSemiBold24
                          .copyWith(color: AppColors.kWhite),),
                    ),
                  ),
                  SizedBox(width: AppSpacing.fiveHorizontal),
                  SvgPicture.asset('assets/icons/splash_icon2.svg',width: ScreenUtil().screenWidth * 0.5),
                ],
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
                color: AppColors.kSecondary,
                onTap: () {
                  Get.to<Widget>(() => const SelectionScreen());
                },
                text: 'Get Started',
              ),
              SizedBox(height: AppSpacing.twentyVertical),
            ],
          ),
        ),
      ),
    );
  }
}
