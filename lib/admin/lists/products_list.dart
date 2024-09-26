import 'package:aookamao/admin/controller/product_controller.dart';
import 'package:aookamao/admin/lists/product_detail_screen.dart';
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*class ProductsList extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  // Method to delete a product from Firestore and Firebase Storage
  Future<void> deleteProduct(String productId, List<String> imageUrls) async {
    try {
      // Delete the images from Firebase Storage
      for (var imageUrl in imageUrls) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      // Delete the product from Firestore
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      Get.snackbar('Success', 'Product deleted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text('Products List',style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              String productId = product.id;
              String name = product['name'] ?? 'Unknown'; // Fallback for missing name
              double price = product['price'] ?? 0.0; // Fallback for missing price

              // Safely handle imageUrls - default to an empty list if it doesn't exist
              List<String> imageUrls = [];

              // Cast product data to Map<String, dynamic>
              var productData = product.data() as Map<String, dynamic>?;

              if (productData != null && productData.containsKey('imageUrls') && product['imageUrls'] is List) {
                imageUrls = List<String>.from(product['imageUrls']);
              }

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: imageUrls.isNotEmpty
                      ? Image.network(imageUrls[0], width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 50),  // Fallback for missing image
                  title: Text(name),
                  subtitle: Text('\$${price.toStringAsFixed(2)}'),
                  onTap: () {
                    // Navigate to the product detail screen with the selected product
                    Get.to(() => ProductDetailScreen(product: productData!, productId: product['productId'],)); // Add non-null assertion
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Confirm delete action
                      Get.defaultDialog(
                        title: 'Delete Product',
                        middleText: 'Are you sure you want to delete this product?',
                        textConfirm: 'Delete',
                        textCancel: 'Cancel',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          deleteProduct(productId, imageUrls);  // Call the delete method
                          Get.back();  // Close the dialog
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}*/
class ProductsList extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  // Method to delete a product from Firestore and Firebase Storage
  Future<void> deleteProduct(String productId, List<String> imageUrls) async {
    try {
      // Delete the images from Firebase Storage
      for (var imageUrl in imageUrls) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      // Delete the product from Firestore
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      Get.snackbar('Success', 'Product deleted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text('Products List', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var products = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two products per row for a modern look
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65, // Adjust aspect ratio to give the card a taller appearance
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              String productId = product.id;
              String name = product['name'] ?? 'Unknown'; // Fallback for missing name
              double price = product['price'] ?? 0.0; // Fallback for missing price

              // Safely handle imageUrls - default to an empty list if it doesn't exist
              List<String> imageUrls = [];

              // Cast product data to Map<String, dynamic>
              var productData = product.data() as Map<String, dynamic>?;

              if (productData != null && productData.containsKey('imageUrls') && product['imageUrls'] is List) {
                imageUrls = List<String>.from(product['imageUrls']);
              }

              return GestureDetector(
                onTap: () {
                  // Navigate to the product detail screen with the selected product
                  productController.selected_product.value = productData!;
                  productController.selected_product_id.value = productId;
                  print(productController.selected_product);
                  Get.to(() => ProductDetailScreen());
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
                          child: Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
                      // Product Details
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Truncate name if too long
                            ),
                            SizedBox(height: 5),
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.kPrimary,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.kGrey60.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Sales: \$200',
                                    style: TextStyle(
                                      color: AppColors.kGrey60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.arrow_upward,size:20, color: AppColors.kSuccess),
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
                            SizedBox(height: 10),
                            // Delete Button (aligned to the bottom right)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.kSuccess.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Stock: 100',
                                style: TextStyle(
                                  color: AppColors.kGrey60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                           /* Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Confirm delete action
                                  Get.defaultDialog(
                                    title: 'Delete Product',
                                    middleText: 'Are you sure you want to delete this product?',
                                    textConfirm: 'Delete',
                                    textCancel: 'Cancel',
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      deleteProduct(productId, imageUrls); // Call the delete method
                                      Get.back(); // Close the dialog
                                    },
                                  );
                                },
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
