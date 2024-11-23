import 'package:aookamao/enums/payment_type.dart';
import 'package:aookamao/user/bindings/home_binding.dart';
import 'package:aookamao/user/modules/home/home_view.dart';
import 'package:aookamao/user/modules/landingPage/landing_page.dart';
import 'package:aookamao/user/modules/widgets/dialogs/order_confirmed_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/models/cart_model.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:aookamao/user/modules/widgets/dialogs/custom_toast.dart';

import '../../enums/order_status.dart';
import '../../models/order_model.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';
import '../../services/referral_service.dart';
import '../modules/widgets/dialogs/payment_success_dialog.dart';
import 'home_controller.dart';

class CartController extends GetxController {
  final _orderService = Get.find<OrderService>();
  final _authService = Get.find<AuthService>();
  RxList<CartModel> cartItems = <CartModel>[].obs;
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationSearchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxDouble shippingCharges = 300.0.obs;
  RxBool isDragSheetOpen = false.obs;
  RxBool isLoading = false.obs;

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

  double getTotal() {
    return getSubtotal() + shippingCharges.value;
  }

  Future<void> placeOrder() async {
    isLoading.value = true;
    final _homeController = Get.find<HomeController>();
    final Orderdata = OrderModel(
      orderStatus: OrderStatus.pending,
      totalAmount: getTotal(),
      shippingCharges: shippingCharges.value,
      subTotal: getSubtotal(),
      orderDate: Timestamp.now(),
      paymentType: PaymentType.cod,
      transactionId: '',
      customerId: _authService.currentUser.value!.uid,
      customerName: nameController.text,
      customerAddress: addressController.text,
      customerPhone: phoneController.text,
      customerCity: selectedCity.value,
      customerEmail: _authService.currentUser.value!.email,
      orderItems: cartItems.map((e) => OrderItemModel(
        productId: _homeController.productsList[e.productListIndex].value.productId,
        productName: _homeController.productsList[e.productListIndex].value.name,
        price: _homeController.productsList[e.productListIndex].value.price,
        imageUrl: _homeController.productsList[e.productListIndex].value.imageUrls?.first,
        quantity: e.quantity,
      )).toList(),
    );
    await _orderService.placeOrder(orderData: Orderdata, referralDetails: _homeController.currentReferralDetails.value);
    isLoading.value = false;
    clearCart();
    Get.offAll<Widget>(() => const LandingPage());
    Get.dialog<void>(const OrderConfirmedDialog());
  }
  void clearCart() {
    cartItems.clear();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    locationSearchController.dispose();
    selectedCity.close();
    shippingCharges.close();
    isDragSheetOpen.close();
    isLoading.close();
    cartItems.close();
  }
}
