import 'package:aookamao/admin/components/adminAppBar.dart';
import 'package:aookamao/enums/user_bank_type.dart';
import 'package:aookamao/user/data/constants/app_colors.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:aookamao/user/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../enums/transaction_status.dart';
import '../../../enums/transaction_types.dart';
import '../../../enums/user_roles.dart';
import '../../../models/transaction_model.dart';
import '../../../models/user_model.dart';
import '../../../models/wallet_model.dart';
import 'controller/transaction_controller.dart';
import 'package:intl/intl.dart';

class TransactionDetails extends StatefulWidget {
  final Rx<TransactionModel> transaction;
  const TransactionDetails({super.key, required this.transaction});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final _transactionController = Get.find<TransactionController>();
  UserModel? get user => _transactionController.userDetails.value;

  WalletModel? get wallet => _transactionController.userWallet.value;

  @override
  void initState() {
    super.initState();
    _transactionController.getUserDetails(userId:widget.transaction.value.walletId ?? '');
    ever(_transactionController.transactionsList, (callback) {
      widget.transaction.value = _transactionController.transactionsList
          .firstWhere((element) => element.transactionId == widget.transaction.value.transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar(Title: 'TransactionDetails'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Details Card
                _buildDetailsCard(
                  title: "Transaction Details",
                  children: [
                    _buildDetailRow(
                        "Transaction ID", widget.transaction.value.transactionId),
                    _buildDetailRow("Type",
                        transactionTypesToString(widget.transaction.value.transactionType!)),
                    _buildDetailRow(
                      "Date",
                      widget.transaction.value.transactionDate != null
                          ? DateFormat('dd MMM yyyy, hh:mm a').format(
                          widget.transaction.value.transactionDate!.toDate())
                          : 'N/A',
                    ),
                    _buildDetailRow("Amount",
                        "${widget.transaction.value.transactionAmount?.toStringAsFixed(
                            2)} PKR"),
                    _buildDetailRow("Status", transactionStatusToString(
                        widget.transaction.value.transactionStatus)),
                  ],
                ),
                const SizedBox(height: 16),

                // User Details Card
                _buildDetailsCard(
                  title: "User Details",
                  children: [
                    _buildDetailRow("User ID", user?.uid),
                    _buildDetailRow("Name", user?.name),
                    _buildDetailRow("Email", user?.email),
                    _buildDetailRow("Address", user?.address ?? "N/A"),
                    _buildDetailRow("User Type",
                        user?.role == UserRoles.user ? "Customer" : user
                            ?.role == UserRoles.retailer ? "Supplier" : ''),
                    _buildDetailRow(
                        "Bank", userBankTypeToString(user?.userBankType)),
                    _buildDetailRow(
                        "Account No.", user?.accountNumber ?? "N/A"),
                    _buildDetailRow(
                        "Account Holder", user?.accountHolderName ?? "N/A"),
                  ],
                ),
                const SizedBox(height: 16),

                // Wallet Details Card
                _buildDetailsCard(
                  title: "Wallet Details",
                  children: [
                    _buildDetailRow("Wallet ID", wallet?.walletId),
                    _buildDetailRow(
                        "Balance", "${wallet?.balance.toStringAsFixed(2)} PKR"),
                  ],
                ),
                const SizedBox(height: 32),

                // Action Buttons
                if(_transactionController.isLoading.value)
                  const Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
                  )),
                if (widget.transaction.value.transactionType == TransactionType.Withdrawal &&
                    widget.transaction.value.transactionStatus == TransactionStatus.pending)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PrimaryButton(
                        text: "Reject",
                        onTap: (){
                          TransactionModel trandata = TransactionModel(
                            transactionId: widget.transaction.value.transactionId,
                            transactionStatus: TransactionStatus.rejected,
                            transactionType: TransactionType.Withdrawal,
                            transactionAmount: widget.transaction.value.transactionAmount,
                            transactionDate: widget.transaction.value.transactionDate,
                            walletId: widget.transaction.value.walletId,
                            userName: widget.transaction.value.userName,
                            userRole: widget.transaction.value.userRole,
                          );
                          _transactionController.updateTransactionStatus(transaction: trandata);
                        },
                        width: 150,
                        height: 50,
                        color: AppColors.kError,
                      ),
                      PrimaryButton(
                        text: "Approve",
                        onTap: (){
                          TransactionModel trandata = TransactionModel(
                            transactionId: widget.transaction.value.transactionId,
                            transactionStatus: TransactionStatus.approved,
                            transactionType: TransactionType.Withdrawal,
                            transactionAmount: widget.transaction.value.transactionAmount,
                            transactionDate: widget.transaction.value.transactionDate,
                            walletId: widget.transaction.value.walletId,
                            userName: widget.transaction.value.userName,
                            userRole: widget.transaction.value.userRole,
                          );
                          _transactionController.updateTransactionStatus(transaction: trandata);
                        },
                        color: AppColors.kSuccess,
                        height: 50,
                        width: 150,
                      ),
                    ],
                  ),
              ],
            ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildDetailsCard(
      {required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                title,
                style: AppTypography.kSemiBold16
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.kSemiBold14,
          ),
          Text(
            value ?? "N/A",
            style: AppTypography.kMedium14,
          ),
        ],
      ),
    );
  }
}
