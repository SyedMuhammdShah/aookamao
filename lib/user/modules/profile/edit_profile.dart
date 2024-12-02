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

              SizedBox(height: AppSpacing.fifteenVertical),
              //user bank type
              /*if(_authController.selectedRole.value == UserRoles.user)*/
              Row(
                children: [
                  Text(
                    "Select Bank",
                    style: AppTypography.kMedium16.copyWith(
                      color:  AppColors.kGrey70,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              DropdownButtonFormField<UserBankType>(

                value: _authController.selectedBankType,
                onChanged: (UserBankType? value) {
                  _authController.selectedBankType = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a bank';
                  }
                  return null;
                },
                items: Constants.userBankTypes.map<DropdownMenuItem<UserBankType>>((UserBankType value) {
                  return DropdownMenuItem<UserBankType>(
                    value: value,
                    child: Text(userBankTypeToString(value)!, style: AppTypography.kMedium14),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: 'Select Bank',
                ),
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              AuthField(
                title: 'Account Number',
                hintText: 'Enter your account number',
                controller: _authController.accountNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account number is required';
                  }
                  // Ensure the account number contains only digits
                  final digitsOnly = RegExp(r'^\d+$');
                  if (!digitsOnly.hasMatch(value)) {
                    return 'Please enter a valid account number';
                  }

                  // Check the length of the account number (between 10 and 16 digits)
                  if (value.length < 10 || value.length > 16) {
                    return 'Please enter a valid account number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: AppSpacing.fifteenVertical),
              AuthField(
                title: 'Account Holder Name',
                hintText: 'Enter your account holder name',
                controller: _authController.accountHolderNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account holder name is required';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
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
