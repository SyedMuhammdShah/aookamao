
import 'package:aookamao/services/auth_service.dart';
import 'package:aookamao/services/firebase_notification_service.dart';
import 'package:aookamao/services/order_service.dart';
import 'package:aookamao/services/transaction_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aookamao/bindings/home_binding.dart';
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


  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const Main());
}
initServices() async {
  await Get.putAsync(()=> FirebasePushNotificationService().init());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => ReferralService().init());
  await Get.putAsync(() => OrderService().init());
  Get.lazyPut(() => TransactionService(), fenix: true);
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
            title: 'AOO KAMAO',
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
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
