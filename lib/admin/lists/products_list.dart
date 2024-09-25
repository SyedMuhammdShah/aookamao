import 'package:aookamao/admin/controller/product_controller.dart';
import 'package:aookamao/admin/lists/product_detail_screen.dart';
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
}
