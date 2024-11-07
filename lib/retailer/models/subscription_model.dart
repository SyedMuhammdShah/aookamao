import 'package:aookamao/enums/subscription_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  final String uid;
  final SubscriptionStatus subscriptionStatus;
  final Timestamp? subscriptionDate;

  SubscriptionModel({
    required this.uid,
    required this.subscriptionStatus,
    this.subscriptionDate,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      uid: map['user_id'],
      subscriptionStatus: stringToSubscriptionStatus(map['subscription_status']),
      subscriptionDate: map['subscription_date']??null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': uid,
      'subscription_status': subscriptionStatusToString(subscriptionStatus),
      'subscription_date': subscriptionDate??null,
    };
  }

  Map<String, dynamic> updatesubtoMap() {
    return {
      'subscription_status': subscriptionStatusToString(subscriptionStatus),
      'subscription_date': subscriptionDate??null,
    };
  }



}