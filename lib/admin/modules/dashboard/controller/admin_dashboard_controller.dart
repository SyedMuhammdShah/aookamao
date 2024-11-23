import 'package:aookamao/admin/models/order_sales_model.dart';
import 'package:aookamao/enums/order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

import '../../../../constants/constants.dart';
import '../../../../enums/referral_account_type.dart';
import '../../../../enums/user_roles.dart';
import '../../../../models/order_model.dart';
import '../../../../models/referral_model.dart';
import '../../../../services/order_service.dart';
import '../../../../services/referral_service.dart';
import '../../../../user/data/constants/app_colors.dart';

class AdminDashboardController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _referralService = Get.find<ReferralService>();
  final _orderService = Get.find<OrderService>();
  RxInt usersCount = 0.obs;
  RxInt retailerCount = 0.obs;
  RxInt ordersCount = 0.obs;
  RxList<Referee> get allReferessList =>_referralService.allReferessList;
  RxList<Rx<OrderModel>> ordersList = <Rx<OrderModel>>[].obs;
  RxList<OrderSalesModel> orderData = <OrderSalesModel>[].obs;
  RxList<BarChartGroupData> ordersChartData = <BarChartGroupData>[].obs;
  @override
  void onInit() {
    super.onInit();
    getUsersCount();
    getRetailersCount();
    getOrdersCount();
    getAllReferess();
    getOrders();
    getOrdersData();
  }

  getUsersCount() {
    _firestore.collection(Constants.usersCollection).where('role',isEqualTo: userRoleToString(UserRoles.user)).snapshots()
        .listen((event) {
      usersCount.value = event.docs.length;
      print('Users count: ${event.docs.length}');
    });

  }
  getOrders()  {
    ordersList.bindStream(_orderService.getAllOrders());
  }
  // Method to get total suppliers count
   getRetailersCount() {
    _firestore.collection(Constants.usersCollection).where('role',isEqualTo: userRoleToString(UserRoles.retailer)).snapshots()
        .listen((event) {
      retailerCount.value = event.docs.length;
      print('Retailers count: ${event.docs.length}');
    });
   }

  // Method to get total orders count
   getOrdersCount() {
    _firestore.collection(Constants.ordersCollection).snapshots().listen((event) {
      ordersCount.value = event.docs.length;
      print('Orders count: ${event.docs.length}');
    });
  }


  getAllReferess() {
    _referralService.getAllRetailersReferees();
  }

  getOrdersData(){
    print('Getting orders data');
    ever(ordersList,(callback) {
      orderData.clear();
      print('Orders list length: ${callback.length}');
      callback.forEach((element) {
        String ordermonth = convertMonth(element.value.orderDate!.toDate().month);
        print('Order month: $ordermonth');
        print('Order year: ${element.value.orderDate!.toDate().year}');
        print('Order month number: ${element.value.orderDate!.toDate().month}');
        var orderyear = element.value.orderDate!.toDate().year;
        DateTime now = DateTime.now();

        OrderStatus orderStatus = element.value.orderStatus!;
        if(orderStatus == OrderStatus.delivered && orderyear == now.year){
         var index = orderData.indexWhere((element) => element.month == ordermonth);
          if(index != -1){
            orderData[index].orders = orderData[index].orders + 1;
          }else{
            orderData.add(OrderSalesModel(month: ordermonth, orders: 1));
          }
        }
      });
      print('oncallback');
     ordersChartData.value = generateOrdersChartData();
     ordersChartData.refresh();
    },);
  }

  RxList<BarChartGroupData> generateOrdersChartData() {
    print('Generating orders chart data');
    return  List.generate(orderData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: orderData[index].orders.toDouble(),
            color: AppColors.kPrimary,
            width: 15,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    }).obs;
  }
@override
  void dispose() {
    super.dispose();
    allReferessList.close();
    ordersList.close();
    orderData.close();
    ordersChartData.close();
    usersCount.close();
    retailerCount.close();
    ordersCount.close();
  }
}



String convertMonth(int month){
  switch(month){
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return 'Jan';
  }
}