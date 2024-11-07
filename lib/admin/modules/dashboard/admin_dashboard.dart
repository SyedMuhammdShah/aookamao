
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';

import '../../../user/modules/auth/auth/auth_controller.dart';
import '../../components/adminAppBar.dart';
import '../../components/admin_drawer.dart';

class AdminDashboard extends StatelessWidget {
  // Method to get total users count
  Stream<int> getUsersCount() {
    return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) => snapshot.docs.length);
  }

  // Method to get total suppliers count
  Stream<int> getSuppliersCount() {
    return FirebaseFirestore.instance.collection('suppliers').snapshots().map((snapshot) => snapshot.docs.length);
  }

  // Method to get total orders count
  Stream<int> getOrdersCount() {
    return FirebaseFirestore.instance.collection('orders').snapshots().map((snapshot) => snapshot.docs.length);
  }

  // Method to get total referrals count
  Stream<int> getReferralsCount() {
    return FirebaseFirestore.instance.collection('referrals').snapshots().map((snapshot) => snapshot.docs.length);
  }
// Fetch top products based on sales count
  Stream<List<Map<String, dynamic>>> getTopProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }
  // Placeholder data for product sales and orders
  final List<Map<String, dynamic>> productSalesData = [
    {'month': 'Jan', 'sales': 500},
    {'month': 'Feb', 'sales': 800},
    {'month': 'Mar', 'sales': 600},
    {'month': 'Apr', 'sales': 900},
    {'month': 'May', 'sales': 1200},
  ];

  final List<Map<String, dynamic>> ordersData = [
    {'month': 'Jan', 'orders': 150},
    {'month': 'Feb', 'orders': 200},
    {'month': 'Mar', 'orders': 180},
    {'month': 'Apr', 'orders': 220},
    {'month': 'May', 'orders': 300},
  ];

  // Function to generate sales chart data
  List<FlSpot> _generateSalesChartData() {
    return List.generate(productSalesData.length, (index) {
      return FlSpot(index.toDouble(), productSalesData[index]['sales'].toDouble());
    });
  }

  // Function to generate orders chart data
  List<BarChartGroupData> _generateOrdersChartData() {
    return List.generate(ordersData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: ordersData[index]['orders'].toDouble(),
            color: AppColors.kPrimary,
            width: 15,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: adminAppBar(user: authController.currentUser.value!,),
      drawer: AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Row for Users, Suppliers, Orders, and Referrals Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Users', Icons.person, getUsersCount()),
                  _buildStatCard('Suppliers', Icons.store, getSuppliersCount()),
                  _buildStatCard('Orders', Icons.shopping_bag, getOrdersCount()),
                  //_buildStatCard('Referrals', Icons.people, getReferralsCount()),
                ],
              ),
              SizedBox(height: 20),

              // Section for Sales and Orders Graphs
              Text('Product Sales & Orders Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Product Sales Graph
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Product Sales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    // Map the index to month names
                                    int index = value.toInt();
                                    return Text(productSalesData[index]['month']);
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _generateSalesChartData(),
                                isCurved: true,
                                color: AppColors.kPrimary,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppColors.kPrimary.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Orders Graph
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    // Map the index to month names
                                    int index = value.toInt();
                                    return Text(ordersData[index]['month']);
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                            ),
                            borderData: FlBorderData(show: true),
                            barGroups: _generateOrdersChartData(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Top Products List
              Text('Top 5 Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: getTopProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var topProducts = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: topProducts.length,
                    itemBuilder: (context, index) {
                      var product = topProducts[index];
                      String name = product['name'] ?? 'Unknown';
                      int salesCount = product['salesCount'] ?? 0;
                      List<String> imageUrls = product['imageUrls'] is List
                          ? List<String>.from(product['imageUrls'])
                          : [];

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: imageUrls.isNotEmpty
                              ? Image.network(imageUrls[0], width: 50, height: 50, fit: BoxFit.cover)
                              : Icon(Icons.image, size: 50),
                          title: Text(name),
                          subtitle: Text('Sales: $salesCount'),
                          onTap: () {
                            // Add navigation or actions for product details if needed
                          },
                        ),
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Widget to build a statistics card
  Widget _buildStatCard(String title, IconData icon, Stream<int> countStream) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<int>(
            stream: countStream,
            builder: (context, snapshot) {
              int count = snapshot.data ?? 0;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 40, color: AppColors.kPrimary),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    count.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
