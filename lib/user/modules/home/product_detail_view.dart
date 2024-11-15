import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/controllers/cart_controller.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/data/helpers/data.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/checkout/cart_view.dart';
import 'package:aookamao/user/modules/home/components/color_card.dart';
import 'package:aookamao/user/modules/home/components/quantity_card.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';

import '../../controllers/home_controller.dart';

class ProductDetailView extends StatefulWidget {
  /*final Rx<ProductModel> product;*/
  final int productListIndex;
  const ProductDetailView({
    super.key, required this.productListIndex,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _selectedColor = 0;
  RxInt selectedQuantity = 0.obs;
  final cc = Get.find<CartController>();
  final _homeController = Get.find<HomeController>();
  Rx<ProductModel> get product => _homeController.productsList[widget.productListIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(
          color: AppColors.kWhite,
        ),
        centerTitle: true,
        title: Text(
          'Detail',
          style: AppTypography.kSemiBold18.copyWith(color: AppColors.kWhite),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to<Widget>(CartView.new);
            },
            icon: SvgPicture.asset(
              AppAssets.kBag,
              colorFilter:
              const ColorFilter.mode(AppColors.kWhite, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: AppSpacing.tenHorizontal),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(() =>  Stack(
            children: [
              Hero(
                tag: product.value.productId??'',
                child: Column(
                  children: [
                    SizedBox(
                      height: 280.h,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 280.h,
                          autoPlay: false,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                        ),
                        items: product.value.imageUrls?.map((imageUrl) {
                          return
                            SizedBox(
                              height: 280.h,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>  Center(
                                  child: CircularProgressIndicator(backgroundColor: AppColors.kPrimary, value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            );
                        }).toList(),
                      ),
                    ),
                    // Add dots indicator
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: product.value.imageUrls.map((url) {
                        int index = product.value.imageUrls.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 2.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? AppColors.kSuccess
                                : AppColors.kBlue,
                          ),
                        );
                      }).toList(),
                    ),*/


                  ],
                ),
              ),
              /* Positioned(
                top: 50,
                left: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product.value.imageUrls.length,
                        (index) => Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 2.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? AppColors.kSuccess
                            : AppColors.kBlue,
                      ),
                    ),
                  ),
                ),
              ),*/
              SizedBox(height: AppSpacing.thirtyVertical),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  color: AppColors.kWhite,
                ),
                margin: EdgeInsets.only(top: 250.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.value.name??'',
                              style: AppTypography.kSemiBold18,
                            ),
                            /* SizedBox(height: 5.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppAssets.kStar),
                                SizedBox(width: 5.w),
                                Text(
                                  product.value.averageRatings.toString(),
                                  style: AppTypography.kSemiBold14,
                                ),
                                Text(
                                  '(${product.value.totalRatings} Review)',
                                  style: AppTypography.kSemiBold12
                                      .copyWith(color: AppColors.kGrey60),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                             QuantityCard(
                               quantity: selectedQuantity,
                               stockQuantity: product.value.stockQuantity??0
                             ),
                              SizedBox(height: AppSpacing.tenVertical),
                              product.value.stockQuantity == 0
                                  ? Text(
                                'Out of stock',
                                style: AppTypography.kSemiBold12.copyWith(
                                  color: AppColors.kError,
                                ),
                              )
                                  : Text(
                                'Available in stock',
                                style: AppTypography.kSemiBold12.copyWith(
                                  color: AppColors.kGrey100,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    //SizedBox(height: AppSpacing.twentyVertical),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          //childAspectRatio: 2,
                        ),
                        children: [
                          DescriptionCard(title: 'Color', description: product.value.color),
                          DescriptionCard(title: 'Design', description: product.value.design),
                          DescriptionCard(title: 'Material Composition', description: product.value.materialComposition),
                          DescriptionCard(title: 'Wash Care', description: product.value.washCare),
                          DescriptionCard(title: 'Fabric Type', description: product.value.fabricType),
                          DescriptionCard(title: 'Fabric Length', description: product.value.fabricLength.toString()),
                          DescriptionCard(title: 'Fabric Width', description: product.value.fabricWidth.toString()),
                          DescriptionCard(title: 'Weight', description: product.value.weight),
                          DescriptionCard(title: 'Season', description: product.value.season),
                          DescriptionCard(title: 'Country of Origin', description: product.value.countryOfOrigin),
                          DescriptionCard(title: 'Gender', description: product.value.gender),
                          DescriptionCard(title: 'Design', description: product.value.design),

                        ]
                      ),
                    ),
                    /*Wrap(
                      spacing: 10.w,
                      runSpacing: 10.0.h,
                      children: List.generate(
                        availableColor.length,
                            (index) => ColorCard(
                          color: availableColor[index],
                          isSelected: _selectedColor == index,
                          onTap: () {
                            setState(() {
                              _selectedColor = index;
                            });
                          },
                        ),
                      ),
                    ),*/
                   /* SizedBox(height: AppSpacing.twentyVertical),
                    Text(
                      'Material Composition',
                      style: AppTypography.kSemiBold18,
                    ),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.materialComposition??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text(
                      'Wash Care',
                      style: AppTypography.kSemiBold18,
                    ),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.washCare??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Fabric Type', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.fabricType??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Fabric Length', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.fabricLength.toString(),
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Fabric Width', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.fabricWidth.toString(),
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Weight', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.weight??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Season', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.season??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Country of Origin', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.countryOfOrigin??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Gender', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.gender??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Text('Design', style: AppTypography.kSemiBold18),
                    SizedBox(height: AppSpacing.tenVertical),
                    Text(
                      product.value.design??'',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey80,
                      ),
                    ),*/
                    SizedBox(height: AppSpacing.twentyFiveVertical),
                    SizedBox(height: AppSpacing.twentyFiveVertical),
                    SizedBox(height: AppSpacing.twentyFiveVertical),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppColors.kWhite,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: r'Rs ',
                  style:
                  AppTypography.kBold24.copyWith(color: AppColors.kPrimary),
                  children: [
                    TextSpan(
                      text: product.value.price.toString(),
                      style: AppTypography.kBold24,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PrimaryButton(
                onTap: () {
                  print('quantity: ${selectedQuantity.value}');
                  cc.addToCart(widget.productListIndex, selectedQuantity.value);
                },
                text: 'Add To Cart',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget DescriptionCard({required String title, required String? description}) {
  return Container(
    //padding: EdgeInsets.all(20.h),
    decoration: BoxDecoration(
      color: AppColors.kWhite,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: AppColors.kGrey20,
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    ),


    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: AppTypography.kSemiBold16,textAlign: TextAlign.center,),
        SizedBox(height: AppSpacing.tenVertical),
        Text(
         description??'',
          style: AppTypography.kMedium14.copyWith(
            color: AppColors.kGrey80,
          ),
        ),
      ],
    ),
  );
}