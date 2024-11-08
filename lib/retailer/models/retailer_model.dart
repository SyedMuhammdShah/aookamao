import 'package:aookamao/enums/user_roles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RetailerModel{
  String uid;
  String name;
  String email;
  String cnic_number;
  String cnic_front_image_url;
  String cnic_back_image_url;
  UserRoles role;
  Timestamp registered_at;
  RetailerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.cnic_number,
    required this.cnic_front_image_url,
    required this.cnic_back_image_url,
    required this.role,
    required this.registered_at,
  });

  //copy with method
  RetailerModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? cnic_number,
    String? cnic_front_image_url,
    String? cnic_back_image_url,
    UserRoles? role,
    Timestamp? registered_at,
  }) {
    return RetailerModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      cnic_number: cnic_number ?? this.cnic_number,
      cnic_front_image_url: cnic_front_image_url ?? this.cnic_front_image_url,
      cnic_back_image_url: cnic_back_image_url ?? this.cnic_back_image_url,
      role: role ?? this.role,
      registered_at: registered_at ?? this.registered_at,
    );
  }

  factory RetailerModel.fromMap(Map<String, dynamic> map) {
    return RetailerModel(
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

  Map<String, dynamic> toMap() {
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

