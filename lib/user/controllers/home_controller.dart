import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/user/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../services/auth_service.dart';

class HomeController extends GetxController {
  final _authService = Get.find<AuthService>();
  RxList<Rx<ProductModel>> productsList = <Rx<ProductModel>>[].obs;
  ProductModel selectedProduct = ProductModel();
  RxBool isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  void onInit() {
    productsList.bindStream(getProducts());
    getProducts();
    super.onInit();
  }

   /*getProducts(){
    isLoading.value = true;
    _firestore.collection(Constants.productsCollection).snapshots().listen((event) {
      productsList.clear();
      for (var doc in event.docs) {
        productsList.add(ProductModel.fromMap(doc.data()));
      }
      isLoading.value = false;
    });
  }*/

  Stream<RxList<Rx<ProductModel>>> getProducts() {
    return _firestore.collection(Constants.productsCollection).snapshots().map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromMap(doc.data()).obs).toList().obs);
  }
}