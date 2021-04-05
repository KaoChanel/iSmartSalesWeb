// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);

import 'dart:convert';

List<Stock> stockFromJson(String str) => List<Stock>.from(json.decode(str).map((x) => Stock.fromJson(x)));

String stockToJson(List<Stock> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stock {
  Stock({
    this.orderNumber,
    this.goodid,
    this.goodCode,
    this.goodName1,
    this.goodUnitCode,
    this.remaqty,
    this.lotNo,
    this.expiredate,
    this.vendorlotno,
    this.producedate,
    this.inveid,
    this.locaid,
    this.serialNo,
  });

  int orderNumber;
  int goodid;
  String goodCode;
  String goodName1;
  String goodUnitCode;
  double remaqty;
  String lotNo;
  DateTime expiredate;
  String vendorlotno;
  DateTime producedate;
  int inveid;
  int locaid;
  String serialNo;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    goodid: json["goodid"] == null ? null : json["goodid"],
    goodCode: json["goodCode"] == null ? null : json["goodCode"],
    goodName1: json["goodName1"] == null ? null : json["goodName1"],
    goodUnitCode: json["goodUnitCode"] == null ? null : json["goodUnitCode"],
    remaqty: json["remaqty"] == null ? null : json["remaqty"],
    lotNo: json["lotNo"] == null ? null : json["lotNo"],
    expiredate: json["expiredate"] == null ? null : DateTime.parse(json["expiredate"]),
    vendorlotno: json["vendorlotno"] == null ? null : json["vendorlotno"],
    producedate: json["producedate"] == null ? null : DateTime.parse(json["producedate"]),
    inveid: json["inveid"] == null ? null : json["inveid"],
    locaid: json["locaid"] == null ? null : json["locaid"],
    serialNo: json["serialNo"] == null ? null : json["serialNo"],
  );

  Map<String, dynamic> toJson() => {
    "goodid": goodid == null ? null : goodid,
    "goodCode": goodCode == null ? null : goodCode,
    "goodName1": goodName1 == null ? null : goodName1,
    "goodUnitCode": goodUnitCode == null ? null : goodUnitCode,
    "remaqty": remaqty == null ? null : remaqty,
    "lotNo": lotNo == null ? null : lotNo,
    "expiredate": expiredate == null ? null : expiredate.toIso8601String(),
    "vendorlotno": vendorlotno == null ? null : vendorlotno,
    "producedate": producedate == null ? null : producedate.toIso8601String(),
    "inveid": inveid == null ? null : inveid,
    "locaid": locaid == null ? null : locaid,
    "serialNo": serialNo == null ? null : serialNo,
  };
}
