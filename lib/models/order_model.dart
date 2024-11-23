import 'package:aookamao/enums/order_status.dart';
import 'package:aookamao/enums/payment_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
 final String? orderId;
 final OrderStatus? orderStatus;
  final double? totalAmount;
  final double? shippingCharges;
  final double? subTotal;
  final Timestamp? orderDate;
  final PaymentType? paymentType;
  final String? transactionId;
  final String? customerId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? customerAddress;
  final String? customerCity;
  final List<OrderItemModel> orderItems;

  OrderModel({
    this.orderId,
    this.orderStatus,
    this.totalAmount,
    this.shippingCharges,
    this.subTotal,
    this.orderDate,
    this.paymentType,
    this.transactionId,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.customerAddress,
    this.customerCity,
    required this.orderItems,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      orderStatus: orderStatusFromString(map['orderStatus']),
      totalAmount: map['totalAmount'],
      shippingCharges: map['shippingCharges'],
      subTotal: map['subTotal'],
      orderDate: map['orderDate'],
      paymentType: stringToPaymentType(map['paymentType']),
      transactionId: map['transactionId'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],
      customerPhone: map['customerPhone'],
      customerAddress: map['customerAddress'],
      customerCity: map['customerCity'],
      orderItems: List<OrderItemModel>.from(map['orderItems']?.map((x) => OrderItemModel.fromMap(x))),
    );
  }
  factory OrderModel.fromDoc(QueryDocumentSnapshot<Map<String,dynamic>> map) {
    return OrderModel(
      orderId: map.id,
      orderStatus: orderStatusFromString(map.data()['orderStatus']),
      totalAmount: map.data()['totalAmount'],
      shippingCharges: map.data()['shippingCharges'],
      subTotal: map.data()['subTotal'],
      orderDate: map.data()['orderDate'],
      paymentType: stringToPaymentType(map.data()['paymentType']),
      transactionId: map.data()['transactionId'],
      customerId: map.data()['customerId'],
      customerName: map.data()['customerName'],
      customerEmail: map.data()['customerEmail'],
      customerPhone: map.data()['customerPhone'],
      customerAddress: map.data()['customerAddress'],
      customerCity: map.data()['customerCity'],
      orderItems: List<OrderItemModel>.from(map.data()['orderItems']?.map((x) => OrderItemModel.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderStatus': orderStatusToString(orderStatus!),
      'totalAmount': totalAmount,
      'shippingCharges': shippingCharges,
      'subTotal': subTotal,
      'orderDate': orderDate,
      'paymentType': paymentTypeToString(paymentType!),
      'transactionId': transactionId,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerCity': customerCity,
      'orderItems': orderItems.map((x) => x.toMap()).toList(),
    };
  }
}

class OrderItemModel {
  final String? productId;
  final String? productName;
  final double? price;
  final int? quantity;
  final String? imageUrl;
  OrderItemModel({
    this.productId,
    this.productName,
    this.price,
    this.quantity,
    this.imageUrl,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'],
      productName: map['productName'],
      price: map['price'],
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

class MyPurchaseModel {
  final String? productId;
  final String? productName;
  final double? price;
  final int? quantity;
  final String? imageUrl;
  final OrderStatus? orderStatus;
  final int indexOfOrder;

  MyPurchaseModel({
    this.productId,
    this.productName,
    this.price,
    this.quantity,
    this.imageUrl,
    this.orderStatus,
    required this.indexOfOrder,
  });
}