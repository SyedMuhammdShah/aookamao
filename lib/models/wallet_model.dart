import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String walletId;
  final double balance;

  WalletModel({
    required this.walletId,
    required this.balance,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map){
    return WalletModel(
      walletId: map['walletId'],
      balance: double.tryParse(map['balance'].toString()) ?? 0.00,
    );
  }

  Map<String, dynamic> toMapIncrementBalance(){
    return {
      'walletId': walletId,
      'balance': FieldValue.increment(balance)
    };
  }

  Map<String, dynamic> toMap(){
    return {
      'walletId': walletId,
      'balance': balance
    };
  }
}
