// To parse this JSON data, do
//
//     final goodsUnit = goodsUnitFromJson(jsonString);

import 'dart:convert';

List<GoodsUnit> goodsUnitFromJson(String str) => List<GoodsUnit>.from(json.decode(str).map((x) => GoodsUnit.fromJson(x)));

String goodsUnitToJson(List<GoodsUnit> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GoodsUnit {
  GoodsUnit({
    this.rowId,
    this.goodUnitId,
    this.goodUnitCode,
    this.goodUnitName,
    this.goodUnitNameEng,
    this.remark,
    this.refGoodUnitId,
    this.baseFlag,
    this.rateQty,
    this.baseQty,
  });

  int rowId;
  int goodUnitId;
  String goodUnitCode;
  String goodUnitName;
  String goodUnitNameEng;
  dynamic remark;
  dynamic refGoodUnitId;
  String baseFlag;
  int rateQty;
  int baseQty;

  factory GoodsUnit.fromJson(Map<String, dynamic> json) => GoodsUnit(
    rowId: json["rowId"] == null ? null : json["rowId"],
    goodUnitId: json["goodUnitId"] == null ? null : json["goodUnitId"],
    goodUnitCode: json["goodUnitCode"] == null ? null : json["goodUnitCode"],
    goodUnitName: json["goodUnitName"] == null ? null : json["goodUnitName"],
    goodUnitNameEng: json["goodUnitNameEng"] == null ? null : json["goodUnitNameEng"],
    remark: json["remark"],
    refGoodUnitId: json["refGoodUnitId"],
    baseFlag: json["baseFlag"] == null ? null : json["baseFlag"],
    rateQty: json["rateQty"] == null ? null : json["rateQty"],
    baseQty: json["baseQty"] == null ? null : json["baseQty"],
  );

  Map<String, dynamic> toJson() => {
    "rowId": rowId == null ? null : rowId,
    "goodUnitId": goodUnitId == null ? null : goodUnitId,
    "goodUnitCode": goodUnitCode == null ? null : goodUnitCode,
    "goodUnitName": goodUnitName == null ? null : goodUnitName,
    "goodUnitNameEng": goodUnitNameEng == null ? null : goodUnitNameEng,
    "remark": remark,
    "refGoodUnitId": refGoodUnitId,
    "baseFlag": baseFlag == null ? null : baseFlag,
    "rateQty": rateQty == null ? null : rateQty,
    "baseQty": baseQty == null ? null : baseQty,
  };
}
