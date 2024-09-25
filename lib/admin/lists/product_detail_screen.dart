import 'package:aookamao/admin/lists/Product_edit_popup.dart';
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

/*
class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final Map<String, dynamic> product;

  ProductDetailScreen({ required this.product, required this.productId});

  // Method to update product data in Firestore
  Future<void> updateProduct(Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).update(updatedData);
      Get.snackbar('Success', 'Product updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract product images safely
    List<String> imageUrls = product['imageUrls'] is List ? List<String>.from(product['imageUrls']) : [];

    return Scaffold(
      appBar: AppBar(
            backgroundColor: AppColors.kPrimary,
        title: Text(product['name'] ?? 'Product Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Show the popup dialog with editable fields
              Get.defaultDialog(
                title: 'Edit Product',
                content: ProductEditPopup(product: product, productId: productId),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product images
            Text('Images:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            imageUrls.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                : Text('No images available', style: TextStyle(color: Colors.grey)),

            SizedBox(height: 20),

            // Display product details
            Text('Details:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Table(
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
          ],
        ),
      ),
    );
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';  // For charts
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:aookamao/admin/lists/Product_edit_popup.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product, required this.productId});

  // Method to update product data in Firestore
  Future<void> updateProduct(Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update(updatedData);
      Get.snackbar('Success', 'Product updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  // Placeholder sales data for demonstration purposes
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
  Widget build(BuildContext context) {
    // Extract product images safely
    List<String> imageUrls =
    product['imageUrls'] is List ? List<String>.from(product['imageUrls']) : [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(product['name'] ?? 'Product Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Show the popup dialog with editable fields
              Get.defaultDialog(
                title: 'Edit Product',
                content: ProductEditPopup(product: product, productId: productId),
              );
            },
          ),
        ],
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
               /* ? GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.5, // Adjust aspect ratio (width:height
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            )*/? SizedBox(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
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

          ],
        ),
      ),
    );
  }
}
