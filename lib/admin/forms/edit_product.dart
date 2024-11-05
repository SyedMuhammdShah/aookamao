import 'dart:io';
import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/admin/components/custom_snackbar.dart';
import 'package:aookamao/admin/controller/product_controller.dart';
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:aookamao/app/data/constants/app_spacing.dart';
import 'package:aookamao/app/modules/auth/auth/auth_controller.dart';
import 'package:aookamao/app/modules/widgets/buttons/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../widgets/custom_snackbar.dart';

class EditProduct extends StatefulWidget {
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  final ProductController productController = Get.put(ProductController());
  @override
  void dispose() {
    ProductController productController = Get.find<ProductController>();
    productController.clearFields(); // Clear all fields when the widget is disposed
    super.dispose();
  }
  @override
  void initState() {
    productController.nameController.text = productController.selected_product['name'];
    productController.priceController.text = productController.selected_product['price'].toString();
    productController.fabricTypeController.text = productController.selected_product['fabricType'];
    productController.fabricLengthController.text = productController.selected_product['fabricLength'].toString();
    productController.fabricWidthController.text = productController.selected_product['fabricWidth'].toString();
    productController.colorController.text = productController.selected_product['color'];
    productController.designController.text = productController.selected_product['design'];
    productController.gender.value = productController.selected_product['gender'];
    productController.weightController.text = productController.selected_product['weight'];
    productController.materialCompositionController.text = productController.selected_product['materialComposition'];
    productController.washCareController.text = productController.selected_product['washCare'];
    productController.stockQuantityController.text = productController.selected_product['stockQuantity'].toString();
    productController.seasonController.text = productController.selected_product['season'];
    productController.countryOfOriginController.text = productController.selected_product['countryOfOrigin'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    ProductController productController = Get.find<ProductController>();

    return Scaffold(
      appBar: adminAppBar(user: authController.currentUser.value!),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Update Unstitch Cloth',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey, // Add form key
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      _buildTextField('Product Name', productController.nameController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter a product name' : null),
                      SizedBox(height: 16),
                      _buildTextField('Price', productController.priceController, context,
                              (value) => value == null || value.isEmpty || double.tryParse(value) == null
                              ? 'Please enter a valid price'
                              : null,
                          TextInputType.number),
                      SizedBox(height: 16),
                      _buildTextField('Fabric Type', productController.fabricTypeController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter fabric type' : null),
                      SizedBox(height: 16),
                      _buildTextField('Fabric Length (m)', productController.fabricLengthController, context,
                              (value) => value == null || value.isEmpty || double.tryParse(value) == null
                              ? 'Please enter a valid fabric length'
                              : null,
                          TextInputType.number),
                      SizedBox(height: 16),
                      _buildTextField('Fabric Width (inches)', productController.fabricWidthController, context,
                              (value) => value == null || value.isEmpty || double.tryParse(value) == null
                              ? 'Please enter a valid fabric width'
                              : null,
                          TextInputType.number),
                      SizedBox(height: 16),
                      _buildTextField('Color', productController.colorController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter color' : null),
                      SizedBox(height: 16),
                      _buildTextField('Design/Pattern', productController.designController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter design' : null),
                      SizedBox(height: 16),
                      _buildGenderField(productController, context),
                      SizedBox(height: 16),
                      _buildTextField('Weight (e.g., Lightweight)', productController.weightController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter weight' : null),
                      SizedBox(height: 16),
                      _buildTextField('Material Composition', productController.materialCompositionController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter material composition' : null),
                      SizedBox(height: 16),
                      _buildTextField('Wash Care Instructions', productController.washCareController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter wash care instructions' : null),
                      SizedBox(height: 16),
                      _buildTextField('Stock Quantity', productController.stockQuantityController, context,
                              (value) => value == null || value.isEmpty || int.tryParse(value) == null
                              ? 'Please enter a valid stock quantity'
                              : null,
                          TextInputType.number),
                      SizedBox(height: 16),
                      _buildTextField('Suitable Season', productController.seasonController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter a suitable season' : null),
                      SizedBox(height: 16),
                      _buildTextField('Country of Origin', productController.countryOfOriginController, context,
                              (value) => value == null || value.isEmpty ? 'Please enter country of origin' : null),
                      SizedBox(height: 16),
                      _buildImageUploadField(productController, context), // Image upload field
                      SizedBox(height: 24),
                      Obx(
                            () => productController.is_loading.value ?
                        Center(child: SpinKitChasingDots(
                          color: Theme.of(context).primaryColor,
                          size: 50.0,
                        ))
                            : ElevatedButton(
                          onPressed: () {
                            if(productController.selectedImages.isEmpty){
                              productController.is_product.value = true;
                              showErrorSnackbar('Please add product images');
                            }
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, proceed to save
                              productController.updateProduct();
                            }
                            else{
                              showErrorSnackbar('Please fill all required fields');
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'Update Product',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated _buildTextField function with validator parameter
Widget _buildTextField(String labelText, TextEditingController controller, BuildContext context,
    String? Function(String?) validator, [TextInputType? keyboardType] ) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType ?? TextInputType.text,
    inputFormatters: keyboardType == TextInputType.number
        ? [FilteringTextInputFormatter.digitsOnly]
        : null,
    decoration: InputDecoration(
      errorStyle: TextStyle(color: Colors.red),
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.kGrey70),
        borderRadius: BorderRadius.circular(AppSpacing.radiusThirty),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.kGrey70),
        borderRadius: BorderRadius.circular(AppSpacing.radiusThirty),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    style: TextStyle(fontSize: 16),
    validator: validator,  // The validation logic for each field
  );
}


Widget _buildGenderField(
    ProductController productController, BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Obx(() => DropdownButtonFormField<String>(
          value: productController.gender.value.isEmpty
              ? null
              : productController.gender.value,
          validator: (value) =>
          value == null || value.isEmpty ? 'Please select your gander' : null,
          decoration: InputDecoration(
            label:Text("Gender"),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.kGrey70),
              borderRadius: BorderRadius.circular(AppSpacing.radiusThirty),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.kGrey70),
              borderRadius: BorderRadius.circular(AppSpacing.radiusThirty),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          items: [
            DropdownMenuItem(child: Text('Men'), value: 'Men'),
            DropdownMenuItem(child: Text('Women'), value: 'Women'),
            DropdownMenuItem(child: Text('Unisex'), value: 'Unisex'),
          ],
          onChanged: (value) {
            productController.gender.value = value!;
          },
          hint: Text('Select Gender'),
        )),
      ),
    ],
  );
}



Widget _buildImageUploadField(
    ProductController productController, BuildContext context) {

  RxList<dynamic> allImages = [...productController.selected_product['imageUrls']].obs;
  ever(productController.selectedImages, (callback) {
    allImages.value = [...productController.selected_product['imageUrls'], ...productController.selectedImages];
  },);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Obx(() =>Text('Product Images', style: TextStyle(fontSize: 16, color: productController.is_product.value ? Colors.red : Colors.black))),
      SizedBox(height: 8),
      Obx(() => Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: productController.is_product.value ? Colors.red : AppColors.kGrey70),
            ),
            child: allImages.isNotEmpty?
            GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: allImages.length+1, // Extra space for the add button
              itemBuilder: (context, index) {
                if (index == allImages.length) {
                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.kGrey70),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: productController.pickMultipleImages,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.grey[700],),
                            Text('Add More Images', style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else{
                  var image = allImages[index];
                  bool isNetworkImage = image is String; // Firebase images are URLs (Strings), local images are Files
                return Stack(
                  children: [
                    Container(
                        height: 120,
                        width: 120,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.kGrey70),
                            color: Colors.grey[300]),
                        //child: Image.network(productController.selected_product['imageUrls'][index], fit: BoxFit.cover, width: double.infinity)),
                  child: isNetworkImage
                      ? Image.network(image, fit: BoxFit.cover, width: double.infinity)
                      : Image.file(image as File, fit: BoxFit.cover, width: double.infinity),),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(

                        onTap: () {
                          if (isNetworkImage) {
                            //confirmation dialog
                            Get.dialog(
                              AlertDialog(
                                title: Text('Delete Image'),
                                content: Text('Are you sure you want to delete this image?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      productController.removeImagefromStorage(image, index);// Remove Firebase image
                                      allImages.removeAt(index);
                                      Get.back();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            allImages.removeAt(index);
                            productController.selected_product['imageUrls'].remove(image);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                );}
              },
            ):
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: productController.pickMultipleImages,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, color: Colors.grey[700], size: 50),
                    Text('Add Product Images', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            )
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 10),
              productController.is_product.value ? Text('Please add product images', style: TextStyle(color: Colors.red)) : SizedBox(),
            ],
          ),
        ],
      )),
    ],
  );
}

