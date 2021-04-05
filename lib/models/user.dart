// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.userId,
    this.username,
    this.password,
    this.isActive,
    this.roleCode,
    this.createBy,
    this.createDate,
    this.empId,
  });

  String userId;
  String username;
  String password;
  bool isActive;
  String roleCode;
  dynamic createBy;
  DateTime createDate;
  int empId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"] == null ? null : json["userId"],
    username: json["username"] == null ? null : json["username"],
    password: json["password"] == null ? null : json["password"],
    isActive: json["isActive"] == null ? null : json["isActive"],
    roleCode: json["roleCode"] == null ? null : json["roleCode"],
    createBy: json["createBy"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
    empId: json["empId"] == null ? null : json["empId"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId == null ? null : userId,
    "username": username == null ? null : username,
    "password": password == null ? null : password,
    "isActive": isActive == null ? null : isActive,
    "roleCode": roleCode == null ? null : roleCode,
    "createBy": createBy,
    "createDate": createDate == null ? null : createDate.toIso8601String(),
    "empId": empId == null ? null : empId,
  };
}
