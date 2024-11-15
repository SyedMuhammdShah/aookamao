import 'package:get/get.dart';

import '../modules/auth/controller/auth_controller.dart';
import '../services/auth_service.dart';
import '../services/firebase_notification_service.dart';
import '../services/referral_service.dart';

class AuthBinding extends Bindings {
  @override
  dependencies() {
    Get.put(() => AuthController());
  }
}