import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/app/modules/auth/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    return Scaffold(
     appBar: adminAppBar(user: authController.currentUser.value!),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Orders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DataTable(
                  columnSpacing: 16,
                  columns: [
                    DataColumn(
                        label: Text('Order ID',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Customer',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Product',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Actions',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildDataRow(
                      context,
                      'ORD12345',
                      'John Doe',
                      'Fabric A',
                      '\$50',
                    ),
                    // Add more DataRow widgets as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(
      BuildContext context, String orderId, String customer, String product, String amount) {
    return DataRow(
      cells: [
        DataCell(Text(orderId)),
        DataCell(Text(customer)),
        DataCell(Text(product)),
        DataCell(Text(amount)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_red_eye),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // View Order Details
                },
              ),
              IconButton(
                icon: Icon(Icons.check),
                color: Colors.green,
                onPressed: () {
                  // Mark Order as Complete
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
