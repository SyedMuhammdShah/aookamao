// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aookamao/app/data/constants/constants.dart';
import 'package:aookamao/app/data/helpers/data.dart';
import 'package:aookamao/app/data/helpers/product_category.dart';
import 'package:aookamao/app/data/helpers/product_filter.dart';

class ProductModel {
  String id;
  List<dynamic> imageUrls;
  String name;
  double oldPrice;
  double currentPrice;
  String offPercentage;
  int totalRatings;
  double averageRatings;
  String description;
  String ownerName;
  ProductCategory category;
  ProductFilter filter;
  ProductModel({
    required this.id,
    required this.imageUrls,
    required this.name,
    required this.oldPrice,
    required this.currentPrice,
    required this.offPercentage,
    required this.totalRatings,
    required this.averageRatings,
    required this.description,
    required this.ownerName,
    required this.category,
    required this.filter,
  });
}

List<ProductModel> dummyProductList = [
  ProductModel(
    id: '1',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Lokman Sofa Premium',
    oldPrice: 599.99,
    currentPrice: 399.99,
    offPercentage: '30% Off',
    totalRatings: 320,
    averageRatings: 4.9,
    description: dummyTextDescription,
    ownerName: 'John Doe',
    category: ProductCategory.sofa,
    filter: ProductFilter.brand,
  ),
  ProductModel(
    id: '2',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'King Bed Leonard',
    oldPrice: 249.99,
    currentPrice: 199.99,
    offPercentage: '20% Off',
    totalRatings: 123,
    averageRatings: 5.0,
    description: dummyTextDescription,
    ownerName: 'Jane Smith',
    category: ProductCategory.bed,
    filter: ProductFilter.latest,
  ),
  ProductModel(
    id: '3',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Lorem Ipsum Chair',
    oldPrice: 199.99,
    currentPrice: 149.99,
    offPercentage: '25% Off',
    totalRatings: 256,
    averageRatings: 4.8,
    description: dummyTextDescription,
    ownerName: 'Robert Johnson',
    category: ProductCategory.chair,
    filter: ProductFilter.mostPopular,
  ),
  ProductModel(
    id: '4',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Classic Desk Lamp',
    oldPrice: 499.99,
    currentPrice: 399.99,
    offPercentage: '20% Off',
    totalRatings: 432,
    averageRatings: 4.7,
    description: dummyTextDescription,
    ownerName: 'Emily Wilson',
    category: ProductCategory.lamp,
    filter: ProductFilter.brand,
  ),
  ProductModel(
    id: '5',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Vintage Coffee Table',
    oldPrice: 799.99,
    currentPrice: 599.99,
    offPercentage: '25% Off',
    totalRatings: 520,
    averageRatings: 4.9,
    description: dummyTextDescription,
    ownerName: 'Michael Brown',
    category: ProductCategory.table,
    filter: ProductFilter.mostPopular,
  ),
  ProductModel(
    id: '6',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Leather Sectional Sofa',
    oldPrice: 149.99,
    currentPrice: 99.99,
    offPercentage: '33% Off',
    totalRatings: 180,
    averageRatings: 4.5,
    description: dummyTextDescription,
    ownerName: 'Sophia Davis',
    category: ProductCategory.sofa,
    filter: ProductFilter.brand,
  ),
  ProductModel(
    id: '7',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Modern Dining Table',
    oldPrice: 39.99,
    currentPrice: 29.99,
    offPercentage: '25% Off',
    totalRatings: 85,
    averageRatings: 4.6,
    description: dummyTextDescription,
    ownerName: 'David Clark',
    category: ProductCategory.table,
    filter: ProductFilter.mostPopular,
  ),
  ProductModel(
    id: '8',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Cozy Armchair',
    oldPrice: 199.99,
    currentPrice: 149.99,
    offPercentage: '25% Off',
    totalRatings: 210,
    averageRatings: 4.8,
    description: dummyTextDescription,
    ownerName: 'Olivia White',
    category: ProductCategory.chair,
    filter: ProductFilter.latest,
  ),
  ProductModel(
    id: '9',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Modern Premium Sofa',
    oldPrice: 149.99,
    currentPrice: 119.99,
    offPercentage: '20% Off',
    totalRatings: 174,
    averageRatings: 4.7,
    description: dummyTextDescription,
    ownerName: 'Daniel Lee',
    category: ProductCategory.chair,
    filter: ProductFilter.mostPopular,
  ),
  ProductModel(
    id: '10',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Rustic Bookshelf',
    oldPrice: 99.99,
    currentPrice: 79.99,
    offPercentage: '20% Off',
    totalRatings: 10,
    averageRatings: 4.6,
    description: dummyTextDescription,
    ownerName: 'Ava Martinez',
    category: ProductCategory.table,
    filter: ProductFilter.latest,
  ),
  ProductModel(
    id: '11',
    imageUrls: [
      AppAssets.kDummyProduct1,
      AppAssets.kDummyProduct2,
      AppAssets.kDummyProduct3,
    ],
    name: 'Accent Wooden Chairs',
    oldPrice: 29.99,
    currentPrice: 19.99,
    offPercentage: '33% Off',
    totalRatings: 68,
    averageRatings: 4.5,
    description: dummyTextDescription,
    ownerName: 'James Harris',
    category: ProductCategory.chair,
    filter: ProductFilter.brand,
  ),
];
