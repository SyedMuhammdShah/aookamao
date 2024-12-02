import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';

import '../../../constants/constants.dart';
import '../../../enums/user_bank_type.dart';
import '../../../enums/user_roles.dart';
import '../../../modules/auth/components/auth_field.dart';
import '../../../modules/auth/controller/auth_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    _authController.populateUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Personal Info',
          style: AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
        ),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        physics: const BouncingScrollPhysics(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _authController.update_formKey,
          child: Column(
            children: [
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
                isEnable: false,
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

              SizedBox(height: AppSpacing.fiftyVertical),
              Obx(() =>  _authController.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: AppColors.kPrimary,))
                  : PrimaryButton(
                onTap: ()  async {
                  if (_authController.update_formKey.currentState!.validate()) {
                    await _authController.updateUserDetails();
                  }
                },
                text: 'Save Changes',
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
