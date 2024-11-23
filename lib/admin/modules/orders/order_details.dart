import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/enums/payment_type.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../enums/order_status.dart';
import '../../../models/order_model.dart';
import 'controller/order_controller.dart';

class OrderDetails extends StatelessWidget {
  final int orderIndex;

  const OrderDetails({super.key, required this.orderIndex});
  @override
  Widget build(BuildContext context) {
    final _orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: const adminAppBar(Title: 'Order Details'),
      body: Obx(
        () => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Card
                _buildSummaryCard(_orderController.ordersList[orderIndex].value),
                const SizedBox(height: 20),

                // Customer Details Card
                _buildCustomerDetailsCard(_orderController.ordersList[orderIndex].value),

                const SizedBox(height: 20),

                // Order Items Card
                _buildOrderItemsCard(_orderController.ordersList[orderIndex].value.orderItems),

                const SizedBox(height: 20),

                // Payment Summary Card
                _buildPaymentSummaryCard(_orderController.ordersList[orderIndex].value),

                const SizedBox(height: 20),

                if(_orderController.ordersList[orderIndex].value.orderStatus != OrderStatus.cancelled)
                Column(
                  children: [
                    if(_orderController.ordersList[orderIndex].value.orderStatus == OrderStatus.pending)
                      _orderController.isLoading.value
                          ? const Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
                      ))
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextButton(
                            text: "Cancel Order",
                            onPressed: () {
                              _orderController.updateOrderStatus(orderId:_orderController.ordersList[orderIndex].value.orderId!, customer_id: _orderController.ordersList[orderIndex].value.customerId!,orderstatus: OrderStatus.cancelled);
                            },
                          ),
                          const SizedBox(width: 10),
                          PrimaryButton(
                            text: "Confirm Order",
                            width: 150,
                            height: 50,
                            onTap: () {
                              _orderController.updateOrderStatus(orderId: _orderController.ordersList[orderIndex].value.orderId!,customer_id: _orderController.ordersList[orderIndex].value.customerId!, orderstatus: OrderStatus.confirmed);
                            },
                          ),
                        ],
                      ),
                    if(_orderController.ordersList[orderIndex].value.orderStatus == OrderStatus.confirmed)
                      _orderController.isLoading.value
                          ? const Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
                      ))
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryButton(
                            text: "Mark as Delivered",
                            width: 200,
                            height: 50,
                            onTap: () {
                              _orderController.updateOrderStatus(orderId: _orderController.ordersList[orderIndex].value.orderId!,customer_id: _orderController.ordersList[orderIndex].value.customerId!, orderstatus: OrderStatus.delivered);
                            },
                          ),
                        ],
                      )
                  ],
                ),
                if(_orderController.ordersList[orderIndex].value.orderStatus == OrderStatus.cancelled)
                  const Center(
                    child: Text(
                      "Order Cancelled",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCustomerDetailsCard(OrderModel order) {
  return SizedBox(
    width: double.infinity,
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customer Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text("Name: ${order.customerName}",
                style: AppTypography.kMedium12),
            const SizedBox(height: 4),
            Text("Email: ${order.customerEmail}",
                style: AppTypography.kMedium12),
            const SizedBox(height: 4),
            Text("Phone: ${order.customerPhone}",
                style: AppTypography.kMedium12),
            const SizedBox(height: 4),
            Text("Address: ${order.customerAddress}",
                style: AppTypography.kMedium12),

          ],
        ),
      ),
    ),
  );
}

Widget _buildSummaryCard(OrderModel order) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order Summary",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal),
              ),
              const SizedBox(height: 8),
              Text("Order ID: ${order.orderId}",
                  style: AppTypography.kMedium12),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text("Order Status: ",
                      style: AppTypography.kMedium12),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: order.orderStatus == OrderStatus.delivered ? Colors.green : order.orderStatus == OrderStatus.cancelled ? Colors.red :order.orderStatus == OrderStatus.pending ? Colors.orange : Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      orderStatusToString(order.orderStatus!),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Payment Method: ${paymentTypeToString(order.paymentType!)}',
                  style: AppTypography.kMedium12),
              const SizedBox(height: 4),
              //format date
              Text('Order Date: ${ DateFormat('MMM dd,yyyy hh:mm').format(order.orderDate!.toDate())}',
                  style: AppTypography.kMedium12),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget _buildOrderItemsCard(List<OrderItemModel> items) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Items",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl??"",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productName??"",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "Quantity: ${item.quantity}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "Rs.${item.price?.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildPaymentSummaryCard(OrderModel order) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Summary",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
          ),
          const SizedBox(height: 10),
          _buildSummaryRow("Subtotal", "Rs.${order.subTotal?.toStringAsFixed(2)}"),
          const SizedBox(height: 8),
          _buildSummaryRow("Shipping Charges", "Rs.${order.shippingCharges?.toStringAsFixed(2)}"),
          const Divider(color: Colors.grey),
          _buildSummaryRow(
            "Total",
            "Rs.${order.totalAmount?.toStringAsFixed(2)}",
            isBold: true,
          ),
        ],
      ),
    ),
  );
}

Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      Text(value, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
    ],
  );
}
