// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.rowId,
    this.goodId,
    this.goodCode,
    this.goodName1,
    this.goodName2,
    this.goodNameEng1,
    this.goodNameEng2,
    this.goodBillName,
    this.mainGoodUnitId,
    this.saleGoodUnitId,
    this.subGoodUnitId,
    this.buyGoodUnitId,
    this.vatGroupId,
    this.vatRate,
    this.vatGroupCode,
    this.vatType,
    this.goodTypeFlag,
    this.goodCateId,
    this.inactive,
    this.goodGroupId,
    this.goodTypeId,
  });

  int rowId;
  int goodId;
  String goodCode;
  String goodName1;
  String goodName2;
  String goodNameEng1;
  String goodNameEng2;
  String goodBillName;
  int mainGoodUnitId;
  dynamic saleGoodUnitId;
  dynamic subGoodUnitId;
  int buyGoodUnitId;
  int vatGroupId;
  int vatRate;
  String vatGroupCode;
  int vatType;
  GoodTypeFlag goodTypeFlag;
  int goodCateId;
  Inactive inactive;
  int goodGroupId;
  int goodTypeId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    rowId: json["rowId"] == null ? null : json["rowId"],
    goodId: json["goodId"] == null ? null : json["goodId"],
    goodCode: json["goodCode"] == null ? null : json["goodCode"],
    goodName1: json["goodName1"] == null ? null : json["goodName1"],
    goodName2: json["goodName2"] == null ? null : json["goodName2"],
    goodNameEng1: json["goodNameEng1"] == null ? null : json["goodNameEng1"],
    goodNameEng2: json["goodNameEng2"] == null ? null : json["goodNameEng2"],
    goodBillName: json["goodBillName"] == null ? null : json["goodBillName"],
    mainGoodUnitId: json["mainGoodUnitId"] == null ? null : json["mainGoodUnitId"],
    saleGoodUnitId: json["saleGoodUnitId"],
    subGoodUnitId: json["subGoodUnitId"],
    buyGoodUnitId: json["buyGoodUnitId"] == null ? null : json["buyGoodUnitId"],
    vatGroupId: json["vatgroupId"] == null ? null : json["vatgroupId"],
    vatRate: json["vatRate"] == null ? null : json["vatRate"],
    vatGroupCode: json["vatgroupCode"] == null ? null : json["vatgroupCode"],
    vatType: json["vatType"] == null ? null : json["vatType"],
    goodTypeFlag: json["goodTypeFlag"] == null ? null : goodTypeFlagValues.map[json["goodTypeFlag"]],
    goodCateId: json["goodCateId"] == null ? null : json["goodCateId"],
    inactive: json["inactive"] == null ? null : inactiveValues.map[json["inactive"]],
    goodGroupId: json["goodGroupId"] == null ? null : json["goodGroupId"],
    goodTypeId: json["goodTypeId"] == null ? null : json["goodTypeId"],
  );

  Map<String, dynamic> toJson() => {
    "rowId": rowId == null ? null : rowId,
    "goodId": goodId == null ? null : goodId,
    "goodCode": goodCode == null ? null : goodCode,
    "goodName1": goodName1 == null ? null : goodName1,
    "goodName2": goodName2 == null ? null : goodName2,
    "goodNameEng1": goodNameEng1 == null ? null : goodNameEng1,
    "goodNameEng2": goodNameEng2 == null ? null : goodNameEng2,
    "goodBillName": goodBillName == null ? null : goodBillName,
    "mainGoodUnitId": mainGoodUnitId == null ? null : mainGoodUnitId,
    "saleGoodUnitId": saleGoodUnitId,
    "subGoodUnitId": subGoodUnitId,
    "buyGoodUnitId": buyGoodUnitId == null ? null : buyGoodUnitId,
    "vatgroupId": vatGroupId == null ? null : vatGroupId,
    "vatRate": vatRate == null ? null : vatRate,
    "vatgroupCode": vatGroupCode == null ? null : vatGroupCode,
    "vatType": vatType == null ? null : vatType,
    "goodTypeFlag": goodTypeFlag == null ? null : goodTypeFlagValues.reverse[goodTypeFlag],
    "goodCateId": goodCateId == null ? null : goodCateId,
    "inactive": inactive == null ? null : inactiveValues.reverse[inactive],
    "goodGroupId": goodGroupId == null ? null : goodGroupId,
    "goodTypeId": goodTypeId == null ? null : goodTypeId,
  };
}

enum GoodTypeFlag { G, S }

final goodTypeFlagValues = EnumValues({
  "G": GoodTypeFlag.G,
  "S": GoodTypeFlag.S
});

enum Inactive { A }

final inactiveValues = EnumValues({
  "A": Inactive.A
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
