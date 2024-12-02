import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/modules/widgets/dialogs/confirm_withdraw_dialog.dart';
import 'package:aookamao/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/referral_model.dart';
import '../../../services/auth_service.dart';
import '../../controllers/home_controller.dart';
import '../home/components/home_appBar.dart';
import '../profile/edit_profile.dart';
import 'package:intl/intl.dart';
import '../widgets/dialogs/withDraw_dialog.dart';
class MyReferralsView extends StatelessWidget {


  const MyReferralsView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
     final _authService = Get.find<AuthService>();
     final _controller = Get.find<HomeController>();
    return Scaffold(
      appBar: HomeAppBar(
        user: _authService.currentUser.value!,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRewardBalanceCard(_controller.userWallet.value.balance),
              const SizedBox(height: 16),
              _buildReferralCodeCard(_controller.currentReferralDetails.value.referralCode),
              const SizedBox(height: 16),
              _buildRefereesList(_controller.currentReferralDetails.value.referees ?? []),
            ],
          ),
        ),
      ),
    );
  }

  // Reward Balance Card
  Widget _buildRewardBalanceCard(double rewardBalance) {
    final _controller = Get.find<HomeController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.wallet,color: AppColors.kPrimary, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reward Balance",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rs.${rewardBalance.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: rewardBalance > 100 ? AppColors.kSecondary : Colors.grey,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if(!_controller.isUserHaveAccount())
                  {
                    showErrorSnackbar("Please Add Your Bank Details In Profile Section!");
                    Get.to<Widget>(()=> const EditProfile());
                    return;
                  }
                Get.dialog(
                    WithDrawDialog(
                        amountController: _controller.amountController,
                        withDrawCallBack: () =>_controller.withDrawMoney(),
                        balance: rewardBalance));
              },
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text("WithDraw"),
            ),
          ],
        ),
      ),
    );
  }

  // Referral Code Card
  Widget _buildReferralCodeCard(String? referralCode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
             Icon(Icons.qr_code, color:AppColors.kPrimary, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Referral Code",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  referralCode ?? "N/A",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
      ),
    );
  }

  // Referees List
  Widget _buildRefereesList(List<Referee> referees) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Referees",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            referees.isEmpty
                ? const Text(
              "No referees found.",
              style: TextStyle(color: Colors.grey),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: referees.length,
              itemBuilder: (context, index) {
                final referee = referees[index];
                return _buildRefereeTile(referee);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Single Referee Tile
  Widget _buildRefereeTile(Referee referee) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(referee.refereeName ?? "Unknown User",
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Referred on: ${DateFormat('dd MMM,yyyy').format(referee.referralDate.toDate())}"),
    );
  }
}
