import 'dart:io';

import 'package:aookamao/admin/modules/dashboard/admin_dashboard.dart';
import 'package:aookamao/admin/modules/products/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';

import '../../../../widgets/custom_snackbar.dart';
import '../products_list.dart';

class ProductController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;  // Initialize Firebase Storage

  // TextEditingControllers for all product fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController fabricTypeController = TextEditingController();
  final TextEditingController fabricLengthController = TextEditingController();
  final TextEditingController fabricWidthController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController designController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController materialCompositionController = TextEditingController();
  final TextEditingController washCareController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();
  final TextEditingController countryOfOriginController = TextEditingController();
  
  RxString gender = ''.obs;  // Gender field
  RxList<File> selectedImages = <File>[].obs; // To store multiple image files
  final Uuid uuid = Uuid();
  RxBool is_product = false.obs;
  RxBool is_loading = false.obs;
  //final selected_product = <String,dynamic>{}.obs;
  RxMap<String,dynamic> selected_product = <String,dynamic>{}.obs;
  final selected_product_id = ''.obs;
  // Pick multiple images using file picker
  Future<void> pickMultipleImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      if(is_product.isTrue){
      is_product.value = false;
      }
      selectedImages.addAll(result.paths.map((path) => File(path!)).toList());
    }
  }

  // Method to upload images to Firebase Storage and get URLs
  Future<List<String>> _uploadImagesToStorage() async {
    List<String> imageUrls = [];

    for (var image in selectedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('products/$fileName');

      UploadTask uploadTask = storageRef.putFile(image);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<void> updateProduct()async{
    is_loading.value = true;
    try {
      // Get the current user
      User? user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      if(selectedImages.isNotEmpty){
        // Upload images to Firebase Storage
        List<String> imageUrls = await _uploadImagesToStorage();
        // Add product data to Firestore
        await _fireStore.collection('products').doc(selected_product_id.value).update({
          'imageUrls': FieldValue.arrayUnion(imageUrls),  // Store the image URLs
        });
        selected_product['imageUrls'].addAll(imageUrls);  // Add new images to the existing list
      }

      // Update product data in Firestore
      await _fireStore.collection('products').doc(selected_product_id.value).update({
        'name': nameController.text,
        'price': double.tryParse(priceController.text) ?? 0,
        'fabricType': fabricTypeController.text,
        'fabricLength': double.tryParse(fabricLengthController.text) ?? 0,
        'fabricWidth': double.tryParse(fabricWidthController.text) ?? 0,
        'color': colorController.text,
        'design': designController.text,
        'gender': gender.value,
        'weight': weightController.text,
        'materialComposition': materialCompositionController.text,
        'washCare': washCareController.text,
        'stockQuantity': int.tryParse(stockQuantityController.text) ?? 0,
        'season': seasonController.text,
        'countryOfOrigin': countryOfOriginController.text,
        'createdBy': user.uid,
        'productId': selected_product_id.value,

  });
      // Update the selected product data
      selected_product['name'] = nameController.text;
      selected_product['price'] = double.tryParse(priceController.text) ?? 0;
      selected_product['fabricType'] = fabricTypeController.text;
      selected_product['fabricLength'] = double.tryParse(fabricLengthController.text) ?? 0;
      selected_product['fabricWidth'] = double.tryParse(fabricWidthController.text) ?? 0;
      selected_product['color'] = colorController.text;
      selected_product['design'] = designController.text;
      selected_product['gender']=gender.value;
      selected_product['weight']=weightController.text;
      selected_product['materialComposition']=materialCompositionController.text;
      selected_product['washCare']=washCareController.text;
      selected_product['stockQuantity']=int.tryParse(stockQuantityController.text) ?? 0;
      selected_product['season']=seasonController.text;
      selected_product['countryOfOrigin']=countryOfOriginController.text;
      is_loading.value = false;
      showSuccessSnackbar('Product updated successfully!');  // Show custom snackbar
      Get.off(ProductDetailScreen());
      clearFields();// Clear fields after successful submission
    } catch (e) {
      print(e);
      showErrorSnackbar('Failed to update product: $e');  // Show custom snackbar
    }
  }

  Future<void> deleteProduct() async {
    is_loading.value = true;
    try {
      // Delete product from Firestore
      await _fireStore.collection('products').doc(selected_product_id.value).delete();
      is_loading.value = false;
      showSuccessSnackbar('Product deleted successfully!');// Show custom snackbar
      Get.off(ProductsList());
    } catch (e) {
      print(e);
      showErrorSnackbar('Failed to delete product: $e');  // Show custom snackbar
    }
  }

  // Method to add product to Firestore
  Future<void> addProduct() async {
    is_loading.value = true;
    try {
      // Get the current user
      User? user = _auth.currentUser;
      String productId = uuid.v4();
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      // Upload images to Firebase Storage
      List<String> imageUrls = await _uploadImagesToStorage();

      // Add product data to Firestore
      await _fireStore.collection('products').add({
        'name': nameController.text,
        'price': double.tryParse(priceController.text) ?? 0,
        'fabricType': fabricTypeController.text,
        'fabricLength': double.tryParse(fabricLengthController.text) ?? 0,
        'fabricWidth': double.tryParse(fabricWidthController.text) ?? 0,
        'color': colorController.text,
        'design': designController.text,
        'gender': gender.value,
        'weight': weightController.text,
        'materialComposition': materialCompositionController.text,
        'washCare': washCareController.text,
        'stockQuantity': int.tryParse(stockQuantityController.text) ?? 0,
        'season': seasonController.text,
        'countryOfOrigin': countryOfOriginController.text,
        'imageUrls': imageUrls,  // Store the image URLs
        'createdBy': user.uid,
        'productId': productId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      is_loading.value = false;
      showSuccessSnackbar('Product added successfully!');  // Show custom snackbar
            Get.to(AdminDashboard());
      clearFields();  // Clear fields after successful submission
    } catch (e) {
      showErrorSnackbar('Failed to add product: $e');  // Show custom snackbar
    }
  }
  Future<void> removeImagefromStorage(String imageUrl,int index) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
      await _fireStore.collection('products').doc(selected_product_id.value).update({
        'imageUrls': FieldValue.arrayRemove([imageUrl])
      });
      selected_product['imageUrls'].remove(imageUrl);
      showSuccessSnackbar('Image deleted successfully!');
    } catch (e) {
      showErrorSnackbar('Failed to delete image: $e');
    }
  }
  // Clear form fields
  void clearFields() {
    nameController.clear();
    priceController.clear();
    fabricTypeController.clear();
    fabricLengthController.clear();
    fabricWidthController.clear();
    colorController.clear();
    designController.clear();
    weightController.clear();
    materialCompositionController.clear();
    washCareController.clear();
    stockQuantityController.clear();
    seasonController.clear();
    countryOfOriginController.clear();
    gender.value = '';
    selectedImages.clear();
    is_product.value = false;
    update();  // Update UI
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is removed
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

    super.onClose();
  }


Stream<QuerySnapshot> fetchProducts() {
    return _fireStore.collection('products').snapshots();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
