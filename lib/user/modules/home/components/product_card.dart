import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/home/components/custom_like_button.dart';
import 'package:aookamao/user/modules/home/product_detail_view.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to<Widget>(() => ProductDetailView(product: product));
      },
      child: Column(
        children: [
          Hero(
            tag: product.id,
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
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 150.h,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        // Handle image change if needed
                      },
                    ),
                    items: product.imageUrls.map((imageUrl) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
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
                          product.offPercentage,
                          style: AppTypography.kSemiBold10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: SizedBox(
                      height: 20.h,
                      child: CustomLikeButton(
                        product: product,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.kSemiBold12,
          ),
          SizedBox(height: AppSpacing.fiveVertical),
          RichText(
            text: TextSpan(
              text: '\$${product.oldPrice.toInt()}  ',
              style: AppTypography.kLight10.copyWith(color: AppColors.kGrey60),
              children: [
                TextSpan(
                  text: '\$${product.currentPrice.toInt()}',
                  style: AppTypography.kSemiBold14
                      .copyWith(color: AppColors.kGrey100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
