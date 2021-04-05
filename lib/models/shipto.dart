// To parse this JSON data, do
//
//     final shipto = shiptoFromJson(jsonString);

import 'dart:convert';

List<Shipto> shiptoFromJson(String str) => List<Shipto>.from(json.decode(str).map((x) => Shipto.fromJson(x)));

String shiptoToJson(List<Shipto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Shipto {
  Shipto({
    this.rowId,
    this.custId,
    this.listNo,
    this.transpId,
    this.transpAreaId,
    this.shiptoCode,
    this.contName,
    this.shiptoAddr1,
    this.shiptoAddr2,
    this.district,
    this.amphur,
    this.province,
    this.tel,
    this.shiptoTerm,
    this.condition,
    this.remark,
    this.postcode,
    this.fax,
    this.isDefault,
  });

  int rowId;
  int custId;
  int listNo;
  int transpId;
  int transpAreaId;
  String shiptoCode;
  String contName;
  String shiptoAddr1;
  String shiptoAddr2;
  String district;
  String amphur;
  String province;
  String tel;
  int shiptoTerm;
  String condition;
  String remark;
  String postcode;
  String fax;
  String isDefault;

  factory Shipto.fromJson(Map<String, dynamic> json) => Shipto(
    rowId: json["rowId"] == null ? null : json["rowId"],
    custId: json["custId"] == null ? null : json["custId"],
    listNo: json["listNo"] == null ? null : json["listNo"],
    transpId: json["transpId"] == null ? null : json["transpId"],
    transpAreaId: json["transpAreaId"] == null ? null : json["transpAreaId"],
    shiptoCode: json["shiptoCode"] == null ? null : json["shiptoCode"],
    contName: json["contName"] == null ? null : json["contName"],
    shiptoAddr1: json["shiptoAddr1"] == null ? null : json["shiptoAddr1"],
    shiptoAddr2: json["shiptoAddr2"]== null ? null : json["shiptoAddr2"],
    district: json["district"] == null ? null : json["district"],
    amphur: json["amphur"] == null ? null : json["amphur"],
    province: json["province"] == null ? null : json["province"],
    tel: json["tel"] == null ? null : json["tel"],
    shiptoTerm: json["shiptoTerm"] == null ? null : json["shiptoTerm"],
    condition: json["condition"]== null ? null : json["condition"],
    remark: json["remark"] == null ? null : json["remark"],
    postcode: json["postcode"] == null ? null : json["postcode"],
    fax: json["fax"] == null ? null : json["fax"],
    isDefault: json["isDefault"] == null ? null : json["isDefault"],
  );

  Map<String, dynamic> toJson() => {
    "rowId": rowId == null ? null : rowId,
    "custId": custId == null ? null : custId,
    "listNo": listNo == null ? null : listNo,
    "transpId": transpId == null ? null : transpId,
    "transpAreaId": transpAreaId == null ? null : transpAreaId,
    "shiptoCode": shiptoCode == null ? null : shiptoCode,
    "contName": contName == null ? null : contName,
    "shiptoAddr1": shiptoAddr1 == null ? null : shiptoAddr1,
    "shiptoAddr2": shiptoAddr2 == null ? null : shiptoAddr2,
    "district": district == null ? null : district,
    "amphur": amphur == null ? null : amphur,
    "province": province == null ? null : province,
    "tel": tel == null ? null : tel,
    "shiptoTerm": shiptoTerm == null ? null : shiptoTerm,
    "condition": condition == null ? null : condition,
    "remark": remark == null ? null : remark,
    "postcode": postcode == null ? null : postcode,
    "fax": fax == null ? null : fax,
    "isDefault": isDefault == null ? null : isDefault,
  };
}
