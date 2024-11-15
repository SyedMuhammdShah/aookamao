import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:get/get.dart';

class QuantityCard extends StatelessWidget {

  //final Function(int quantity) onChanged;
  final RxInt quantity;
  final int stockQuantity;
  const QuantityCard({
   // required this.onChanged,
    required this.quantity,
    super.key, required this.stockQuantity,
  });

  void increment() {
    print('stockQuantity: $stockQuantity');
    if (quantity < stockQuantity) {
      quantity.value++;
     // onChanged(quantity.value);
    }
    else{
      showErrorSnackbar('Stock quantity exceeded!');
    }
  }

  void decrement() {
      if (quantity > 1) {
        quantity.value--;
      //onChanged(quantity.value);
      }
      else{
        showErrorSnackbar('Quantity cannot be less than 1!');
      }
  }
  @override
  Widget build(BuildContext context) {
    return Obx(()=> Container(
        padding: EdgeInsets.all(3.h),
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: decrement,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    //padding: EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                      color: AppColors.kWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7.0.w),
            Text(
              quantity.value.toString(),
              style: AppTypography.kSemiBold14,
            ),
            SizedBox(width: 7.w),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: increment,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.kWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
