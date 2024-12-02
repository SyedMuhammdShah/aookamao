import 'package:aookamao/admin/components/transaction_card.dart';
import 'package:aookamao/admin/modules/transactions/transaction_details.dart';
import 'package:aookamao/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../enums/transaction_status.dart';
import '../../../enums/transaction_types.dart';
import '../../../enums/user_roles.dart';
import 'controller/transaction_controller.dart';

class ApprovedTransactions extends StatelessWidget {
  const ApprovedTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final _transactionController = Get.find<TransactionController>();
    return Obx(() =>ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _transactionController.transactionsList.where((element) => element.transactionStatus == TransactionStatus.approved).toList().length,
        itemBuilder: (context, index) {
         return TransactionCard(
           onTap: () {
             Get.to<Widget>(()=> TransactionDetails(transaction: _transactionController.transactionsList.where((element) => element.transactionStatus == TransactionStatus.approved).toList()[index].obs),);
           },
             transaction: _transactionController.transactionsList.where((element) => element.transactionStatus == TransactionStatus.approved).toList()[index].obs,
         );
        },
      ),
    );
  }
}
