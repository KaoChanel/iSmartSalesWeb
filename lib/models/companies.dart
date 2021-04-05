// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

List<Company> companyFromJson(String str) => List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  Company({
    this.compId,
    this.compCode,
    this.compName,
    this.compOwner,
    this.taxId,
    this.addr1,
    this.addr2,
    this.addr3,
    this.tel,
    this.fax,
    this.email,
    this.homepage,
    this.compNameEng,
    this.compOwnerEng,
    this.addr1Eng,
    this.addr2Eng,
    this.addr3Eng,
    this.logoComp,
    this.securityNotset,
    this.logoX,
    this.logoY,
    this.logoW,
    this.logoH,
    this.pathData,
    this.pathBackup,
    this.taxId13,
  });

  int compId;
  String compCode;
  String compName;
  String compOwner;
  String taxId;
  String addr1;
  String addr2;
  dynamic addr3;
  String tel;
  String fax;
  dynamic email;
  dynamic homepage;
  String compNameEng;
  String compOwnerEng;
  String addr1Eng;
  String addr2Eng;
  dynamic addr3Eng;
  String logoComp;
  dynamic securityNotset;
  int logoX;
  int logoY;
  int logoW;
  int logoH;
  dynamic pathData;
  dynamic pathBackup;
  String taxId13;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    compId: json["compId"] == null ? null : json["compId"],
    compCode: json["compCode"] == null ? null : json["compCode"],
    compName: json["compName"] == null ? null : json["compName"],
    compOwner: json["compOwner"] == null ? null : json["compOwner"],
    taxId: json["taxId"] == null ? null : json["taxId"],
    addr1: json["addr1"] == null ? null : json["addr1"],
    addr2: json["addr2"] == null ? null : json["addr2"],
    addr3: json["addr3"],
    tel: json["tel"] == null ? null : json["tel"],
    fax: json["fax"] == null ? null : json["fax"],
    email: json["email"],
    homepage: json["homepage"],
    compNameEng: json["compNameEng"] == null ? null : json["compNameEng"],
    compOwnerEng: json["compOwnerEng"] == null ? null : json["compOwnerEng"],
    addr1Eng: json["addr1Eng"] == null ? null : json["addr1Eng"],
    addr2Eng: json["addr2Eng"] == null ? null : json["addr2Eng"],
    addr3Eng: json["addr3Eng"],
    logoComp: json["logoComp"] == null ? null : json["logoComp"],
    securityNotset: json["securityNotset"],
    logoX: json["logoX"] == null ? null : json["logoX"],
    logoY: json["logoY"] == null ? null : json["logoY"],
    logoW: json["logoW"] == null ? null : json["logoW"],
    logoH: json["logoH"] == null ? null : json["logoH"],
    pathData: json["pathData"],
    pathBackup: json["pathBackup"],
    taxId13: json["taxId13"] == null ? null : json["taxId13"],
  );

  Map<String, dynamic> toJson() => {
    "compId": compId == null ? null : compId,
    "compCode": compCode == null ? null : compCode,
    "compName": compName == null ? null : compName,
    "compOwner": compOwner == null ? null : compOwner,
    "taxId": taxId == null ? null : taxId,
    "addr1": addr1 == null ? null : addr1,
    "addr2": addr2 == null ? null : addr2,
    "addr3": addr3,
    "tel": tel == null ? null : tel,
    "fax": fax == null ? null : fax,
    "email": email,
    "homepage": homepage,
    "compNameEng": compNameEng == null ? null : compNameEng,
    "compOwnerEng": compOwnerEng == null ? null : compOwnerEng,
    "addr1Eng": addr1Eng == null ? null : addr1Eng,
    "addr2Eng": addr2Eng == null ? null : addr2Eng,
    "addr3Eng": addr3Eng,
    "logoComp": logoComp == null ? null : logoComp,
    "securityNotset": securityNotset,
    "logoX": logoX == null ? null : logoX,
    "logoY": logoY == null ? null : logoY,
    "logoW": logoW == null ? null : logoW,
    "logoH": logoH == null ? null : logoH,
    "pathData": pathData,
    "pathBackup": pathBackup,
    "taxId13": taxId13 == null ? null : taxId13,
  };
}
