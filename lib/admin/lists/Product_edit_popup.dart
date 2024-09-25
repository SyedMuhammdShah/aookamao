import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProductEditPopup extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> product;

  ProductEditPopup({required this.productId, required this.product});

  @override
  _ProductEditPopupState createState() => _ProductEditPopupState();
}

class _ProductEditPopupState extends State<ProductEditPopup> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController fabricTypeController;
  late TextEditingController fabricLengthController;
  late TextEditingController fabricWidthController;
  late TextEditingController colorController;
  late TextEditingController designController;
  late TextEditingController weightController;
  late TextEditingController materialCompositionController;
  late TextEditingController washCareController;
  late TextEditingController stockQuantityController;
  late TextEditingController seasonController;
  late TextEditingController countryOfOriginController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current product data
    nameController = TextEditingController(text: widget.product['name']);
    priceController = TextEditingController(text: widget.product['price']?.toString());
    fabricTypeController = TextEditingController(text: widget.product['fabricType']);
    fabricLengthController = TextEditingController(text: widget.product['fabricLength']?.toString());
    fabricWidthController = TextEditingController(text: widget.product['fabricWidth']?.toString());
    colorController = TextEditingController(text: widget.product['color']);
    designController = TextEditingController(text: widget.product['design']);
    weightController = TextEditingController(text: widget.product['weight']);
    materialCompositionController = TextEditingController(text: widget.product['materialComposition']);
    washCareController = TextEditingController(text: widget.product['washCare']);
    stockQuantityController = TextEditingController(text: widget.product['stockQuantity']?.toString());
    seasonController = TextEditingController(text: widget.product['season']);
    countryOfOriginController = TextEditingController(text: widget.product['countryOfOrigin']);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    fabricTypeController.dispose();
    fabricLengthController.dispose();
    fabricWidthController.dispose();
    colorController.dispose();
    designController.dispose();
    weightController.dispose();
    materialCompositionController.dispose();
    washCareController.dispose();
    stockQuantityController.dispose();
    seasonController.dispose();
    countryOfOriginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Price'),
          ),
          TextField(
            controller: fabricTypeController,
            decoration: InputDecoration(labelText: 'Fabric Type'),
          ),
          TextField(
            controller: fabricLengthController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Fabric Length'),
          ),
          TextField(
            controller: fabricWidthController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Fabric Width'),
          ),
          TextField(
            controller: colorController,
            decoration: InputDecoration(labelText: 'Color'),
          ),
          TextField(
            controller: designController,
            decoration: InputDecoration(labelText: 'Design'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Update product data when the user presses the update button
              Map<String, dynamic> updatedData = {
                'name': nameController.text,
                'price': double.tryParse(priceController.text) ?? widget.product['price'],
                'fabricType': fabricTypeController.text,
                'fabricLength': double.tryParse(fabricLengthController.text) ?? widget.product['fabricLength'],
                'fabricWidth': double.tryParse(fabricWidthController.text) ?? widget.product['fabricWidth'],
                'color': colorController.text,
                'design': designController.text,
                'weight': weightController.text,
                'materialComposition': materialCompositionController.text,
                'washCare': washCareController.text,
                'stockQuantity': int.tryParse(stockQuantityController.text) ?? widget.product['stockQuantity'],
                'season': seasonController.text,
                'countryOfOrigin': countryOfOriginController.text,
              };

              updateProduct(widget.productId, updatedData); // Use the passed productId
              Get.back(); // Close the popup
            },
            child: Text('Update Product'),
          ),
        ],
      ),
    );
  }

  // Method to update the product
  Future<void> updateProduct(String productId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).update(updatedData);
      Get.snackbar('Success', 'Product updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }
}
