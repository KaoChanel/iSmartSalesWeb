// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  Employee({
    this.deptId,
    this.deptName,
    this.deptCode,
    this.sideId,
    this.postId,
    this.postCode,
    this.postName,
    this.empId,
    this.empCode,
    this.empTitle,
    this.empTitleEng,
    this.empName,
    this.empNameEng,
    this.email,
    this.teamId,
    this.dummyCode,
    this.remark,
    this.username,
    this.empStatus,
    this.isLock
  });

  int deptId;
  String deptName;
  String deptCode;
  int sideId;
  dynamic postId;
  dynamic postCode;
  dynamic postName;
  int empId;
  String empCode;
  String empTitle;
  String empTitleEng;
  String empName;
  String empNameEng;
  dynamic email;
  dynamic teamId;
  dynamic dummyCode;
  dynamic remark;
  dynamic username;
  String empStatus;
  String isLock;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    deptId: json["deptId"] == null ? null : json["deptId"],
    deptName: json["deptName"] == null ? null : json["deptName"],
    deptCode: json["deptCode"] == null ? null : json["deptCode"],
    sideId: json["sideId"] == null ? null : json["sideId"],
    postId: json["postId"],
    postCode: json["postCode"],
    postName: json["postName"],
    empId: json["empId"] == null ? null : json["empId"],
    empCode: json["empCode"] == null ? null : json["empCode"],
    empTitle: json["empTitle"] == null ? null : json["empTitle"],
    empTitleEng: json["empTitleEng"] == null ? null : json["empTitleEng"],
    empName: json["empName"] == null ? null : json["empName"],
    empNameEng: json["empNameEng"] == null ? null : json["empNameEng"],
    email: json["email"],
    teamId: json["teamId"],
    dummyCode: json["dummyCode"],
    remark: json["remark"],
    username: json["username"],
    empStatus: json["empStatus"],
    isLock: json["isLock"]
  );

  Map<String, dynamic> toJson() => {
    "deptId": deptId == null ? null : deptId,
    "deptName": deptName == null ? null : deptName,
    "deptCode": deptCode == null ? null : deptCode,
    "sideId": sideId == null ? null : sideId,
    "postId": postId,
    "postCode": postCode,
    "postName": postName,
    "empId": empId == null ? null : empId,
    "empCode": empCode == null ? null : empCode,
    "empTitle": empTitle == null ? null : empTitle,
    "empTitleEng": empTitleEng == null ? null : empTitleEng,
    "empName": empName == null ? null : empName,
    "empNameEng": empNameEng == null ? null : empNameEng,
    "email": email,
    "teamId": teamId,
    "dummyCode": dummyCode,
    "remark": remark,
    "username": username,
    "empStatus": empStatus,
    "isLock": isLock
  };
}
