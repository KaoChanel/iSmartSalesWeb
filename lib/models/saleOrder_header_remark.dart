// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

List<SoHeaderRemark> soHeaderRemarkFromJson(String str) => List<SoHeaderRemark>.from(json.decode(str).map((x) => SoHeaderRemark.fromJson(x)));

String soHeaderRemarkToJson(List<SoHeaderRemark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoHeaderRemark {
  SoHeaderRemark({
    this.listNo,
    this.soId,
    this.remark,
  });

  int listNo;
  int soId;
  String remark;

  factory SoHeaderRemark.fromJson(Map<String, dynamic> json) => SoHeaderRemark(
    listNo: json["listNo"] == null ? null : json["listNo"],
    soId: json["soId"] == null ? null : json["soId"],
    remark: json["remark"] == null ? null : json["remark"],
  );

  Map<String, dynamic> toJson() => {
    "listNo": listNo == null ? null : listNo,
    "soId": soId == null ? null : soId,
    "remark": remark == null ? null : remark,
  };
}