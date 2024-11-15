

import 'package:aookamao/admin/modules/products/controller/product_controller.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  HomeBinding();
  @override
  void dependencies() {
    print('HomeBinding');
   /* Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<ProductController>(() => ProductController());*/
    Get
      ..put<HomeController>(HomeController())
      ..put<FavoriteController>(FavoriteController())
      ..put<ProductController>(ProductController())
      ..put<CartController>(CartController());


  }
}
