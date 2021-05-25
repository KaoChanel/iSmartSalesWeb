// To parse this JSON data, do
//
//     final salesMonthly = salesMonthlyFromJson(jsonString);

import 'dart:convert';

List<SalesMonthly> salesMonthlyFromJson(String str) => List<SalesMonthly>.from(json.decode(str).map((x) => SalesMonthly.fromJson(x)));

String salesMonthlyToJson(List<SalesMonthly> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesMonthly {
  SalesMonthly({
    this.empId,
    this.empCode,
    this.empName,
    this.totaExcludeAmnt,
    this.xMonth,
    this.xYear,
  });

  int empId;
  String empCode;
  String empName;
  double totaExcludeAmnt;
  int xMonth;
  int xYear;

  factory SalesMonthly.fromJson(Map<String, dynamic> json) => SalesMonthly(
    empId: json["empId"] == null ? null : json["empId"],
    empCode: json["empCode"] == null ? null : json["empCode"],
    empName: json["empName"] == null ? null : json["empName"],
    totaExcludeAmnt: json["totaExcludeAmnt"] == null ? null : json["totaExcludeAmnt"],
    xMonth: json["xMonth"] == null ? null : json["xMonth"],
    xYear: json["xYear"] == null ? null : json["xYear"],
  );

  Map<String, dynamic> toJson() => {
    "empId": empId == null ? null : empId,
    "empCode": empCode == null ? null : empCode,
    "empName": empName == null ? null : empName,
    "totaExcludeAmnt": totaExcludeAmnt == null ? null : totaExcludeAmnt,
    "xMonth": xMonth == null ? null : xMonth,
    "xYear": xYear == null ? null : xYear,
  };
}
