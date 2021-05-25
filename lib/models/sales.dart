// To parse this JSON data, do
//
//     final sales = salesFromJson(jsonString);

import 'dart:convert';

List<Sales> salesFromJson(String str) => List<Sales>.from(json.decode(str).map((x) => Sales.fromJson(x)));

String salesToJson(List<Sales> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sales {
  Sales({
    this.soinvId,
    this.custId,
    this.custCode,
    this.custName,
    this.empId,
    this.empCode,
    this.empName,
    this.docuDate,
    this.docuNo,
    this.saleAreaName,
    this.listNo,
    this.goodId,
    this.goodCode,
    this.goodName1,
    this.totaExcludeAmnt,
    this.xDay,
    this.xMonth,
    this.xYear,
    this.empArea,
    this.categoryid,
    this.category,
    this.goodQty2,
    this.goodGroupId,
    this.goodGroupName,
  });

  int soinvId;
  int custId;
  String custCode;
  String custName;
  int empId;
  String empCode;
  String empName;
  DateTime docuDate;
  String docuNo;
  String saleAreaName;
  int listNo;
  int goodId;
  String goodCode;
  String goodName1;
  double totaExcludeAmnt;
  int xDay;
  int xMonth;
  int xYear;
  dynamic empArea;
  int categoryid;
  dynamic category;
  double goodQty2;
  int goodGroupId;
  String goodGroupName;

  factory Sales.fromJson(Map<String, dynamic> json) => Sales(
    soinvId: json["soinvId"] == null ? null : json["soinvId"],
    custId: json["custId"] == null ? null : json["custId"],
    custCode: json["custCode"] == null ? null : json["custCode"],
    custName: json["custName"] == null ? null : json["custName"],
    empId: json["empId"] == null ? null : json["empId"],
    empCode: json["empCode"] == null ? null : json["empCode"],
    empName: json["empName"] == null ? null : json["empName"],
    docuDate: json["docuDate"] == null ? null : DateTime.parse(json["docuDate"]),
    docuNo: json["docuNo"] == null ? null : json["docuNo"],
    saleAreaName: json["saleAreaName"],
    listNo: json["listNo"] == null ? null : json["listNo"],
    goodId: json["goodId"] == null ? null : json["goodId"],
    goodCode: json["goodCode"] == null ? null : json["goodCode"],
    goodName1: json["goodName1"] == null ? null : json["goodName1"],
    totaExcludeAmnt: json["totaExcludeAmnt"] == null ? null : json["totaExcludeAmnt"],
    xDay: json["xDay"] == null ? null : json["xDay"],
    xMonth: json["xMonth"] == null ? null : json["xMonth"],
    xYear: json["xYear"] == null ? null : json["xYear"],
    empArea: json["empArea"],
    categoryid: json["categoryid"] == null ? null : json["categoryid"],
    category: json["category"],
    goodQty2: json["goodQty2"] == null ? null : json["goodQty2"],
    goodGroupId: json["goodGroupId"] == null ? null : json["goodGroupId"],
    goodGroupName: json["goodGroupName"] == null ? null : json["goodGroupName"],
  );

  Map<String, dynamic> toJson() => {
    "soinvId": soinvId == null ? null : soinvId,
    "custId": custId == null ? null : custId,
    "custCode": custCode == null ? null : custCode,
    "custName": custName == null ? null : custName,
    "empId": empId == null ? null : empId,
    "empCode": empCode == null ? null : empCode,
    "empName": empName == null ? null : empName,
    "docuDate": docuDate == null ? null : docuDate.toIso8601String(),
    "docuNo": docuNo == null ? null : docuNo,
    "saleAreaName": saleAreaName,
    "listNo": listNo == null ? null : listNo,
    "goodId": goodId == null ? null : goodId,
    "goodCode": goodCode == null ? null : goodCode,
    "goodName1": goodName1 == null ? null : goodName1,
    "totaExcludeAmnt": totaExcludeAmnt == null ? null : totaExcludeAmnt,
    "xDay": xDay == null ? null : xDay,
    "xMonth": xMonth == null ? null : xMonth,
    "xYear": xYear == null ? null : xYear,
    "empArea": empArea,
    "categoryid": categoryid == null ? null : categoryid,
    "category": category,
    "goodQty2": goodQty2 == null ? null : goodQty2,
    "goodGroupId": goodGroupId == null ? null : goodGroupId,
    "goodGroupName": goodGroupName == null ? null : goodGroupName,
  };
}
