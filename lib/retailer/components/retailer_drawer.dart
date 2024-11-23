
import 'package:aookamao/admin/modules/rewards/rewards_view.dart';
import 'package:aookamao/retailer/retailer_modules/profile/profile_view.dart';
import 'package:aookamao/services/auth_service.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/modules/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../retailer_modules/Reward/rewards_view.dart';
import '../retailer_modules/referrals/all_referrals_view.dart';

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
            icon:  Icons.people,
            title: 'Referrals',
            onTap: () => {
              Scaffold.of(context).closeDrawer(),
              Get.to<Widget>(() => const AllReferralsView())
            },
          ),
          _buildItem(
            icon:  Icons.wallet_giftcard,
            title: 'Rewards',
            onTap: () => {
              Scaffold.of(context).closeDrawer(),
              Get.to<Widget>(() => const RetailerRewardsView())
            },
          ),
          _buildItem(
            icon: Icons.settings,
            title: 'Profile',
            onTap: () => {
              Scaffold.of(context).closeDrawer(),
              Get.to<Widget>(() => const ProfileView())
            },
          )
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
