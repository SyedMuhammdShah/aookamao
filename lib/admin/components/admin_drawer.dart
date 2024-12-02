import 'package:aookamao/admin/modules/dashboard/admin_dashboard.dart';
import 'package:aookamao/admin/modules/products/add_products.dart';
import 'package:aookamao/admin/modules/orders/orders_view.dart';
import 'package:aookamao/admin/modules/profile/admin_profile_view.dart';
import 'package:aookamao/admin/modules/referrals/all_referees_view.dart';
import 'package:aookamao/admin/modules/rewards/rewards_view.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../modules/products/products_list.dart';
import '../modules/retailers/retailers.dart';
import '../modules/transactions/transactions_view.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});
  @override
  Widget build(BuildContext context) {


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          _buildItem(
            icon: CupertinoIcons.home,
            title: 'Home',
            onTap: () => {
              Get.to<Widget>(()=> AdminDashboard()),
            },
          ),
           _buildItem(
               icon: Icons.store_outlined,
               title: 'Suppliers',
               onTap: () => {
                 Get.to<Widget>(()=> const RetailersScreen()),
               }
           ),
           //referral
          _buildItem(
            icon: CupertinoIcons.person_2,
            title: 'Referees',
            onTap: () => {
              Get.to<Widget>(()=> const AllRefereesView()),
            }
          ),
           _buildItem(
            icon: CupertinoIcons.add_circled,
            title: 'Add Products',
            onTap: () => {
              Get.to<Widget>(()=> AddProducts()),
            },
          ),
           _buildItem(
            icon: CupertinoIcons.shopping_cart,
            title: 'Order',
            onTap: () => {
              Get.to<Widget>(()=> OrdersView()),
            },
          ),
          _buildItem(
            icon: CupertinoIcons.gift,
            title: 'Rewards',
            onTap: () => {
              Get.to<Widget>(()=> const RewardsView()),
            },
          ),
          _buildItem(
            icon: CupertinoIcons.list_bullet_below_rectangle,
            title: 'Product List',
            onTap: () => {
            Get.to<Widget>(()=> ProductsList())
            },
          ),
          _buildItem(
            icon: CupertinoIcons.money_dollar,
            title: 'Transactions',
            onTap: () => {
              Get.to<Widget>(() => const TransactionsView())
            },
          ),
          _buildItem(
            icon: CupertinoIcons.person,
            title: 'Profile',
            onTap: () => {
              Get.to<Widget>(()=> const AdminProfileView())
            },
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    final _authService = Get.find<AuthService>();
    return  DrawerHeader(
      decoration: const BoxDecoration(color: AppColors.kPrimary),
      child: Column(
        children: [
          const CircleAvatar(
            child: Icon(
              CupertinoIcons.person,
              size: 50,
              color: Colors.white,
            ),
            radius: 40,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            _authService.currentUser.value!.name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          )
        ],
      ),
    );
  }

  _buildItem(
      {required IconData icon,
      required String title,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      minLeadingWidth: 5,
    );
  }
}
