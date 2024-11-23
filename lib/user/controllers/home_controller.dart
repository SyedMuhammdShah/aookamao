import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/order_model.dart';
import '../../models/referral_model.dart';
import '../../models/wallet_model.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';
import '../../services/referral_service.dart';
import 'cart_controller.dart';

class HomeController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _orderService = Get.find<OrderService>();
  final _referralService = Get.find<ReferralService>();
  RxList<Rx<ProductModel>> productsList = <Rx<ProductModel>>[].obs;
  ProductModel selectedProduct = ProductModel();
  RxBool isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cartController = Get.find<CartController>();
  Rx<ReferralModel>  currentReferralDetails = Rx<ReferralModel>(ReferralModel());
  final RxList<Rx<OrderModel>> customerOrdersList = <Rx<OrderModel>>[].obs;
  final RxList<MyPurchaseModel> myPurchasesList = <MyPurchaseModel>[].obs;
  Rx<WalletModel> userWallet = WalletModel(walletId: '',balance: 0.00).obs;
  RxBool isReferralApplied = false.obs;


  @override
  Future<void> onInit() async {
    productsList.bindStream(getProducts());
    userWallet.bindStream(_orderService.getWalletData());
    currentReferralDetails.bindStream(_referralService.getReferralDetails());
    ever(productsList, (callback) =>_cartController.cartItems.refresh());
   isReferralApplied.value = await _referralService.getCustomerReferralDetails();
    super.onInit();
  }


  @override
  void dispose() {
    productsList.close();
    userWallet.close();
    currentReferralDetails.close();
    myPurchasesList.close();
    customerOrdersList.close();
    super.dispose();
  }

  Stream<RxList<Rx<ProductModel>>> getProducts() {
    return _firestore.collection(Constants.productsCollection).snapshots().map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromMap(doc.data()).obs).toList().obs);
  }

  void getOrders() {
    if(customerOrdersList.isNotEmpty){
      customerOrdersList.clear();
    }
    if(myPurchasesList.isNotEmpty){
      myPurchasesList.clear();
    }
    customerOrdersList.bindStream(getCustomerOrders());
    getCustomerOrders().listen(
  (event) {
    myPurchasesList.clear();
    for (var element1 in event) {
      var orderStatus = element1.value.orderStatus;
      print("index of order el1: ${customerOrdersList.indexWhere((element) => element.value.orderId == element1.value.orderId)}");
      var indexOfOrder = customerOrdersList.indexWhere((element) => element.value.orderId == element1.value.orderId);

      for (var element2 in element1.value.orderItems) {
        myPurchasesList.add(MyPurchaseModel(
          indexOfOrder: indexOfOrder,
          imageUrl: element2.imageUrl,
          productName: element2.productName,
          orderStatus: orderStatus,
          price: element2.price,
          productId: element2.productId,
          quantity: element2.quantity,
        ));
        myPurchasesList.refresh();
      }
    }
  },
);
  }

  Stream<RxList<Rx<OrderModel>>> getCustomerOrders() {
    final customerId = _authService.currentUser.value!.uid;
    return _firestore.collection(Constants.ordersCollection).where('customerId', isEqualTo: customerId).snapshots().map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromDoc(doc).obs).toList().obs);
  }

}