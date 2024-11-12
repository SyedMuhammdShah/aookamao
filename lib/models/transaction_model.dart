import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/transaction_types.dart';

class TransactionModel {
  final String transactionId;
  final TransactionType transactionType;
  final String transactionAmount;
  final Timestamp transactionDate;
  final String walletId;

  TransactionModel({
    required this.transactionId,
    required this.transactionType,
    required this.transactionAmount,
    required this.transactionDate,
    required this.walletId,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map){
    return TransactionModel(
      transactionId: map['transactionId'],
      transactionType: transactionTypesFromString(map['transactionType'])!,
      transactionAmount: map['transactionAmount'],
      transactionDate: map['transactionDate'],
      walletId: map['walletId'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'transactionId': transactionId,
      'transactionType': transactionTypesToString(transactionType),
      'transactionAmount': transactionAmount,
      'transactionDate': transactionDate,
      'walletId': walletId,
    };
  }
}