import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/home/components/custom_like_button.dart';
import 'package:aookamao/user/modules/home/product_detail_view.dart';

class ProductCard extends StatelessWidget {
  final Rx<ProductModel> product;
  final int productListIndex;
  const ProductCard({required this.product, super.key, required this.productListIndex});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  GestureDetector(
        onTap: () {
          Get.to<Widget>(() => ProductDetailView(productListIndex:productListIndex));
        },
        child: Column(
          children: [
            Hero(
              tag: product.value.productId ?? '',
              child: Container(
                height: 167.h,
                width: 153.w,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child:CachedNetworkImage(
                        imageUrl: product.value.imageUrls?[0] ?? '',
                        fit: BoxFit.cover,
                        height: 167.h,
                        width: 153.w,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>  Center(
                          child: CircularProgressIndicator(backgroundColor: AppColors.kPrimary, value: downloadProgress.progress),
                        ),

                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    ),
                    /*Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            product.value.offPercentage,
                            style: AppTypography.kSemiBold10,
                          ),
                        ),
                      ),
                    ),*/
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: SizedBox(
                        height: 20.h,
                        child: CustomLikeButton(
                          product: product.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              product.value.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.kSemiBold12,
            ),
            SizedBox(height: AppSpacing.fiveVertical),
            Text(
              '\Rs ${product.value.price?.toInt()}',
              style: AppTypography.kSemiBold14
                  .copyWith(color: AppColors.kGrey100),
            ),
          ],
        ),
      ),
    );
  }
}
