import 'package:aookamao/app/modules/auth/auth/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:aookamao/app/data/constants/constants.dart';
import 'package:aookamao/app/models/product_model.dart';
import 'package:aookamao/app/models/user_model.dart';
import 'package:aookamao/app/modules/home/components/banner_card.dart';
import 'package:aookamao/app/modules/home/components/home_appbar.dart';
import 'package:aookamao/app/modules/home/components/product_card.dart';
import 'package:aookamao/app/modules/widgets/buttons/custom_text_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../data/helpers/product_category.dart';
import '../../data/helpers/product_filter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  
  get dummyUser => null;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: HomeAppBar(
        user: authController.currentUser.value!,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
         /* SizedBox(height: 20.h),
          const BannerCard(),
          SizedBox(height: 13.h),*/
          Row(
            children: [
              Text(
                'Popular 🔥',
                style: AppTypography.kSemiBold16,
              ),
              const Spacer(),
              CustomTextButton(
                onPressed: () {},
                text: 'See All',
                fontSize: 12.sp,
                color: AppColors.kPrimary,
              ),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var products = snapshot.data!.docs;
              return AnimationLimiter(
                child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: 153.w / 221.h,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.tenHorizontal,
                  mainAxisSpacing: AppSpacing.twentyVertical,
                  /*children: List.generate(
                    dummyProductList.length,
                    (index) {
                      return AnimationConfiguration.staggeredGrid(
                        columnCount: 2,
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: FadeInAnimation(
                          duration: const Duration(seconds: 1),
                          child: FadeInAnimation(
                            child: ProductCard(
                              product: dummyProductList[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),*/
                  children:List.generate(
                    products.length,
                      (index) =>AnimationConfiguration.staggeredGrid(
                        columnCount: 2,
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: FadeInAnimation(
                          duration: const Duration(seconds: 1),
                          child: FadeInAnimation(
                            child: ProductCard(
                              product: ProductModel(
                                id: products[index].id,
                                name: products[index]['name'],
                                currentPrice: products[index]['price'],
                                averageRatings: 0.0,
                                imageUrls: products[index]['imageUrls'],
                                description: products[index]['materialComposition'],
                                oldPrice: 0,
                                offPercentage: '30% Off',
                                totalRatings: 0,
                                ownerName: 'John Doe',
                                category: ProductCategory.sofa,
                                filter: ProductFilter.brand,
                              ),
                            ),
                          ),
                        )
                      ),
                  )

                ),
              );
            }
          ),
          SizedBox(height: 90.h),
        ],
      ),
    );
  }
}
