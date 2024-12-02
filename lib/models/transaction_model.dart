import 'package:aookamao/enums/transaction_status.dart';
import 'package:aookamao/enums/user_roles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/transaction_types.dart';

class TransactionModel {
  final String? transactionId;
  final TransactionType? transactionType;
  final double? transactionAmount;
  final Timestamp? transactionDate;
  final String? walletId;
  final String? userName;
  final UserRoles? userRole;
  final TransactionStatus? transactionStatus;

  TransactionModel({
    this.transactionId,
    this.transactionType,
    this.transactionAmount,
    this.transactionDate,
    this.walletId,
    this.transactionStatus,
    this.userName,
    this.userRole,

  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      transactionId: doc.id,
      transactionType: transactionTypesFromString(data['transactionType']),
      transactionAmount: double.tryParse(data['transactionAmount'].toString() ?? '0.0'),
      transactionDate: data['transactionDate'],
      walletId: data['walletId'],
      transactionStatus: stringToTransactionStatus(data['transactionStatus']),
      userName: data['userName'],
      userRole: stringToUserRole(data['userRole']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionType': transactionTypesToString(transactionType!),
      'transactionAmount': transactionAmount,
      'transactionDate': transactionDate,
      'walletId': walletId,
      'transactionStatus': transactionStatusToString(transactionStatus),
      'userName': userName,
      'userRole': userRoleToString(userRole),
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'transactionStatus': transactionStatusToString(transactionStatus)
    };
  }
}