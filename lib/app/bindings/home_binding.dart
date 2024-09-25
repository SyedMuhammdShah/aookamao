import 'package:get/get.dart';
import 'package:aookamao/app/controllers/cart_controller.dart';
import 'package:aookamao/app/controllers/favorite_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<FavoriteController>(FavoriteController())
      ..put<CartController>(CartController());
  }
}
