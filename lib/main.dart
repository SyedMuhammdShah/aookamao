import 'package:aookamao/admin/modules/products/controller/product_controller.dart';
import 'package:aookamao/admin/modules/retailers/controller/retailer_controller.dart';
import 'package:aookamao/modules/auth/controller/auth_controller.dart';
import 'package:aookamao/modules/auth/referral_view.dart';
import 'package:aookamao/retailer/retailer_modules/dashboard/controller/retailer_dashboard_controller.dart';
import 'package:aookamao/retailer/retailer_modules/subscription/subscription_controller/subscription_controller.dart';
import 'package:aookamao/services/auth_service.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/bindings/home_binding.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'modules/splash/splash_view.dart';
import 'services/referral_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
 await GetStorage.init();
 await initServices();
  // Controllers
  Get.put(AuthController());
 Get.put(ProductController());
 Get.put(SubscriptionController());
 Get.put(RetailerController());
 Get.put(RetailerDashboardController());


  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const Main(),
    ),
  );
}
initServices() async {
  print('starting services ...');
  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
  await Get.putAsync(()=> FirebasePushNotificationService().init());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => ReferralService().init());
  print('All services started...');
}
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(
            title: 'aookamao',
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
            defaultTransition: Transition.fadeIn,
            theme: AppTheme.lightTheme,
            initialBinding: HomeBinding(),
            home: const SplashView(),
          ),
        );
      },
    );
  }
}
