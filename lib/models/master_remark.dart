// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

List<MasterRemark> masterRemarkFromJson(String str) => List<MasterRemark>.from(json.decode(str).map((x) => MasterRemark.fromJson(x)));

String masterRemarkToJson(List<MasterRemark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MasterRemark {
  MasterRemark({
    this.rowId,
    this.remark,
    this.remarkGroup,
  });

  int rowId;
  String remark;
  String remarkGroup;

  factory MasterRemark.fromJson(Map<String, dynamic> json) => MasterRemark(
    rowId: json["rowId"] == null ? null : json["rowId"],
    remark: json["remark"] == null ? null : json["remark"],
    remarkGroup: json["remarkGroup"] == null ? null : json["remarkGroup"],
  );

  Map<String, dynamic> toJson() => {
    "rowId": rowId == null ? null : rowId,
    "remark": remark == null ? null : remark,
    "remarkGroup": remarkGroup == null ? null : remarkGroup,
  };
}