

import 'package:aookamao/admin/modules/orders/controller/order_controller.dart';
import 'package:aookamao/admin/modules/products/controller/product_controller.dart';
import 'package:aookamao/admin/modules/rewards/controller/reward_controller.dart';
import 'package:aookamao/admin/modules/transactions/controller/transaction_controller.dart';
import 'package:get/get.dart';

import '../admin/modules/dashboard/controller/admin_dashboard_controller.dart';
import '../admin/modules/retailers/controller/retailer_controller.dart';
import '../modules/auth/controller/auth_controller.dart';
import '../retailer/retailer_modules/dashboard/controller/retailer_dashboard_controller.dart';
import '../user/controllers/cart_controller.dart';
import '../user/controllers/favorite_controller.dart';
import '../user/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  HomeBinding();
  @override
  void dependencies() {
    print('HomeBinding');
    Get.lazyPut<AuthController>(() =>  AuthController(),fenix: true);
    Get.lazyPut<AdminDashboardController>(()=>AdminDashboardController(),fenix: true);
    Get.lazyPut<RetailerController>(()=>RetailerController(),fenix: true);
    Get.lazyPut<RetailerDashboardController>(()=>RetailerDashboardController(),fenix: true);
    Get.lazyPut<CartController>(() => CartController(),fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(),fenix: true);
    Get.lazyPut<FavoriteController>(() => FavoriteController(),fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(),fenix: true);
    Get.lazyPut<OrderController>(() => OrderController(),fenix: true);
    Get.lazyPut<RewardController>(() => RewardController(),fenix: true);
    Get.lazyPut<TransactionController>(() => TransactionController(),fenix: true);

   /* Get
      ..put<CartController>(CartController())
      ..put<HomeController>(HomeController())
      ..put<FavoriteController>(FavoriteController())
      ..put<ProductController>(ProductController());*/



  }
}
