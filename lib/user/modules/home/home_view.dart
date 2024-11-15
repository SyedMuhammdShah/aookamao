import 'package:aookamao/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/home/components/banner_card.dart';
import 'package:aookamao/user/modules/home/components/home_appbar.dart';
import 'package:aookamao/user/modules/home/components/product_card.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../modules/auth/controller/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/helpers/product_category.dart';
import '../../data/helpers/product_filter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});


  @override
  Widget build(BuildContext context) {
    final  _authController = Get.find<AuthController>();
    final _authService = Get.find<AuthService>();
    final _homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: HomeAppBar(
        user: _authService.currentUser.value!,
      ),
      body: Obx(() => ListView(
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
                /*const Spacer(),
                CustomTextButton(
                  onPressed: () {},
                  text: 'See All',
                  fontSize: 12.sp,
                  color: AppColors.kPrimary,
                ),*/
              ],
            ),
            SizedBox(height: 20.h),
            AnimationLimiter(
              child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: 153.w / 221.h,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.tenHorizontal,
                mainAxisSpacing: AppSpacing.twentyVertical,
                children:List.generate(
                  _homeController.productsList.length,
                    (index) =>AnimationConfiguration.staggeredGrid(
                      columnCount: 2,
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: FadeInAnimation(
                        duration: const Duration(seconds: 1),
                        child: FadeInAnimation(
                          child: ProductCard(
                            product: _homeController.productsList[index],
                            productListIndex: index,
                          ),
                        ),
                      )
                    ),
                )

              ),
            ),
           /*  AnimationLimiter(
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 153.w / 221.h,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.tenHorizontal,
                    mainAxisSpacing: AppSpacing.twentyVertical,
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
                                  productId: products[index].id,
                                  name: products[index]['name'],
                                  currentPrice: products[index]['price'],
                                  imageUrls: products[index]['imageUrls'],
                                  description: products[index]['materialComposition'],
                                  category: ProductCategory.sofa,
                                  filter: ProductFilter.brand,
                                ),
                              ),
                            ),
                          )
                        ),
                    )

                  ),
            ),*/
            SizedBox(height: 90.h),
          ],
        ),
      ),
    );
  }
}
