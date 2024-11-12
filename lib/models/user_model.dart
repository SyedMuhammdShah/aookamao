import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/user_roles.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String? password;
  String? address;
  String? cnic_number;
  String? cnic_front_image_url;
  String? cnic_back_image_url;
  UserRoles role;
  Timestamp registered_at;


  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.password,
    this.address,
    this.cnic_number,
    this.cnic_front_image_url,
    this.cnic_back_image_url,
    required this.role,
    required this.registered_at,
  });

  //copy with method
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? address,
    String? cnic_number,
    String? cnic_front_image_url,
    String? cnic_back_image_url,
    UserRoles? role,
    Timestamp? registered_at,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      password: password ?? this.password,
      cnic_number: cnic_number ?? this.cnic_number,
      cnic_front_image_url: cnic_front_image_url ?? this.cnic_front_image_url,
      cnic_back_image_url: cnic_back_image_url ?? this.cnic_back_image_url,
      role: role ?? this.role,
      registered_at: registered_at ?? this.registered_at,
    );
  }

  factory UserModel.fromMapUser(Map<String, dynamic> map) {
    return UserModel(
      uid: "",
      name: map['user_name'],
      email: map['user_email'],
      address: map['address'],
      role: stringToUserRole(map['role']),
      registered_at: map['registered_at']??Timestamp(0, 0),
    );
  }

  factory UserModel.fromMapRetailer(Map<String, dynamic> map) {
    return UserModel(
      uid: "",
      name: map['user_name'],
      email: map['user_email'],
      cnic_number: map['cnic_number'],
      cnic_front_image_url: map['cnic_front_image_url'],
      cnic_back_image_url: map['cnic_back_image_url'],
      role: stringToUserRole(map['role']),
      registered_at: map['registered_at'],
    );
  }

  Map<String, dynamic> toMapRegisterUser() {
    return {
      'user_name': name,
      'user_email': email,
      'address': address,
      'role': userRoleToString(role),
      'registered_at': registered_at,
    };
  }

  Map<String, dynamic> toMapRegisterRetailer() {
    return {
      'user_name': name,
      'user_email': email,
      'cnic_number': cnic_number,
      'cnic_front_image_url': cnic_front_image_url,
      'cnic_back_image_url': cnic_back_image_url,
      'role': userRoleToString(role),
      'registered_at': registered_at,
    };
  }




}