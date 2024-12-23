import 'package:aookamao/admin/modules/products/controller/product_controller.dart';
import 'package:aookamao/admin/modules/products/product_detail_screen.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../components/adminAppBar.dart';
import '../../components/admin_drawer.dart';

class ProductsList extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  Future<void> deleteProduct(String productId, List<String> imageUrls) async {
    try {
      for (var imageUrl in imageUrls) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      Get.snackbar('Success', 'Product deleted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const adminAppBar(Title: 'Product List',),
      drawer: const AdminDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var products = snapshot.data!.docs;

          return SingleChildScrollView( // Makes entire grid scrollable
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                shrinkWrap: true, // Allows grid to take only the space it needs
                physics: const NeverScrollableScrollPhysics(), // Disables grid's own scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  String productId = product.id;
                  String name = product['name'] ?? 'Unknown';
                  double price = double.tryParse(product['price'].toString())?? 0.0;

                  List<String> imageUrls = [];
                  var productData = product.data() as Map<String, dynamic>?;
                  if (productData != null && productData.containsKey('imageUrls') && product['imageUrls'] is List) {
                    imageUrls = List<String>.from(product['imageUrls']);
                  }

                  return GestureDetector(
                    onTap: () {
                      productController.selected_product.value = productData!;
                      productController.selected_product_id.value = productId;
                      Get.to(() => ProductDetailScreen());
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: imageUrls.isNotEmpty
                                ? Image.network(
                                    imageUrls[0],
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                                  ),
                          ),
                          Expanded( // Allows content within card to take available space
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.kPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                 /* Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.kGrey60.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Row(
                                          children: [
                                            Text(
                                              'Sales: \$200',
                                              style: TextStyle(
                                                color: AppColors.kGrey60,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(Icons.arrow_upward, size: 20, color: AppColors.kSuccess),
                                            Text(
                                              '20%',
                                              style: TextStyle(
                                                color: AppColors.kSuccess,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                     
                                    ],
                                  ),
                                  const SizedBox(height: 10),*/
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.kPrimary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:  Text(
                                      'Stock: ${product['stockQuantity']}',
                                      style: const TextStyle(
                                        color: AppColors.kPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
