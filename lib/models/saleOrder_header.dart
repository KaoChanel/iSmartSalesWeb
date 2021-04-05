// To parse this JSON data, do
//
//     final saleOrderHeader = saleOrderHeaderFromJson(jsonString);

import 'dart:convert';

List<SaleOrderHeader> saleOrderHeaderFromJson(String str) => List<SaleOrderHeader>.from(json.decode(str).map((x) => SaleOrderHeader.fromJson(x)));

String saleOrderHeaderToJson(List<SaleOrderHeader> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SaleOrderHeader {
  SaleOrderHeader({
    this.soid,
    this.saleAreaId,
    this.vatgroupId,
    this.empId,
    this.currTypeId,
    this.creditId,
    this.brchId,
    this.currId,
    this.transpAreaId,
    this.transpId,
    this.custId,
    this.deptId,
    this.docuNo,
    this.docuType,
    this.docuDate,
    this.validDays,
    this.expireDate,
    this.onHold,
    this.vatRate,
    this.vatType,
    this.goodType,
    this.shipToAddr1,
    this.shipToAddr2,
    this.district,
    this.amphur,
    this.province,
    this.tel,
    this.postCode,
    this.fax,
    this.contactName,
    this.condition,
    this.shipDays,
    this.creditDays,
    this.creditTermType,
    this.fixedRate,
    this.exchRate,
    this.exchDate,
    this.shipDate,
    this.printTime,
    this.sumIncludeAmnt,
    this.sumExcludeAmnt,
    this.sumGoodAmnt,
    this.baseDiscAmnt,
    this.billDiscFormula,
    this.billDiscAmnt,
    this.billAftrDiscAmnt,
    this.totaExcludeAmnt,
    this.totaBaseAmnt,
    this.vatamnt,
    this.netAmnt,
    this.attach,
    this.organName,
    this.remark,
    this.custPodate,
    this.statusRemark,
    this.custPono,
    this.vateffc,
    this.refSoid,
    this.commission,
    this.refNo,
    this.refDate,
    this.commissionAmnt,
    this.clearSo,
    this.fob,
    this.discVateffc,
    this.endCreditDate,
    this.miscChargFormula,
    this.miscChargAmnt,
    this.miscChargRemark,
    this.multiCurrency,
    this.exchType,
    this.fromFlag,
    this.custName,
    this.resvStr1,
    this.resvStr2,
    this.resvStr3,
    this.resvStr4,
    this.resvStr5,
    this.resvStr6,
    this.resvStr7,
    this.resvAmnt1,
    this.resvAmnt2,
    this.resvAmnt3,
    this.resvDate1,
    this.docuStatus,
    this.resvAmnt4,
    this.sotitle,
    this.shipToCode,
    this.quotStatus,
    this.introduceId,
    this.appvFlag,
    this.contactnameShip,
    this.pkgStatus,
    this.jobId,
    this.refeflag,
    this.postdocutype,
    this.appvid,
    this.clearDate,
    this.alertFlag,
    this.clearflag,
    this.isTransfer,
  });

  int soid;
  int saleAreaId;
  int vatgroupId;
  int empId;
  dynamic currTypeId;
  dynamic creditId;
  int brchId;
  dynamic currId;
  int transpAreaId;
  int transpId;
  int custId;
  int deptId;
  String docuNo;
  int docuType;
  DateTime docuDate;
  int validDays;
  DateTime expireDate;
  String onHold;
  int vatRate;
  String vatType;
  String goodType;
  String shipToAddr1;
  dynamic shipToAddr2;
  dynamic district;
  dynamic amphur;
  String province;
  dynamic tel;
  dynamic postCode;
  dynamic fax;
  dynamic contactName;
  dynamic condition;
  dynamic shipDays;
  int creditDays;
  dynamic creditTermType;
  dynamic fixedRate;
  dynamic exchRate;
  dynamic exchDate;
  DateTime shipDate;
  dynamic printTime;
  dynamic sumIncludeAmnt;
  dynamic sumExcludeAmnt;
  double sumGoodAmnt;
  dynamic baseDiscAmnt;
  dynamic billDiscFormula;
  double billDiscAmnt;
  double billAftrDiscAmnt;
  dynamic totaExcludeAmnt;
  dynamic totaBaseAmnt;
  dynamic vatamnt;
  double netAmnt;
  dynamic attach;
  dynamic organName;
  String remark;
  DateTime custPodate;
  dynamic statusRemark;
  dynamic custPono;
  dynamic vateffc;
  dynamic refSoid;
  dynamic commission;
  String refNo;
  dynamic refDate;
  dynamic commissionAmnt;
  dynamic clearSo;
  dynamic fob;
  dynamic discVateffc;
  dynamic endCreditDate;
  dynamic miscChargFormula;
  dynamic miscChargAmnt;
  dynamic miscChargRemark;
  dynamic multiCurrency;
  dynamic exchType;
  dynamic fromFlag;
  String custName;
  dynamic resvStr1;
  dynamic resvStr2;
  dynamic resvStr3;
  dynamic resvStr4;
  dynamic resvStr5;
  dynamic resvStr6;
  dynamic resvStr7;
  dynamic resvAmnt1;
  dynamic resvAmnt2;
  dynamic resvAmnt3;
  dynamic resvDate1;
  String docuStatus;
  dynamic resvAmnt4;
  dynamic sotitle;
  String shipToCode;
  dynamic quotStatus;
  dynamic introduceId;
  dynamic appvFlag;
  dynamic contactnameShip;
  dynamic pkgStatus;
  dynamic jobId;
  dynamic refeflag;
  int postdocutype;
  dynamic appvid;
  dynamic clearDate;
  String alertFlag;
  String clearflag;
  String isTransfer;

  factory SaleOrderHeader.fromJson(Map<String, dynamic> json) => SaleOrderHeader(
    soid: json["soid"] == null ? null : json["soid"],
    saleAreaId: json["saleAreaId"] == null ? null : json["saleAreaId"],
    vatgroupId: json["vatgroupId"] == null ? null : json["vatgroupId"],
    empId: json["empId"] == null ? null : json["empId"],
    currTypeId: json["currTypeId"],
    creditId: json["creditId"],
    brchId: json["brchId"],
    currId: json["currId"],
    transpAreaId: json["transpAreaId"],
    transpId: json["transpId"] == null ? null : json["transpId"],
    custId: json["custId"] == null ? null : json["custId"],
    deptId: json["deptId"] == null ? null : json["deptId"],
    docuNo: json["docuNo"] == null ? null : json["docuNo"],
    docuType: json["docuType"] == null ? null : json["docuType"],
    docuDate: json["docuDate"] == null ? null : DateTime.parse(json["docuDate"]),
    validDays: json["validDays"] == null ? null : json["validDays"],
    expireDate: json["expireDate"] == null ? null : DateTime.parse(json["expireDate"]),
    onHold: json["onHold"] == null ? null : json["onHold"],
    vatRate: json["vatRate"] == null ? null : json["vatRate"],
    vatType: json["vatType"] == null ? null : json["vatType"],
    goodType: json["goodType"] == null ? null : json["goodType"],
    shipToAddr1: json["shipToAddr1"] == null ? null : json["shipToAddr1"],
    shipToAddr2: json["shipToAddr2"],
    district: json["district"],
    amphur: json["amphur"],
    province: json["province"] == null ? null : json["province"],
    tel: json["tel"],
    postCode: json["postCode"],
    fax: json["fax"],
    contactName: json["contactName"],
    condition: json["condition"],
    shipDays: json["shipDays"],
    creditDays: json["creditDays"] == null ? null : json["creditDays"],
    creditTermType: json["creditTermType"],
    fixedRate: json["fixedRate"],
    exchRate: json["exchRate"],
    exchDate: json["exchDate"],
    shipDate: json["shipDate"] == null ? null : DateTime.parse(json["shipDate"]),
    printTime: json["printTime"],
    sumIncludeAmnt: json["sumIncludeAmnt"],
    sumExcludeAmnt: json["sumExcludeAmnt"],
    sumGoodAmnt: json["sumGoodAmnt"] == null ? null : json["sumGoodAmnt"].toDouble(),
    baseDiscAmnt: json["baseDiscAmnt"],
    billDiscFormula: json["billDiscFormula"],
    billDiscAmnt: json["billDiscAmnt"] == null ? null : json["billDiscAmnt"],
    billAftrDiscAmnt: json["billAftrDiscAmnt"] == null ? null : json["billAftrDiscAmnt"].toDouble(),
    totaExcludeAmnt: json["totaExcludeAmnt"],
    totaBaseAmnt: json["totaBaseAmnt"],
    vatamnt: json["vatamnt"],
    netAmnt: json["netAmnt"] == null ? null : json["netAmnt"].toDouble(),
    attach: json["attach"],
    organName: json["organName"],
    remark: json["remark"] == null ? null : json["remark"],
    custPodate: json["custPodate"] == null ? null : DateTime.parse(json["custPodate"]),
    statusRemark: json["statusRemark"],
    custPono: json["custPono"],
    vateffc: json["vateffc"],
    refSoid: json["refSoid"],
    commission: json["commission"],
    refNo: json["refNo"] == null ? null : json["refNo"],
    refDate: json["refDate"],
    commissionAmnt: json["commissionAmnt"],
    clearSo: json["clearSo"],
    fob: json["fob"],
    discVateffc: json["discVateffc"],
    endCreditDate: json["endCreditDate"],
    miscChargFormula: json["miscChargFormula"],
    miscChargAmnt: json["miscChargAmnt"],
    miscChargRemark: json["miscChargRemark"],
    multiCurrency: json["multiCurrency"],
    exchType: json["exchType"],
    fromFlag: json["fromFlag"],
    custName: json["custName"] == null ? null : json["custName"],
    resvStr1: json["resvStr1"],
    resvStr2: json["resvStr2"],
    resvStr3: json["resvStr3"],
    resvStr4: json["resvStr4"],
    resvStr5: json["resvStr5"],
    resvStr6: json["resvStr6"],
    resvStr7: json["resvStr7"],
    resvAmnt1: json["resvAmnt1"],
    resvAmnt2: json["resvAmnt2"],
    resvAmnt3: json["resvAmnt3"],
    resvDate1: json["resvDate1"],
    docuStatus: json["docuStatus"] == null ? null : json["docuStatus"],
    resvAmnt4: json["resvAmnt4"],
    sotitle: json["sotitle"],
    shipToCode: json["shipToCode"] == null ? null : json["shipToCode"],
    quotStatus: json["quotStatus"],
    introduceId: json["introduceId"],
    appvFlag: json["appvFlag"],
    contactnameShip: json["contactnameShip"],
    pkgStatus: json["pkgStatus"],
    jobId: json["jobId"],
    refeflag: json["refeflag"],
    postdocutype: json["postdocutype"],
    appvid: json["appvid"],
    clearDate: json["clearDate"],
    alertFlag: json["alertFlag"] == null ? null : json["alertFlag"],
    clearflag: json["clearflag"],
    isTransfer: json["isTransfer"] == null ? null : json["isTransfer"],
  );

  Map<String, dynamic> toJson() => {
    "soid": soid == null ? null : soid,
    "saleAreaId": saleAreaId == null ? null : saleAreaId,
    "vatgroupId": vatgroupId == null ? null : vatgroupId,
    "empId": empId == null ? null : empId,
    "currTypeId": currTypeId,
    "creditId": creditId,
    "brchId": brchId,
    "currId": currId,
    "transpAreaId": transpAreaId,
    "transpId": transpId == null ? null : transpId,
    "custId": custId == null ? null : custId,
    "deptId": deptId == null ? null : deptId,
    "docuNo": docuNo == null ? null : docuNo,
    "docuType": docuType == null ? null : docuType,
    "docuDate": docuDate == null ? null : docuDate.toIso8601String(),
    "validDays": validDays == null ? null : validDays,
    "expireDate": expireDate == null ? null : expireDate.toIso8601String(),
    "onHold": onHold == null ? null : onHold,
    "vatRate": vatRate == null ? null : vatRate,
    "vatType": vatType == null ? null : vatType,
    "goodType": goodType == null ? null : goodType,
    "shipToAddr1": shipToAddr1 == null ? null : shipToAddr1,
    "shipToAddr2": shipToAddr2,
    "district": district,
    "amphur": amphur,
    "province": province == null ? null : province,
    "tel": tel,
    "postCode": postCode,
    "fax": fax,
    "contactName": contactName,
    "condition": condition,
    "shipDays": shipDays,
    "creditDays": creditDays == null ? null : creditDays,
    "creditTermType": creditTermType,
    "fixedRate": fixedRate,
    "exchRate": exchRate,
    "exchDate": exchDate,
    "shipDate": shipDate == null ? null : shipDate.toIso8601String(),
    "printTime": printTime,
    "sumIncludeAmnt": sumIncludeAmnt,
    "sumExcludeAmnt": sumExcludeAmnt,
    "sumGoodAmnt": sumGoodAmnt == null ? null : sumGoodAmnt,
    "baseDiscAmnt": baseDiscAmnt,
    "billDiscFormula": billDiscFormula,
    "billDiscAmnt": billDiscAmnt == null ? null : billDiscAmnt,
    "billAftrDiscAmnt": billAftrDiscAmnt == null ? null : billAftrDiscAmnt,
    "totaExcludeAmnt": totaExcludeAmnt,
    "totaBaseAmnt": totaBaseAmnt,
    "vatamnt": vatamnt,
    "netAmnt": netAmnt == null ? null : netAmnt,
    "attach": attach,
    "organName": organName,
    "remark": remark == null ? null : remark,
    "custPodate": custPodate == null ? null : custPodate.toIso8601String(),
    "statusRemark": statusRemark,
    "custPono": custPono,
    "vateffc": vateffc,
    "refSoid": refSoid,
    "commission": commission,
    "refNo": refNo == null ? null : refNo,
    "refDate": refDate,
    "commissionAmnt": commissionAmnt,
    "clearSo": clearSo,
    "fob": fob,
    "discVateffc": discVateffc,
    "endCreditDate": endCreditDate,
    "miscChargFormula": miscChargFormula,
    "miscChargAmnt": miscChargAmnt,
    "miscChargRemark": miscChargRemark,
    "multiCurrency": multiCurrency,
    "exchType": exchType,
    "fromFlag": fromFlag,
    "custName": custName == null ? null : custName,
    "resvStr1": resvStr1,
    "resvStr2": resvStr2,
    "resvStr3": resvStr3,
    "resvStr4": resvStr4,
    "resvStr5": resvStr5,
    "resvStr6": resvStr6,
    "resvStr7": resvStr7,
    "resvAmnt1": resvAmnt1,
    "resvAmnt2": resvAmnt2,
    "resvAmnt3": resvAmnt3,
    "resvDate1": resvDate1,
    "docuStatus": docuStatus == null ? null : docuStatus,
    "resvAmnt4": resvAmnt4,
    "sotitle": sotitle,
    "shipToCode": shipToCode == null ? null : shipToCode,
    "quotStatus": quotStatus,
    "introduceId": introduceId,
    "appvFlag": appvFlag,
    "contactnameShip": contactnameShip,
    "pkgStatus": pkgStatus,
    "jobId": jobId,
    "refeflag": refeflag,
    "postdocutype": postdocutype,
    "appvid": appvid,
    "clearDate": clearDate,
    "alertFlag": alertFlag == null ? null : alertFlag,
    "clearflag": clearflag,
    "isTransfer": isTransfer == null ? null : isTransfer,
  };
}
