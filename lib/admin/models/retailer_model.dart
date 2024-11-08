import 'package:aookamao/enums/subscription_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RetailerModel{
  String uid;
  String name;
  String email;
  String cnic_number;
  String cnic_front_image_url;
  String cnic_back_image_url;
  Timestamp registered_at;
  SubscriptionStatus subscription_status;
 Timestamp subscription_date;

  RetailerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.cnic_number,
    required this.cnic_front_image_url,
    required this.cnic_back_image_url,
    required this.registered_at,
    required this.subscription_status,
    required this.subscription_date,
  });

  RetailerModel.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        name = map['user_name'],
        email = map['user_email'],
        cnic_number = map['cnic_number'],
        cnic_front_image_url = map['cnic_front_image_url'],
        cnic_back_image_url = map['cnic_back_image_url'],
        registered_at = map['registered_at'],
        subscription_status = stringToSubscriptionStatus( map['subscription_status']),
        subscription_date = map['subscription_date'];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'user_name': name,
      'user_email': email,
      'cnic_number': cnic_number,
      'cnic_front_image_url': cnic_front_image_url,
      'cnic_back_image_url': cnic_back_image_url,
      'registered_at': registered_at,
      'subscription_status': subscriptionStatusToString(subscription_status),
      'subscription_date': subscription_date,
    };
  }

}