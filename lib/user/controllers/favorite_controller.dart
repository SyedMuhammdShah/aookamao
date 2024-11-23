import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/models/product_model.dart';

class FavoriteController extends GetxController {
  RxList<Rx<ProductModel>> favorite = <Rx<ProductModel>>[].obs;

  void addToFavorites(ProductModel product) {
    if (favorite.isNotEmpty) {
      if (!isProductInFavorites(product)) {
        favorite.add(product.obs);
        favorite.refresh();
      }
    } else {
      favorite..value = [product.obs]
      ..refresh();
    }
    //debugPrint(favorite!.length.toString());
  }

  void removeFromFavorites(ProductModel product) {
    if (favorite.isNotEmpty) {
      if (isProductInFavorites(product)) {
        favorite.remove(product.obs);
        favorite.refresh();
      }
    }
  }

  bool isProductInFavorites(ProductModel product) {
    return favorite.any((p) => p?.value.productId == product.productId);
  }

  @override
  void dispose() {
    super.dispose();
    favorite.close();
  }
}
