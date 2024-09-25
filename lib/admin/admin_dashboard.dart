import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/admin/components/admin_drawer.dart';
import 'package:aookamao/admin/components/dimension.dart';
import 'package:aookamao/app/modules/auth/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: adminAppBar(user: authController.currentUser.value!,),
      drawer: AdminDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
              Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                      const SizedBox(width: Dimensions.paddingSizeSmall),
                     // Image.asset(Images.wallet, width: 60, height: 60),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(
                          'balance'.tr,
                          style: TextStyle(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                         Text(
                         '',
                          style: TextStyle(fontSize: 24, color: Theme.of(context).cardColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) 

                      ]),
                    ]),
                    const SizedBox(height: 30),
                    Row(children: [

                      // EarningWidget(
                      //   title: 'today'.tr,
                      //   amount: profileController.profileModel?.todaysEarning,
                      // ),
                      // Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      // EarningWidget(
                      //   title: 'this_week'.tr,
                      //   amount: profileController.profileModel?.thisWeekEarning,
                      // ),
                      // Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      // EarningWidget(
                      //   title: 'this_month'.tr,
                      //   amount: profileController.profileModel?.thisMonthEarning,
                      // ),

                    ]),

                  ]),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                     Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                      const SizedBox(width: Dimensions.paddingSizeSmall),
                     // Image.asset(Images.wallet, width: 60, height: 60),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(
                          'balance'.tr,
                          style: TextStyle(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                         Text(
                         '',
                          style: TextStyle(fontSize: 24, color: Theme.of(context).cardColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) 

                      ]),
                    ]),
                    const SizedBox(height: 30),
                    Row(children: [

                      // EarningWidget(
                      //   title: 'today'.tr,
                      //   amount: profileController.profileModel?.todaysEarning,
                      // ),
                      // Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      // EarningWidget(
                      //   title: 'this_week'.tr,
                      //   amount: profileController.profileModel?.thisWeekEarning,
                      // ),
                      // Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      // EarningWidget(
                      //   title: 'this_month'.tr,
                      //   amount: profileController.profileModel?.thisMonthEarning,
                      // ),

                    ]),

                  ]),
                ),
                Spacer(),
                 Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                      const SizedBox(width: Dimensions.paddingSizeSmall),
                     // Image.asset(Images.wallet, width: 60, height: 60),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(
                          'balance'.tr,
                          style: TextStyle(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                         Text(
                         '',
                          style: TextStyle(fontSize: 24, color: Theme.of(context).cardColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) 

                      ]),
                    ]),
                    const SizedBox(height: 30),
                    Row(children: [

                      // EarningWidget(
                      //   title: 'today'.tr,
                      //   amount: profileController.profileModel?.todaysEarning,
                      // ),
                      // Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      // EarningWidget(
                      //   title: 'this_week'.tr,
                      //   amount: profileController.profileModel?.thisWeekEarning,
                      // ),
                      // Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      // EarningWidget(
                      //   title: 'this_month'.tr,
                      //   amount: profileController.profileModel?.thisMonthEarning,
                      // ),

                    ]),

                  ]),
                ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}