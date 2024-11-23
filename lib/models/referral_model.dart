import 'package:aookamao/enums/referral_account_type.dart';
import 'package:aookamao/enums/referral_types.dart';
import 'package:aookamao/enums/referred_by.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralModel{
  String? referralId;
  String? referralCode;
  List<Referee>? referees;
  ReferralAccountType? accountType;
  String? retailerId; //Retailer who referred
  String? userReferredById; //user who referred
  ReferredBy? referredBy;

  ReferralModel({
     this.referralId,
     this.referralCode,
     this.referees,
     this.accountType,
     this.retailerId,
     this.userReferredById,
    this.referredBy,
  });

  factory ReferralModel.fromMap(Map<String, dynamic> map){
    return ReferralModel(
      referralId: map['referralId']??'',
      referralCode: map['referralCode']??'',
      referees: List<Referee>.from(map['referees'] != null ? map['referees'].map((x) => Referee.fromMap(x)) : []),
      accountType: stringToReferralAccountType(map['accountType']),
      retailerId: map['retailerId']??'',
      userReferredById: map['userReferredById']??'',
      referredBy: stringToReferredBy(map['referredBy']),
    );
  }

  factory ReferralModel.fromMapAllReferrals(Map<String, dynamic> map){
    return ReferralModel(
      referralId: map['referralId']??'',
      referralCode: map['referralCode']??'',
      referees:[],
      accountType: stringToReferralAccountType(map['accountType']),
      retailerId: map['retailerId']??'',
      userReferredById: map['userReferredById']??'',
      referredBy: stringToReferredBy(map['referredBy']),
    );
  }


  Map<String, dynamic> toMapAddRefereeDirectReferral(){
    return {
      'referees': List<dynamic>.from(referees!.map((x) => x.toMap())),
    };
  }
  Map<String, dynamic> toMapAddRefereeInDirectReferral(){
    return {
      'referees': List<dynamic>.from(referees!.map((x) => x.toMapIndirectReferral())),
    };
  }


  Map<String, dynamic> toMapSaveUserReferralCodeByRetailer(){
    return {
      'referralId': referralId,
      'referralCode': referralCode,
      'accountType': referralAccountTypeToString(accountType!),
      'retailerId': retailerId,
      'referredBy': referredByToString(referredBy!),
    };
  }

 Map<String, dynamic> toMapSaveUserReferralCodeByUser(){
    return {
      'referralId': referralId,
      'referralCode': referralCode,
      'accountType': referralAccountTypeToString(accountType!),
      'retailerId': retailerId,
      'referredBy': referredByToString(referredBy!),
      'userReferredById': userReferredById,
    };
  }

  Map<String,dynamic> toMapSaveRetailerReferralCode(){
    return {
      'referralId': referralId,
      'referralCode': referralCode,
      'accountType': referralAccountTypeToString(accountType!),
    };
  }

  Map<String,dynamic> toMapSaveUserReferralCode(){
    return {
      'referralId': referralId,
      'referralCode': referralCode,
      'accountType': referralAccountTypeToString(accountType!),
      'retailerId': retailerId,
    };
  }
}

class Referee{
  String refereeId;
  ReferalTypes referalType;
  String? referedById;
  String? refereeName;
  String? referedByName;
  Timestamp referralDate;

  Referee({
    required this.refereeId,
    required this.referalType,
    required this.referralDate,
    this.referedById,
    this.refereeName,
    this.referedByName,
  });

  factory Referee.fromMap(Map<String, dynamic> map){
    return Referee(
      refereeId: map['refereeId'],
      referalType: referalTypeFromString(map['referalType']),
      referralDate: map['referralDate'],
      referedById: map['referedById']??'',
      refereeName: map['refereeName']??'',
      referedByName: map['referedByName']??'',
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'refereeId': refereeId,
      'referalType': referalTypeToString(referalType),
      'referralDate': referralDate,
      'refereeName' : refereeName,
    };
  }

  //Indirect referral
  Map<String, dynamic> toMapIndirectReferral(){
    return {
      'refereeId': refereeId,
      'referalType': referalTypeToString(referalType),
      'referralDate': referralDate,
      'referedById': referedById,
      'refereeName' : refereeName,
      'referedByName' : referedByName,
    };
  }


}