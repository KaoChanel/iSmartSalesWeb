// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

List<SoDetailRemark> soDetailRemarkFromJson(String str) => List<SoDetailRemark>.from(json.decode(str).map((x) => SoDetailRemark.fromJson(x)));

String soDetailRemarkToJson(List<SoDetailRemark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoDetailRemark {
  SoDetailRemark({
    this.listNo,
    this.soId,
    this.refListNo,
    this.remark,
  });

  int listNo;
  int soId;
  int refListNo;
  String remark;

  factory SoDetailRemark.fromJson(Map<String, dynamic> json) => SoDetailRemark(
    listNo: json["listNo"] == null ? null : json["listNo"],
    soId: json["soId"] == null ? null : json["soId"],
    refListNo: json["refListNo"] == null ? null : json["refListNo"],
    remark: json["remark"] == null ? null : json["remark"],
  );

  Map<String, dynamic> toJson() => {
    "listNo": listNo == null ? null : listNo,
    "soId": soId == null ? null : soId,
    "refListNo": refListNo == null ? null : refListNo,
    "remark": remark == null ? null : remark,
  };
}