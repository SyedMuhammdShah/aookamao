import 'package:aookamao/admin/forms/add_products.dart';
import 'package:aookamao/admin/lists/order_list.dart';
import 'package:aookamao/admin/lists/products_list.dart';
import 'package:aookamao/app/data/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            onTap: () => {},
          ),
           _buildItem(
            icon: CupertinoIcons.add_circled_solid,
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
            onTap: () => {},
          ),
          _buildItem(
            icon: Icons.settings,
            title: 'Setting',
            onTap: () => {},
          )
        ],
      ),
    );
  }

  _buildHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(color: AppColors.kPrimary),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://media.istockphoto.com/id/1399611777/photo/portrait-of-a-smiling-little-brown-haired-boy-looking-at-the-camera-happy-kid-with-good.jpg?s=612x612&w=0&k=20&c=qZ63xODwrnc81wKK0dwc3tOEf2lghkQQKmotbF11q7Q='),
            radius: 40,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Mahdi Nazmi',
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