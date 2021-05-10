// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

SoHeaderRemark soHeaderRemarkFromJson(String str) => SoHeaderRemark.fromJson(json.decode(str));

String soHeaderRemarkToJson(SoHeaderRemark data) => json.encode(data.toJson());

class SoHeaderRemark {
  SoHeaderRemark({
    this.listNo,
    this.soId,
    this.remark,
    this.isTransfer,
  });

  int listNo;
  int soId;
  String remark;
  String isTransfer;

  factory SoHeaderRemark.fromJson(Map<String, dynamic> json) => SoHeaderRemark(
    listNo: json["listNo"] == null ? null : json["listNo"],
    soId: json["soId"] == null ? null : json["soId"],
    remark: json["remark"] == null ? null : json["remark"],
    isTransfer: json["isTransfer"] == null ? null : json["isTransfer"],
  );

  Map<String, dynamic> toJson() => {
    "listNo": listNo == null ? null : listNo,
    "soId": soId == null ? null : soId,
    "remark": remark == null ? null : remark,
    "isTransfer": isTransfer == null ? null : isTransfer,
  };
}