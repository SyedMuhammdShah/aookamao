import 'package:aookamao/admin/modules/products/controller/product_controller.dart';
import 'package:aookamao/user/modules/auth/auth/auth_controller.dart';
import 'package:aookamao/retailer/retailer_modules/auth/auth_controller/auth_controller.dart';
import 'package:aookamao/retailer/retailer_modules/subscription/subscription_controller/subscription_controller.dart';
import 'package:aookamao/selection_screen.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/user/bindings/home_binding.dart';
import 'package:aookamao/user/data/constants/constants.dart';
import 'package:aookamao/user/modules/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 //await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebasePushNotificationService().initialise();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  // Controllers
  Get.put(AuthController());
 Get.put(ProductController());
 Get.put(SubscriptionController());
 Get.put(RetailerAuthController());
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
