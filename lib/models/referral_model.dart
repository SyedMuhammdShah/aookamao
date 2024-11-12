import 'package:aookamao/enums/referral_account_type.dart';
import 'package:aookamao/enums/referral_types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralModel{
  String referralId;
  String referralCode;
  List<Referee> referees;
  ReferralAccountType accountType;
  String retailerId; //Retailer who referred
  String userReferredById; //user who referred


  ReferralModel({
    required this.referralId,
    required this.referralCode,
    required this.referees,
    required this.accountType,
    required this.retailerId,
    required this.userReferredById,
  });

  factory ReferralModel.fromMap(Map<String, dynamic> map){
    return ReferralModel(
      referralId: map['referralId'],
      referralCode: map['referralCode'],
      referees: List<Referee>.from(map['referees'].map((x) => Referee.fromMap(x))),
      accountType: stringToReferralAccountType(map['accountType']),
      retailerId: map['retailerId'],
      userReferredById: map['userReferredById'],
    );
  }

  Map<String, dynamic> toMapRetailerDirectReferral(){
    return {
      'referees': List<dynamic>.from(referees.map((x) => x.toMap())),
    };
  }

  Map<String, dynamic> toMapUserReferral(){
    return {
      'referralId': referralId,
      'referralCode': referralCode,
      'referees': List<dynamic>.from(referees.map((x) => x.toMap())),
      'accountType': referralAccountTypeToString(accountType),
      'retailerId': retailerId,
      'userReferredById': userReferredById,
    };
  }

  Map<String,dynamic> toMapSaveRetailerReferralCode(){
    return {
      'referralId': referralId,
      'referralCode': referralCode,
      'accountType': referralAccountTypeToString(accountType),
    };
  }

  Map<String,dynamic> toMapSaveUserReferralCode(){
    return {
      'referralId': referralId,
      'referralCode': referralCode,
      'accountType': referralAccountTypeToString(accountType),
      'retailerId': retailerId,
    };
  }
}

class Referee{
  String refereeId;
  ReferalTypes referalType;
  Timestamp referralDate;

  Referee({
    required this.refereeId,
    required this.referalType,
    required this.referralDate,
  });

  factory Referee.fromMap(Map<String, dynamic> map){
    return Referee(
      refereeId: map['refereeId'],
      referalType: referalTypeFromString(map['referalType']),
      referralDate: map['referralDate'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'refereeId': refereeId,
      'referalType': referalTypeToString(referalType),
      'referralDate': referralDate,
    };
  }
}