import 'package:aookamao/enums/reward_status.dart';
import 'package:aookamao/enums/rewarded_to.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardModel{
  final String? rewardId;
  final double? rewardAmount;
  final RewardedTo? rewardedTo;
  final String? rewardUserId;
  final String? rewardUserName;
  final Timestamp? rewardDate;
  final String? orderId;
  final RewardStatus? rewardStatus;

  RewardModel({
    this.rewardUserId,
    this.rewardId,
    this.rewardAmount,
    this.rewardedTo,
    this.rewardUserName,
    this.rewardDate,
    this.orderId,
    this.rewardStatus,
  });

  factory RewardModel.fromMap(Map<String, dynamic> map){
    return RewardModel(
      rewardId: map['rewardId']??'',
      rewardUserId: map['rewardUserId']??'',
      rewardAmount: map['rewardAmount']??0.0,
      rewardedTo: stringToRewardedTo(map['rewardedTo']),
      rewardUserName: map['rewardUserName']??'',
      rewardDate: map['rewardDate']??Timestamp(0, 0),
      orderId: map['orderId']??'',
      rewardStatus: stringToRewardStatus(map['rewardStatus']),
    );
  }
  factory RewardModel.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> map){
    return RewardModel(
      rewardId: map.id??'',
      rewardUserId: map.data()['rewardUserId']??'',
      rewardAmount: map.data()['rewardAmount']??0.0,
      rewardedTo: stringToRewardedTo(map.data()['rewardedTo']),
      rewardUserName: map.data()['rewardUserName']??'',
      rewardDate: map.data()['rewardDate']??Timestamp(0, 0),
      orderId: map.data()['orderId']??'',
      rewardStatus: stringToRewardStatus(map.data()['rewardStatus']),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'rewardUserId': rewardUserId,
      'rewardAmount': rewardAmount,
      'rewardedTo': rewardedToToString(rewardedTo!),
      'rewardUserName': rewardUserName,
      'rewardDate': rewardDate,
      'orderId': orderId,
      'rewardStatus': rewardStatusToString(rewardStatus!),
    };
  }
}


