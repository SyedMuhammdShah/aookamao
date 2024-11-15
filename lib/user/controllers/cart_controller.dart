import 'package:get/get.dart';
import 'package:aookamao/user/models/cart_model.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/widgets/dialogs/custom_toast.dart';

class CartController extends GetxController {
  final cartItems = <CartModel>[].obs;

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
    cartItems.removeWhere((item) => item.productListIndex == productindex);
    showToast('Remove from Cart');
  }

  double getSubtotal() {
   /* var subtotal = 0.0;
    for (final item in cartItems) {
      subtotal += item.product.price! * item.quantity;
    }*/
    return 0.0;
  }

  void clearCart() {
    cartItems.clear();
  }
}
