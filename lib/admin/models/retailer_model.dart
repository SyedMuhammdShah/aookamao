import 'package:aookamao/enums/subscription_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../enums/user_bank_type.dart';

class RetailerModel{
  String uid;
  String name;
  String email;
/*  String cnic_number;
  String cnic_front_image_url;
  String cnic_back_image_url;*/
  Timestamp registered_at;
  SubscriptionStatus subscription_status;
 Timestamp subscription_date;
  UserBankType? userBankType;
  String? accountNumber;
  String? accountHolderName;

  RetailerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.registered_at,
    required this.subscription_status,
    required this.subscription_date,
    this.userBankType,
    this.accountNumber,
    this.accountHolderName,
  });

  RetailerModel.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        name = map['user_name'],
        email = map['user_email'],
      /*  cnic_number = map['cnic_number'],
        cnic_front_image_url = map['cnic_front_image_url'],
        cnic_back_image_url = map['cnic_back_image_url'],*/
        registered_at = map['registered_at'],
        subscription_status = stringToSubscriptionStatus( map['subscription_status']),
        subscription_date = map['subscription_date'];



}