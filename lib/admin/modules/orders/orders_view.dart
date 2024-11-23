import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/admin/components/admin_drawer.dart';
import 'package:aookamao/admin/components/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'controller/order_controller.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _orderController = Get.find<OrderController>();
    final _authService = Get.find<AuthService>();
    return Scaffold(
      appBar: adminAppBar(user: _authService.currentUser.value!,Title:'Orders',),
      drawer: const AdminDrawer(),
      body: Obx(() => ListView.builder(
          itemCount: _orderController.ordersList.length,
          itemBuilder: (context, index) {
            return OrderCard(order: _orderController.ordersList[index], orderIndex: index);
          },
        ),
      ),
    );
  }
}


