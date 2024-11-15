

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? productId;
  final List<dynamic>? imageUrls;
  final String? name;
  final double? price;
  final String? fabricType;
  final double? fabricLength;
  final double? fabricWidth;
  final String? color;
  final String? design;
  final String? gender;
  final String? weight;
  final String? materialComposition;
  final String? washCare;
  final int? stockQuantity;
  final String? season;
  final String? countryOfOrigin;
  final String? createdBy;
  final Timestamp? createdAt;


  ProductModel({
    this.productId,
    this.imageUrls,
    this.name,
    this.price,
    this.fabricType,
    this.fabricLength,
    this.fabricWidth,
    this.color,
    this.design,
  this.gender,
  this.weight,
  this.materialComposition,
  this.washCare,
  this.stockQuantity,
  this.season,
  this.countryOfOrigin,
  this.createdBy,
  this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'],
      imageUrls: map['imageUrls'],
      name: map['name'],
      price: map['price'],
      fabricType: map['fabricType'],
      fabricLength: map['fabricLength'],
      fabricWidth: map['fabricWidth'],
      color: map['color'],
      design: map['design'],
      gender: map['gender'],
      weight: map['weight'],
      materialComposition: map['materialComposition'],
      washCare: map['washCare'],
      stockQuantity: map['stockQuantity'],
      season: map['season'],
      countryOfOrigin: map['countryOfOrigin'],
      createdBy: map['createdBy'],
      createdAt: map['createdAt'],
    );
  }



}
