import 'package:aookamao/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VariousChargesModel {

  final SubcriptionCharges subcriptionCharges;

  VariousChargesModel({required this.subcriptionCharges});

  factory VariousChargesModel.fromMap(Map<String, dynamic> data) {
    return VariousChargesModel(
      subcriptionCharges: SubcriptionCharges.fromMap(data[Constants.subscriptionChargesDoc]),
    );
  }



}

class SubcriptionCharges{
  final double? amount;

  SubcriptionCharges({this.amount});

  factory SubcriptionCharges.fromMap(Map<String, dynamic> data) {
    return SubcriptionCharges(
      amount: double.tryParse(data['Amount'].toString() ?? '0.0'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Amount': amount,
    };
  }
}