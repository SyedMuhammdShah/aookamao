import 'package:animate_do/animate_do.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/user/data/constants/app_assets.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller/auth_controller.dart';
import 'signin_view.dart';


class UserTypeCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isSelected;
  final String image;
  const UserTypeCard({
    required this.onTap,
    required this.isSelected,
    required this.text,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedButton(
        onTap: onTap,
        child: Container(
          width: 160,
          height: 230,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? AppColors.kSecondary : AppColors.kWhite,
            boxShadow: [AppColors.defaultShadow],
          ),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.kWhite : AppColors.kSecondary,
                ),
              ),
              const Spacer(),
              Image.asset(image),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
 final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 0.05.sh),
              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'Join Us',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kSecondary),
                ),
              ),
               SizedBox(height: 0.02.sh),
              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'Select ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kSecondary),
                ),
              ),
              SizedBox(height: 0.15.sh),
              FadeInRight(
                duration: const Duration(milliseconds: 1000),
                child: SizedBox(
                  height: 320,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: UserTypeCard(
                          onTap: () {
                            _authController.selectedRole(UserRoles.retailer);
                          },
                          isSelected: _authController.selectedRole.value == UserRoles.retailer,
                          image: AppAssets.retailerIcon,
                          text: "Retailer",
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: UserTypeCard(
                          onTap: () {
                            _authController.selectedRole(UserRoles.user);
                          },
                          isSelected: _authController.selectedRole.value == UserRoles.user,
                          image: AppAssets.customerIcon,
                          text:"Customer",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               Spacer(),
             PrimaryButton(
                onTap: () {
                  Get.to<Widget>(() => const SignInView());
                },
                text: 'Next',
              ),

              SizedBox(height: 0.05.sh),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const AnimatedButton({required this.child, required this.onTap, super.key});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
