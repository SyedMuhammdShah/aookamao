import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../modules/auth/components/auth_field.dart';
import '../../../user/data/constants/app_colors.dart';
import '../../../user/data/constants/app_typography.dart';
import '../dashboard/controller/admin_dashboard_controller.dart';

class UpdateSubscriprionChargesView extends StatelessWidget {
  const UpdateSubscriprionChargesView({super.key});

  @override
  Widget build(BuildContext context) {
    final _adminController = Get.find<AdminDashboardController>();
    final formKey = GlobalKey<FormState>();
    final subscriptionAmountController = TextEditingController();
    subscriptionAmountController.text = _adminController.supplierSubcriptionCharges.value?.amount.toString() ?? '';
    print('Subscription Amount: ${_adminController.supplierSubcriptionCharges.value?.amount}');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Update Subscription Charges',
            style:
                AppTypography.kSemiBold16.copyWith(color: AppColors.kGrey100),
          ),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            physics: const BouncingScrollPhysics(),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Column(
                  children: [
                    AuthField(
                      title: 'Supplier Subscription Amount',
                      controller: subscriptionAmountController,
                      hintText: 'Subscription Amount',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter subscription amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    Obx(()=>_adminController.isLoading.value
                        ?const Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
                    ))
                        : PrimaryButton(
                      text: 'Update',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          _adminController.updateSubcriptionCharges(subscriptionCharges: double.parse(subscriptionAmountController.text));
                        }
                      },

                    ),
                    ),
                  ],
                ))));
  }
}
