import 'package:animate_do/animate_do.dart';
import 'package:aookamao/user/data/constants/app_assets.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/modules/auth/signin_view.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:aookamao/retailer/retailer_modules/auth/retailer_signin_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum UserType { retailer, customer }

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
            color: isSelected ? AppColors.kPrimary : AppColors.kWhite,
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
  final void Function(UserType)? onUserTypeSelected;
  const SelectionScreen({super.key, this.onUserTypeSelected});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  UserType userType = UserType.retailer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 50),
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 30),
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
                          setState(() {
                            userType = UserType.retailer;
                          });
                          widget.onUserTypeSelected?.call(userType);
                        },
                        isSelected: userType == UserType.retailer,
                        image: AppAssets.retailerIcon,
                        text: UserType.retailer.name.capitalizeFirst.toString(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: UserTypeCard(
                        onTap: () {
                          setState(() {
                            userType = UserType.customer;
                          });
                          widget.onUserTypeSelected?.call(userType);
                        },
                        isSelected: userType == UserType.customer,
                        image: AppAssets.customerIcon,
                        text: UserType.customer.name.capitalizeFirst.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              onTap: () {
                // Registration logic here if needed
              },
              text: 'Registration',
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              onTap: () {
                if (userType == UserType.retailer) {
                  Get.to<Widget>(() => RetailerSignInView());
                } else if (userType == UserType.customer) {
                  Get.to<Widget>(() => SignInView());
                }
              },
              text: 'Login',
            ),
            const Spacer(),
          ],
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
