import 'dart:io';
import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/admin/controller/product_controller.dart';
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:aookamao/app/data/constants/app_spacing.dart';
import 'package:aookamao/app/modules/auth/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddProducts extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); // Add form key for validation


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
            Text(
              'Add / Update Unstitch Cloth',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,  // Add form key
                  child: Column(
                    children: [
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
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Form is valid, proceed to save
                            productController.addProduct(); // Save Product logic
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'Save Product',
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
      String? Function(String?) validator, [TextInputType? keyboardType]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
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
        Text('Gender: ', style: TextStyle(fontSize: 16)),
        SizedBox(width: 16),
        Expanded(
          child: Obx(() => DropdownButtonFormField<String>(
                value: productController.gender.value.isEmpty
                    ? null
                    : productController.gender.value,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.kGrey70),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusThirty),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.kGrey70),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusThirty),
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Images', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: productController.pickMultipleImages, // Trigger the multi-image picker
          child: Obx(() => Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.kGrey70),
                ),
                child: productController.selectedImages.isEmpty
                    ? Icon(Icons.add_a_photo, color: Colors.grey[700], size: 50)
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: productController.selectedImages.length,
                        itemBuilder: (context, index) {
                          File imageFile = productController.selectedImages[index];
                          return Image.file(imageFile, fit: BoxFit.cover);
                        },
                      ),
              )),
        ),
      ],
    );
  }

