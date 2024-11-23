import 'package:aookamao/models/order_model.dart';
import 'package:get/get.dart';

import '../../../../enums/order_status.dart';
import '../../../../services/order_service.dart';

class OrderController extends GetxController{
  final _orderService = Get.find<OrderService>();
  RxList<Rx<OrderModel>> ordersList = <Rx<OrderModel>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  getOrders()  {
   ordersList.bindStream(_orderService.getAllOrders());
  }

  Future<void> updateOrderStatus({required String orderId,required OrderStatus orderstatus,required String customer_id}) async {
    try {
      isLoading.value = true;
      await _orderService.updateOrderStatus(orderId: orderId, orderstatus: orderstatus,customer_id: customer_id);
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    ordersList.close();
    isLoading.close();

  }
}