import 'package:get/get.dart';
import 'package:aookamao/user/models/cart_model.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/widgets/dialogs/custom_toast.dart';

import 'home_controller.dart';

class CartController extends GetxController {

  RxList<CartModel> cartItems = <CartModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
  void addToCart(int productindex, int quantity) {
    /*final existingItem =
        cartItems.firstWhereOrNull((item) => item.product.productId == product.productId);*/
    final existingItem = cartItems.firstWhereOrNull((element) =>element.productListIndex == productindex);

    if (existingItem != null) {
      existingItem.quantity += quantity;
      showToast('Product already added');
    } else {
      cartItems.add(
        CartModel(
          productListIndex: productindex,
          quantity: quantity,
        ),
      );
      showToast('Added to Cart');
    }
  }

  void removeFromCart(int productindex) {
    cartItems.removeAt(productindex);
    showToast('Remove from Cart');
  }


  double getSubtotal() {
    final _homeController = Get.find<HomeController>();
    print('getSubtotal');
    double subtotal = 0.0;

    cartItems.forEach((item) {
      subtotal += _homeController.productsList[item.productListIndex].value.price! * item.quantity;
    });
   /* for (final item in cartItems) {
      subtotal += _homeController.productsList[item.productListIndex].value.price ?? 0.0 * item.quantity;
    }*/
    print('Subtotal: $subtotal');
    return subtotal;
  }

  void clearCart() {
    cartItems.clear();
  }
}
