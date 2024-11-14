import 'package:aookamao/admin/modules/dashboard/admin_dashboard.dart';
import 'package:aookamao/admin/modules/products/add_products.dart';
import 'package:aookamao/admin/modules/orders/order_list.dart';
import 'package:aookamao/admin/modules/profile/admin_profile_view.dart';
import 'package:aookamao/admin/modules/referrals/all_referees_view.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../modules/products/products_list.dart';
import '../modules/retailers/retailers.dart';

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
              Get.to(AdminDashboard()),
            },
          ),
           _buildItem(
               icon: Icons.store_outlined,
               title: 'Retailers',
               onTap: () => {
                 Get.to(RetailersScreen()),
               }
           ),
           //referral
          _buildItem(
            icon: CupertinoIcons.person_2,
            title: 'Referees',
            onTap: () => {
              Get.to(AllRefereesView()),
            }
          ),
           _buildItem(
            icon: CupertinoIcons.add_circled,
            title: 'Add Products',
            onTap: () => {
              Get.to(AddProducts()),
            },
          ),
           _buildItem(
            icon: CupertinoIcons.list_bullet_below_rectangle,
            title: 'Order List',
            onTap: () => {
              Get.to(OrderList()),
            },
          ),
          _buildItem(
            icon: CupertinoIcons.list_bullet_below_rectangle,
            title: 'Product List',
            onTap: () => {
              Get.to(ProductsList())
            },
          ),
          _buildItem(
            icon: CupertinoIcons.person,
            title: 'Profile',
            onTap: () => {
              Get.to(AdminProfileView())
            },
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    final _authService = Get.find<AuthService>();
    return  DrawerHeader(
      decoration: BoxDecoration(color: AppColors.kPrimary),
      child: Column(
        children: [
          CircleAvatar(
            child: Icon(
              CupertinoIcons.person,
              size: 50,
              color: Colors.white,
            ),
            radius: 40,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            _authService.currentUser.value!.name,
            style: TextStyle(color: Colors.white, fontSize: 15),
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
