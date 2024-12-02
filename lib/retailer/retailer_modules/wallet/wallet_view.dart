import 'package:aookamao/admin/components/transaction_card.dart';
import 'package:aookamao/retailer/components/retailer_appbar.dart';
import 'package:aookamao/retailer/retailer_modules/dashboard/controller/retailer_dashboard_controller.dart';
import 'package:aookamao/user/modules/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../user/data/constants/app_colors.dart';
import '../../../user/modules/widgets/dialogs/withDraw_dialog.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../components/retailer_drawer.dart';


class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<RetailerDashboardController>();
    return Scaffold(
      appBar: const RetailerAppBar(title: 'Wallet'),
      drawer: const RetailerDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRewardBalanceCard(),
              const SizedBox(height: 16),
              Text(
                "Transaction History",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              _controller.retailerTransactions.isEmpty
                  ? const Center(
                      child: Text("No Transactions Yet!"),
                    )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.retailerTransactions.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                      transaction: _controller.retailerTransactions[index].obs,
                      onTap: (){});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildRewardBalanceCard() {
  final _controller = Get.find<RetailerDashboardController>();
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
                "Wallet Balance",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                "Rs.${_controller.retailerWallet.value.balance.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _controller.retailerWallet.value.balance > 100 ? AppColors.kSecondary : Colors.grey,
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
                      balance: _controller.retailerWallet.value.balance));
            },
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text("WithDraw"),
          ),
        ],
      ),
    ),
  );
}

