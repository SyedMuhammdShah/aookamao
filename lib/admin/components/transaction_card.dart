import 'package:aookamao/enums/user_roles.dart';
import 'package:aookamao/user/data/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../enums/transaction_status.dart';
import '../../enums/transaction_types.dart';
import '../../models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final Rx<TransactionModel> transaction;
  final VoidCallback onTap;

  const TransactionCard({
    Key? key,
    required this.transaction, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading Icon
              CircleAvatar(
                radius: 24,
                backgroundColor: _getTransactionTypeColor(transaction.value.transactionType),
                child: Icon(
                  _getTransactionTypeIcon(transaction.value.transactionType),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Type and Date
                    Text(
                      _getTransactionTypeName(transaction.value.transactionType),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                   //user name
                    Text(
                      transaction.value.userName ?? 'N/A',
                      style:AppTypography.kSemiBold12.copyWith(color: Colors.grey),
                    ),
                    //user role
                    Text(
                      transaction.value.userRole == UserRoles.user ? "Customer" :  transaction.value.userRole == UserRoles.retailer ? "Supplier" : '',
                      style:AppTypography.kSemiBold12.copyWith(color: Colors.grey),
                    ),
                    // Transaction Date
                    const SizedBox(height: 8),
                    // Transaction ID
                    Text(
                      'Transaction ID: ${transaction.value.transactionId ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Wallet: ${transaction.value.walletId ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Transaction Amount
              Column(
                children: [
                  Text(
                    'PKR ${transaction.value.transactionAmount?.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: transaction.value.transactionType == TransactionType.Withdrawal
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transaction.value.transactionDate != null
                        ? DateFormat('dd MMM yyyy').format(transaction.value.transactionDate!.toDate())
                        : 'N/A',
                    style:AppTypography.kMedium12,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    side: const BorderSide(color: Colors.white),
                    label: Text(
                      _getTransactionStatusName(transaction.value.transactionStatus),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: _getTransactionStatusColor(transaction.value.transactionStatus),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Helper Functions
  String _getTransactionTypeName(TransactionType? type) {
    switch (type) {
      case TransactionType.ReferralReward:
        return 'Referral Reward';
      case TransactionType.Order:
        return 'Order';
      case TransactionType.Subscription:
        return 'Subscription';
      case TransactionType.Withdrawal:
        return 'Withdrawal';
      default:
        return 'Unknown';
    }
  }

  IconData _getTransactionTypeIcon(TransactionType? type) {
    switch (type) {
      case TransactionType.ReferralReward:
        return Icons.card_giftcard;
      case TransactionType.Order:
        return Icons.shopping_cart;
      case TransactionType.Subscription:
        return Icons.subscriptions;
      case TransactionType.Withdrawal:
        return Icons.account_balance_wallet;
      default:
        return Icons.help_outline;
    }
  }

  Color _getTransactionTypeColor(TransactionType? type) {
    switch (type) {
      case TransactionType.ReferralReward:
        return Colors.blue;
      case TransactionType.Order:
        return Colors.orange;
      case TransactionType.Subscription:
        return Colors.purple;
      case TransactionType.Withdrawal:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTransactionStatusName(TransactionStatus? status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.approved:
        return 'Approved';
      case TransactionStatus.rejected:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color _getTransactionStatusColor(TransactionStatus? status) {
    switch (status) {
      case TransactionStatus.pending:
        return Colors.amber;
      case TransactionStatus.approved:
        return Colors.green;
      case TransactionStatus.rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
