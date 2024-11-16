import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/referral_model.dart';
import '../../services/auth_service.dart';
import '../../services/referral_service.dart';
import 'cart_controller.dart';

class HomeController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _referralService = Get.find<ReferralService>();
  RxList<Rx<ProductModel>> productsList = <Rx<ProductModel>>[].obs;
  ProductModel selectedProduct = ProductModel();
  RxBool isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cartController = Get.find<CartController>();
  Rx<ReferralModel> get currentReferralDetails => _referralService.currentReferralDetails;
  RxBool isReferralApplied = false.obs;


  @override
  Future<void> onInit() async {
    productsList.bindStream(getProducts());
    getProducts();
    ever(productsList, (callback) =>_cartController.cartItems.refresh());
   isReferralApplied.value = await _referralService.getCustomerReferralDetails();
    super.onInit();
  }


  Stream<RxList<Rx<ProductModel>>> getProducts() {
    return _firestore.collection(Constants.productsCollection).snapshots().map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromMap(doc.data()).obs).toList().obs);
  }
}