import 'package:get/get.dart';

import '../../../../models/referral_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/referral_service.dart';

class RetailerDashboardController extends GetxController {
  final _referralService = Get.find<ReferralService>();
  final _authService = Get.find<AuthService>();
  RxBool isLoading = false.obs;
  RxString totalReferralEarnings = "".obs;
  RxString get totalReferrals => _referralService.refereesList.length.toString().obs;

  RxList<Referee> get refereesList => _referralService.refereesList;
  RxList<Referee> get thisMonthRefereesList => _referralService.thisMonthRefereesList;


}