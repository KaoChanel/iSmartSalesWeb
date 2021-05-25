// To parse this JSON data, do
//
//     final salesDaily = salesDailyFromJson(jsonString);

import 'dart:convert';

List<SalesDaily> salesDailyFromJson(String str) => List<SalesDaily>.from(json.decode(str).map((x) => SalesDaily.fromJson(x)));

String salesDailyToJson(List<SalesDaily> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesDaily {
  SalesDaily({
    this.empId,
    this.empCode,
    this.empName,
    this.docuDate,
    this.totaExcludeAmnt,
    this.xDay,
    this.xMonth,
    this.xYear,
  });

  int empId;
  String empCode;
  String empName;
  DateTime docuDate;
  double totaExcludeAmnt;
  int xDay;
  int xMonth;
  int xYear;

  factory SalesDaily.fromJson(Map<String, dynamic> json) => SalesDaily(
    empId: json["empId"] == null ? null : json["empId"],
    empCode: json["empCode"] == null ? null : json["empCode"],
    empName: json["empName"] == null ? null : json["empName"],
    docuDate: json["docuDate"] == null ? null : DateTime.parse(json["docuDate"]),
    totaExcludeAmnt: json["totaExcludeAmnt"] == null ? null : json["totaExcludeAmnt"],
    xDay: json["xDay"] == null ? null : json["xDay"],
    xMonth: json["xMonth"] == null ? null : json["xMonth"],
    xYear: json["xYear"] == null ? null : json["xYear"],
  );

  Map<String, dynamic> toJson() => {
    "empId": empId == null ? null : empId,
    "empCode": empCode == null ? null : empCode,
    "empName": empName == null ? null : empName,
    "docuDate": docuDate == null ? null : docuDate.toIso8601String(),
    "totaExcludeAmnt": totaExcludeAmnt == null ? null : totaExcludeAmnt,
    "xDay": xDay == null ? null : xDay,
    "xMonth": xMonth == null ? null : xMonth,
    "xYear": xYear == null ? null : xYear,
  };
}
