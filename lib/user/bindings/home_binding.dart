import 'package:aookamao/user/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/controllers/cart_controller.dart';
import 'package:aookamao/user/controllers/favorite_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<FavoriteController>(FavoriteController())
      ..put<CartController>(CartController())
      ..put<HomeController>(HomeController());
  }
}
