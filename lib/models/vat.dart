// To parse this JSON data, do
//
//     final vat = vatFromJson(jsonString);

import 'dart:convert';

List<Vat> vatFromJson(String str) => List<Vat>.from(json.decode(str).map((x) => Vat.fromJson(x)));

String vatToJson(List<Vat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vat {
  Vat({
    this.rowId,
    this.accId,
    this.vatgroupId,
    this.vatgroupCode,
    this.vatRate,
    this.vatType,
    this.remark,
    this.reportName,
    this.clm,
  });

  int rowId;
  dynamic accId;
  int vatgroupId;
  String vatgroupCode;
  int vatRate;
  String vatType;
  dynamic remark;
  dynamic reportName;
  dynamic clm;

  factory Vat.fromJson(Map<String, dynamic> json) => Vat(
    rowId: json["rowId"] == null ? null : json["rowId"],
    accId: json["accId"],
    vatgroupId: json["vatgroupId"] == null ? null : json["vatgroupId"],
    vatgroupCode: json["vatgroupCode"] == null ? null : json["vatgroupCode"],
    vatRate: json["vatRate"] == null ? null : json["vatRate"],
    vatType: json["vatType"] == null ? null : json["vatType"],
    remark: json["remark"],
    reportName: json["reportName"],
    clm: json["clm"],
  );

  Map<String, dynamic> toJson() => {
    "rowId": rowId == null ? null : rowId,
    "accId": accId,
    "vatgroupId": vatgroupId == null ? null : vatgroupId,
    "vatgroupCode": vatgroupCode == null ? null : vatgroupCode,
    "vatRate": vatRate == null ? null : vatRate,
    "vatType": vatType == null ? null : vatType,
    "remark": remark,
    "reportName": reportName,
    "clm": clm,
  };
}
