
import 'package:aookamao/admin/modules/dashboard/controller/admin_dashboard_controller.dart';
import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';

import '../../../services/auth_service.dart';
import '../../components/adminAppBar.dart';
import '../../components/admin_drawer.dart';

class AdminDashboard extends StatefulWidget {

   AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _adminController = Get.find<AdminDashboardController>();



  // Method to get total users count
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
    {'month': 'Jun', 'orders': 250},
  ];

  // Function to generate sales chart data
  List<FlSpot> _generateSalesChartData() {
    return List.generate(productSalesData.length, (index) {
      return FlSpot(index.toDouble(), productSalesData[index]['sales'].toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
   final _authService = Get.find<AuthService>();

    return Scaffold(
      appBar: adminAppBar(user: _authService.currentUser.value!,),
      drawer: AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(()=> Column(
              children: [
                // Row for Users, Suppliers, Orders, and Referrals Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard('Customers', Icons.person, _adminController.usersCount.value),
                    _buildStatCard('Retailers', Icons.store, _adminController.retailerCount.value),
                    _buildStatCard('Orders', Icons.shopping_bag, _adminController.ordersCount.value),
                    _buildStatCard('Referrals', Icons.people, _adminController.allReferessList.length),
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
                          child: Obx(() =>  BarChart(
                              BarChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        // Map the index to month names
                                        int index = value.toInt();
                                        return Text(_adminController.orderData[index].month);
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                alignment: BarChartAlignment.start,
                                barTouchData: BarTouchData(enabled: true),
                                borderData: FlBorderData(show: false),
                                extraLinesData: ExtraLinesData(horizontalLines: [
                                  HorizontalLine(y: 0, color: Colors.black.withOpacity(0.2)),
                                ]
                                ),

                                barGroups: _adminController.ordersChartData.value,
                              ),
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
      ),
    );
  }

  // Widget to build a statistics card
  Widget _buildStatCard(String title, IconData icon,int count) {
    return Expanded(
      child: SizedBox(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 40, color: AppColors.kPrimary),
                    SizedBox(height: 5),
                    Text(
                      title,
                      style: AppTypography.kSemiBold12,
                    ),
                    SizedBox(height: 5),
                    Text(
                      count.toString(),
                      style: AppTypography.kSemiBold16.copyWith(color: AppColors.kPrimary),
                    ),
                  ],
            ),
          ),
        ),
      ),
    );
  }
}
