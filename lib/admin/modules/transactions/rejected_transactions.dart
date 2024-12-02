import 'package:aookamao/admin/modules/transactions/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../enums/transaction_status.dart';
import '../../components/transaction_card.dart';
import 'controller/transaction_controller.dart';

class RejectedTransactions extends StatelessWidget {
  const RejectedTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final _transactionController = Get.find<TransactionController>();
    return Obx(() => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _transactionController.transactionsList.where((element) => element.transactionStatus == TransactionStatus.rejected).toList().length,
        itemBuilder: (context, index) {
          return TransactionCard(
            onTap: () {
              Get.to<Widget>(()=> TransactionDetails(transaction: _transactionController.transactionsList.where((element) => element.transactionStatus == TransactionStatus.rejected).toList()[index].obs),);
            },
            transaction: _transactionController.transactionsList.where((element) => element.transactionStatus == TransactionStatus.rejected).toList()[index].obs,
          );
        },
      ),
    );
  }
}
