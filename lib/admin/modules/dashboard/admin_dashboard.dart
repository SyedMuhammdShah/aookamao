
import 'package:aookamao/admin/modules/dashboard/controller/admin_dashboard_controller.dart';
import 'package:aookamao/constants/constants.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(()=> Column(
              children: [
                // Row for Users, Suppliers, Orders, and Referrals Count
                SizedBox(
                  height: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Customers', Icons.person, _adminController.usersCount.value),
                      _buildStatCard('Retailers', Icons.store, _adminController.retailerCount.value),
                      _buildStatCard('Orders', Icons.shopping_bag, _adminController.ordersCount.value),
                      _buildStatCard('Referrals', Icons.people, _adminController.allReferessList.length),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section for Sales and Orders Graphs
                const Text('Product Sales & Orders Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Product Sales Graph
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Product Sales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
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
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _generateSalesChartData(),
                                isCurved: true,
                                color: AppColors.kPrimary,
                                dotData: const FlDotData(show: false),
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

                const SizedBox(height: 20),

                // Orders Graph
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: Obx(() =>  BarChart(
                              BarChartData(
                                gridData: const FlGridData(show: false),
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
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                const SizedBox(height: 20),

                // Top Products List
                const Text('Top 5 Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getTopProducts(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var topProducts = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topProducts.length,
                      itemBuilder: (context, index) {
                        var product = topProducts[index];
                        String name = product['name'] ?? 'Unknown';
                        int salesCount = product['salesCount'] ?? 0;
                        List<String> imageUrls = product['imageUrls'] is List
                            ? List<String>.from(product['imageUrls'])
                            : [];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: imageUrls.isNotEmpty
                                ? Image.network(imageUrls[0], width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.image, size: 50),
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(10),
          child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 40, color: AppColors.kPrimary),
                  const SizedBox(height: 5),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: AppTypography.kSemiBold12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      count.toString(),
                      style: AppTypography.kSemiBold16.copyWith(color: AppColors.kSecondary),
                    ),
                  ),
                ],
          ),
        ),
      ),
    );
  }
}
