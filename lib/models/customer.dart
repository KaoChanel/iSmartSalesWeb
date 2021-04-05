// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

List<Customer> customerFromJson(String str) => List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  Customer({
    this.custId,
    this.custTypeId,
    this.custGroupId,
    this.transpAreaId,
    this.busiTypeId,
    this.custCode,
    this.custName,
    this.custGroupName,
    this.custTypeName,
    this.custStartDate,
    this.creditDays,
    this.creditAmnt,
    this.creditState,
    this.creditType,
    this.taxId,
    this.contEmail,
    this.contFax,
    this.contTel,
    this.custAddr1,
    this.custAddr2,
    this.district,
    this.amphur,
    this.province,
    this.postCode,
    this.lineId,
    this.cardNo,
    this.saleAreaId,
    this.inactive,
    this.brchName,
    this.saleAreaName,
    this.custMapFullPath,
    this.empId,
    this.empCode,
    this.empName,
  });

  int custId;
  int custTypeId;
  int custGroupId;
  int transpAreaId;
  int busiTypeId;
  String custCode;
  String custName;
  String custGroupName;
  String custTypeName;
  dynamic custStartDate;
  int creditDays;
  double creditAmnt;
  String creditState;
  dynamic creditType;
  String taxId;
  String contEmail;
  dynamic contFax;
  String contTel;
  String custAddr1;
  dynamic custAddr2;
  String district;
  String amphur;
  String province;
  String postCode;
  dynamic lineId;
  dynamic cardNo;
  int saleAreaId;
  String inactive;
  dynamic brchName;
  dynamic saleAreaName;
  dynamic custMapFullPath;
  int empId;
  String empCode;
  String empName;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    custId: json["custId"] == null ? null : json["custId"],
    custTypeId: json["custTypeId"],
    custGroupId: json["custGroupId"] == null ? null : json["custGroupId"],
    transpAreaId: json["transpAreaId"],
    busiTypeId: json["busiTypeId"] == null ? null : json["busiTypeId"],
    custCode: json["custCode"] == null ? null : json["custCode"],
    custName: json["custName"] == null ? null : json["custName"],
    custGroupName: json["custGroupName"] == null ? null : json["custGroupName"],
    custTypeName: json["custTypeName"],
    custStartDate: json["custStartDate"],
    creditDays: json["creditDays"] == null ? null : json["creditDays"],
    creditAmnt: json["creditAmnt"] == null ? null : json["creditAmnt"],
    creditState: json["creditState"] == null ? null : json["creditState"],
    creditType: json["creditType"],
    taxId: json["taxId"] == null ? null : json["taxId"],
    contEmail: json["contEmail"],
    contFax: json["contFax"],
    contTel: json["contTel"] == null ? null : json["contTel"],
    custAddr1: json["custAddr1"] == null ? null : json["custAddr1"],
    custAddr2: json["custAddr2"],
    district: json["district"] == null ? null : json["district"],
    amphur: json["amphur"] == null ? null : json["amphur"],
    province: json["province"] == null ? null : json["province"],
    postCode: json["postCode"] == null ? null : json["postCode"],
    lineId: json["lineId"],
    cardNo: json["cardNo"],
    saleAreaId: json["saleAreaId"] == null ? null : json["saleAreaId"],
    inactive: json["inactive"] == null ? null : json["inactive"],
    brchName: json["brchName"],
    saleAreaName: json["saleAreaName"],
    custMapFullPath: json["custMapFullPath"],
    empId: json["empId"] == null ? null : json["empId"],
    empCode: json["empCode"] == null ? null : json["empCode"],
    empName: json["empName"] == null ? null : json["empName"],
  );

  Map<String, dynamic> toJson() => {
    "custId": custId == null ? null : custId,
    "custTypeId": custTypeId,
    "custGroupId": custGroupId == null ? null : custGroupId,
    "transpAreaId": transpAreaId,
    "busiTypeId": busiTypeId == null ? null : busiTypeId,
    "custCode": custCode == null ? null : custCode,
    "custName": custName == null ? null : custName,
    "custGroupName": custGroupName == null ? null : custGroupName,
    "custTypeName": custTypeName,
    "custStartDate": custStartDate,
    "creditDays": creditDays == null ? null : creditDays,
    "creditAmnt": creditAmnt == null ? null : creditAmnt,
    "creditState": creditState == null ? null : creditState,
    "creditType": creditType,
    "taxId": taxId == null ? null : taxId,
    "contEmail": contEmail,
    "contFax": contFax,
    "contTel": contTel == null ? null : contTel,
    "custAddr1": custAddr1 == null ? null : custAddr1,
    "custAddr2": custAddr2,
    "district": district == null ? null : district,
    "amphur": amphur == null ? null : amphur,
    "province": province == null ? null : province,
    "postCode": postCode == null ? null : postCode,
    "lineId": lineId,
    "cardNo": cardNo,
    "saleAreaId": saleAreaId == null ? null : saleAreaId,
    "inactive": inactive == null ? null : inactive,
    "brchName": brchName,
    "saleAreaName": saleAreaName,
    "custMapFullPath": custMapFullPath,
    "empId": empId == null ? null : empId,
    "empCode": empCode == null ? null : empCode,
    "empName": empName == null ? null : empName,
  };
}
