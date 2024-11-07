
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/retailer/retailer_modules/auth/auth_controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RetailerDrawer extends StatelessWidget {
  const RetailerDrawer({super.key});


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
            icon: Icons.settings,
            title: 'Setting',
            onTap: () => {},
          )
        ],
      ),
    );
  }

  _buildHeader() {
    final RetailerAuthController authController = Get.find<RetailerAuthController>();
    return  DrawerHeader(
      decoration: const BoxDecoration(color: AppColors.kPrimary),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: AppColors.kPrimary,
              size: 30,
            )),
          const SizedBox(
            height: 20,
          ),
          Text(
            authController.retailerUser.name,
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
