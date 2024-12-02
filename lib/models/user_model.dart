import 'package:aookamao/enums/user_bank_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/user_roles.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String? password;
  String? address;
 /* String? cnic_number;
  String? cnic_front_image_url;
  String? cnic_back_image_url;*/
  UserRoles role;
  Timestamp? registered_at;
  String? device_token;
  UserBankType? userBankType;
  String? accountNumber;
  String? accountHolderName;


  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.password,
    this.address,
    this.device_token,
    required this.role,
    this.registered_at,
    this.userBankType,
    this.accountNumber,
    this.accountHolderName,
  });

  //copy with method
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? address,
    UserRoles? role,
    Timestamp? registered_at,
    String? device_token,
    UserBankType? userBankType,
    String? accountNumber,
    String? accountHolderName,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      password: password ?? this.password,
      role: role ?? this.role,
      device_token: device_token ?? this.device_token,
      registered_at: registered_at ?? this.registered_at,
      userBankType: userBankType ?? this.userBankType,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
    );
  }

/*  factory UserModel.fromMapUser(Map<String, dynamic> map) {
    return UserModel(
      uid: "",
      name: map['user_name'],
      email: map['user_email'],
      address: map['address']??'',
      role: stringToUserRole(map['role']),
      registered_at: map['registered_at']??Timestamp(0, 0),
      device_token: map['device_token'] ?? "",
      accountHolderName: map['accountHolderName'] ?? "",
      accountNumber: map['accountNumber'] ?? "",
      userBankType: stringToUserBankType(map['userBankType']??''),
    );
  }*/

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: map['user_name'],
      email: map['user_email'],
      address: map['address']??'',
      role: stringToUserRole(map['role']),
      registered_at: map['registered_at']??Timestamp(0, 0),
      device_token: map['device_token'] ?? "",
      accountHolderName: map['accountHolderName'] ?? "",
      accountNumber: map['accountNumber'] ?? "",
      userBankType: stringToUserBankType(map['userBankType']??''),
    );
  }

  factory UserModel.fromMapLocalUser(Map<String, dynamic> map) {
    return UserModel(
      uid: map['UID'],
      name: map['user_name'],
      email: map['user_email'],
      address: map['address'],
      role: stringToUserRole(map['role']),
      accountHolderName: map['accountHolderName'] ?? "",
      accountNumber: map['accountNumber'] ?? "",
      userBankType: stringToUserBankType(map['userBankType']??''),
    );
  }

  /*factory UserModel.fromMapRetailer(Map<String, dynamic> map) {
    return UserModel(
      uid: "",
      name: map['user_name'],
      email: map['user_email'],
*//*      cnic_number: map['cnic_number'],
      cnic_front_image_url: map['cnic_front_image_url'],
      cnic_back_image_url: map['cnic_back_image_url'],*//*
      role: stringToUserRole(map['role']),
      registered_at: map['registered_at'],
      device_token: map['device_token'] ?? "",
      accountHolderName: map['accountHolderName'] ?? "",
      accountNumber: map['accountNumber'] ?? "",
      userBankType: stringToUserBankType(map['userBankType']??''),
    );
  }*/

  Map<String, dynamic> toMapRegisterUser() {
    return {
      'user_name': name,
      'user_email': email,
      'address': address,
      'role': userRoleToString(role),
      'registered_at': registered_at,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'userBankType': userBankTypeToString(userBankType)
    };
  }

  Map<String, dynamic> toMapUpdateUser() {
    return {
      'user_name': name,
      'address': address,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'userBankType': userBankTypeToString(userBankType)
    };
  }



  Map<String, dynamic> toMapSaveUser() {
    return {
      'UID': uid,
      'user_name': name,
      'user_email': email,
      'address': address??'',
      'role': userRoleToString(role),
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'userBankType': userBankTypeToString(userBankType)
    };
  }

 /* Map<String, dynamic> toMapRegisterRetailer() {
    return {
      'user_name': name,
      'user_email': email,
      'cnic_number': cnic_number,
      'cnic_front_image_url': cnic_front_image_url,
      'cnic_back_image_url': cnic_back_image_url,
      'role': userRoleToString(role),
      'registered_at': registered_at,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'userBankType': userBankTypeToString(userBankType!)
    };
  }*/




}