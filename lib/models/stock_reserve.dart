// To parse this JSON data, do
//
//     final stockReserve = stockReserveFromJson(jsonString);

import 'dart:convert';

List<StockReserve> stockReserveFromJson(String str) => List<StockReserve>.from(json.decode(str).map((x) => StockReserve.fromJson(x)));

String stockReserveToJson(List<StockReserve> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockReserve {
  StockReserve({
    this.goodId,
    this.goodCode,
    this.goodRemaQty1,
    this.goodUnitName,
  });

  int goodId;
  String goodCode;
  double goodRemaQty1;
  String goodUnitName;

  factory StockReserve.fromJson(Map<String, dynamic> json) => StockReserve(
    goodId: json["goodId"] == null ? null : json["goodId"],
    goodCode: json["goodCode"] == null ? null : json["goodCode"],
    goodRemaQty1: json["goodRemaQty1"] == null ? null : json["goodRemaQty1"],
    goodUnitName: json["goodUnitName"] == null ? null : json["goodUnitName"],
  );

  Map<String, dynamic> toJson() => {
    "goodId": goodId == null ? null : goodId,
    "goodCode": goodCode == null ? null : goodCode,
    "goodRemaQty1": goodRemaQty1 == null ? null : goodRemaQty1,
    "goodUnitName": goodUnitName == null ? null : goodUnitName,
  };
}
