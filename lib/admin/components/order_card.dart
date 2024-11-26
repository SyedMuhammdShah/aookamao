import 'package:aookamao/enums/order_status.dart';
import 'package:aookamao/user/data/constants/app_assets.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/modules/widgets/buttons/custom_text_button.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../models/order_model.dart';
import '../modules/orders/order_details.dart';

class OrderCard extends StatelessWidget {
  final Rx<OrderModel> order;
  final int orderIndex;
  const OrderCard({super.key, required this.order, required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.value.customerName??'',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Order Id: ${order.value.orderId}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "${order.value.orderItems.length} Item(s)",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              "Rs.${order.value.totalAmount?.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 5),
            CustomTextButton(
              text: 'View Details',
              onPressed: () {
                Get.to(() => OrderDetails(orderIndex:orderIndex));
              },
            ),
          ],
        ),
        showTrailingIcon: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: order.value.orderStatus == OrderStatus.delivered ? Colors.green : order.value.orderStatus == OrderStatus.cancelled ? Colors.red :order.value.orderStatus == OrderStatus.pending ? Colors.orange : Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
               orderStatusToString(order.value.orderStatus!),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        ),
        children: order.value.orderItems.map((item) => _buildOrderItem(item)).toList(),
      ),
    )
    );
  }
}
Widget _buildOrderItem(OrderItemModel item) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      tileColor: AppColors.kGrey20,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: item.imageUrl??'',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
                ),
              ),
        )
      ),
      title: Text("${item.productName} x ${item.quantity}"),
      trailing: Text(
        "Rs.${item.price?.toStringAsFixed(2)}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
