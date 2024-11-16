import 'package:aookamao/enums/reward_status.dart';
import 'package:aookamao/enums/rewarded_to.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardModel{
  final String? rewardId;
  final double? rewardAmount;
  final RewardedTo? rewardedTo;
  final String? rewardUserName;
  final Timestamp? rewardDate;
  final String? orderId;
  final RewardStatus? rewardStatus;

  RewardModel({
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
      rewardAmount: map['rewardAmount']??0.0,
      rewardedTo: stringToRewardedTo(map['rewardedTo']),
      rewardUserName: map['rewardUserName']??'',
      rewardDate: map['rewardDate']??Timestamp(0, 0),
      orderId: map['orderId']??'',
      rewardStatus: stringToRewardStatus(map['rewardStatus']),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'rewardId': rewardId,
      'rewardAmount': rewardAmount,
      'rewardedTo': rewardedToToString(rewardedTo!),
      'rewardUserName': rewardUserName,
      'rewardDate': rewardDate,
      'orderId': orderId,
      'rewardStatus': rewardStatusToString(rewardStatus!),
    };
  }
}


