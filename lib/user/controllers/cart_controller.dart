import 'package:get/get.dart';
import 'package:aookamao/user/models/cart_model.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/widgets/dialogs/custom_toast.dart';

class CartController extends GetxController {
  final cartItems = <CartModel>[].obs;

  void addToCart(ProductModel product, int quantity) {
    final existingItem =
        cartItems.firstWhereOrNull((item) => item.product.productId == product.productId);

    if (existingItem != null) {
      existingItem.quantity += quantity;
      showToast('Product already added');
    } else {
      cartItems.add(
        CartModel(
          product: product,
          quantity: quantity,
        ),
      );
      showToast('Added to Cart');
    }
  }

  void removeFromCart(ProductModel product) {
    cartItems.removeWhere((item) => item.product.productId == product.productId);
    showToast('Remove from Cart');
  }

  double getSubtotal() {
    var subtotal = 0.0;
    for (final item in cartItems) {
      subtotal += item.product.currentPrice * item.quantity;
    }
    return subtotal;
  }

  void clearCart() {
    cartItems.clear();
  }
}
