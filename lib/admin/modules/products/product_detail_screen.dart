import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'controller/product_controller.dart';
import 'edit_product.dart';

class ProductDetailScreen extends StatefulWidget {

  ProductDetailScreen();

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductController productController = Get.find<ProductController>();

   Map<String, dynamic> product = {};

   String productId = '';

  // Method to update product data in Firestore
  final List<Map<String, dynamic>> salesData = [
    {'month': 'Jan', 'sales': 120},
    {'month': 'Feb', 'sales': 180},
    {'month': 'Mar', 'sales': 100},
    {'month': 'Apr', 'sales': 250},
    {'month': 'May', 'sales': 300},
  ];

  // Function to generate chart data
  List<FlSpot> _generateChartData() {
    return List.generate(salesData.length, (index) {
      return FlSpot(index.toDouble(), salesData[index]['sales'].toDouble());
    });
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Extract product images safely
    product=productController.selected_product.value;
    productId=productController.selected_product_id.value;
    List<String> imageUrls = product['imageUrls'] is List ? List<String>.from(product['imageUrls']) : [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(product['name'] ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sales Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Map the index to month names
                              int index = value.toInt();
                              return Text(salesData[index]['month']);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateChartData(),
                          isCurved: true,
                          color: AppColors.kPrimary,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: true, color: AppColors.kPrimary.withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Section 1: Product Images
            Text('Images', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            imageUrls.isNotEmpty
               ? SizedBox(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    );
                  },
                itemCount: imageUrls.length,
              ),
            )
                : Text('No images available', style: TextStyle(color: Colors.grey)),

            SizedBox(height: 20),

            // Section 2: Product Details
            Text('Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(), // Adjust column width dynamically
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(children: [Text('Name'), Text(product['name'] ?? 'Unknown')]),
                    TableRow(children: [Text('Price'), Text('\$${product['price']?.toStringAsFixed(2) ?? 'Unknown'}')]),
                    TableRow(children: [Text('Fabric Type'), Text(product['fabricType'] ?? 'Unknown')]),
                    TableRow(children: [Text('Fabric Length'), Text('${product['fabricLength'] ?? 'Unknown'}')]),
                    TableRow(children: [Text('Fabric Width'), Text('${product['fabricWidth'] ?? 'Unknown'}')]),
                    TableRow(children: [Text('Color'), Text(product['color'] ?? 'Unknown')]),
                    TableRow(children: [Text('Design'), Text(product['design'] ?? 'Unknown')]),
                    TableRow(children: [Text('Weight'), Text(product['weight'] ?? 'Unknown')]),
                    TableRow(children: [Text('Material Composition'), Text(product['materialComposition'] ?? 'Unknown')]),
                    TableRow(children: [Text('Wash Care'), Text(product['washCare'] ?? 'Unknown')]),
                    TableRow(children: [Text('Stock Quantity'), Text('${product['stockQuantity'] ?? 'Unknown'}')]),
                    TableRow(children: [Text('Season'), Text(product['season'] ?? 'Unknown')]),
                    TableRow(children: [Text('Country of Origin'), Text(product['countryOfOrigin'] ?? 'Unknown')]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Section 3: Update Product Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.kSuccess),
                  ),
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    /*productController.selected_product = product;
                    productController.selected_product_id = productId;*/
                    Get.to(EditProduct());
                  },
                  label: Text('Update Product',style:TextStyle(color: Colors.white),),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                  ),
                  icon: Icon(Icons.delete,color: Colors.white),
                  onPressed: () {
                    // Show delete confirmation dialog
                    Get.dialog(
                      AlertDialog(
                        title: Text('Delete Product'),
                        content: Text('Are you sure you want to delete this product?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close dialog
                              Get.back();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                             productController.deleteProduct();
                              // Close dialog
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  label: Text('Delete Product',style:TextStyle(color: Colors.white),),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
