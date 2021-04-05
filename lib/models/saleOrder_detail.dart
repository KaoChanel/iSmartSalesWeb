// To parse this JSON data, do
//
//     final saleOrderDetail = saleOrderDetailFromJson(jsonString);

import 'dart:convert';

List<SaleOrderDetail> saleOrderDetailFromJson(String str) => List<SaleOrderDetail>.from(json.decode(str).map((x) => SaleOrderDetail.fromJson(x)));

String saleOrderDetailToJson(List<SaleOrderDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SaleOrderDetail {
  SaleOrderDetail({
    this.refSoid,
    this.soid,
    this.listNo,
    this.docuType,
    this.jobId,
    this.vatgroupId,
    this.goodId,
    this.goodName,
    this.inveId,
    this.locaId,
    this.goodUnitId1,
    this.goodPrice1,
    this.goodQty1,
    this.goodUnitId2,
    this.goodStockRate1,
    this.goodQty2,
    this.goodPrice2,
    this.goodDiscFormula,
    this.goodDiscAmnt,
    this.goodStockRate2,
    this.miscChargFormula,
    this.goodDiscType,
    this.miscChargAmnt,
    this.chargRemark,
    this.sumExcludeAmnt,
    this.goodCompareQty,
    this.goodAmnt,
    this.goodCompareUnitId,
    this.markUp,
    this.contactName,
    this.shipToAddr1,
    this.shipToAddr2,
    this.district,
    this.amphur,
    this.province,
    this.postCode,
    this.fax,
    this.tel,
    this.shipDue,
    this.shipDate,
    this.refListNo,
    this.remaBefoQty,
    this.remark,
    this.lotNo,
    this.lotFlag,
    this.goodType,
    this.serialFlag,
    this.goodStockUnitId,
    this.postFlag,
    this.goodStockQty,
    this.goodCost,
    this.vatType,
    this.vatrate,
    this.stockFlag,
    this.goodFlag,
    this.remaQty,
    this.reserveQty,
    this.freeFlag,
    this.resvStr1,
    this.resvStr2,
    this.resvStr3,
    this.resvAmnt1,
    this.resvAmnt2,
    this.resvDate1,
    this.goodRemaQty1,
    this.goodRemaQty2,
    this.shipToCode,
    this.markUpAmnt,
    this.commisFormula,
    this.commisAmnt,
    this.refno,
    this.poqty,
    this.remaQtyPkg,
    this.expireflag,
    this.poststock,
    this.afterMarkupamnt,
    this.remaGoodStockQty,
    this.remaamnt,
    this.serialsNo,
    this.isTransfer
  });

  int refSoid;
  int soid;
  int listNo;
  int docuType;
  int jobId;
  int vatgroupId;
  int goodId;
  String goodName;
  int inveId;
  int locaId;
  int goodUnitId1;
  double goodPrice1;
  double goodQty1;
  int goodUnitId2;
  int goodStockRate1;
  double goodQty2;
  double goodPrice2;
  String goodDiscFormula;
  double goodDiscAmnt;
  int goodStockRate2;
  dynamic miscChargFormula;
  dynamic goodDiscType;
  int miscChargAmnt;
  dynamic chargRemark;
  int sumExcludeAmnt;
  double goodCompareQty;
  double goodAmnt;
  dynamic goodCompareUnitId;
  dynamic markUp;
  dynamic contactName;
  dynamic shipToAddr1;
  dynamic shipToAddr2;
  dynamic district;
  dynamic amphur;
  dynamic province;
  dynamic postCode;
  dynamic fax;
  dynamic tel;
  dynamic shipDue;
  DateTime shipDate;
  dynamic refListNo;
  int remaBefoQty;
  dynamic remark;
  String lotNo;
  String lotFlag;
  String goodType;
  String serialFlag;
  int goodStockUnitId;
  dynamic postFlag;
  int goodStockQty;
  double goodCost;
  int vatType;
  int vatrate;
  int stockFlag;
  String goodFlag;
  int remaQty;
  int reserveQty;
  String freeFlag;
  dynamic resvStr1;
  dynamic resvStr2;
  dynamic resvStr3;
  int resvAmnt1;
  int resvAmnt2;
  dynamic resvDate1;
  int goodRemaQty1;
  int goodRemaQty2;
  dynamic shipToCode;
  int markUpAmnt;
  dynamic commisFormula;
  int commisAmnt;
  dynamic refno;
  int poqty;
  int remaQtyPkg;
  String expireflag;
  String poststock;
  double afterMarkupamnt;
  int remaGoodStockQty;
  double remaamnt;
  dynamic serialsNo;
  String isTransfer;

  factory SaleOrderDetail.fromJson(Map<String, dynamic> json) => SaleOrderDetail(
    refSoid: json["refSoid"] == null ? null : json["refSoid"],
    soid: json["soid"] == null ? null : json["soid"],
    listNo: json["listNo"] == null ? null : json["listNo"],
    docuType: json["docuType"] == null ? null : json["docuType"],
    jobId: json["jobId"] == null ? null : json["jobId"],
    vatgroupId: json["vatgroupId"] == null ? null : json["vatgroupId"],
    goodId: json["goodId"] == null ? null : json["goodId"],
    goodName: json["goodName"] == null ? null : json["goodName"],
    inveId: json["inveId"] == null ? null : json["inveId"],
    locaId: json["locaId"] == null ? null : json["locaId"],
    goodUnitId1: json["goodUnitId1"] == null ? null : json["goodUnitId1"],
    goodPrice1: json["goodPrice1"] == null ? null : json["goodPrice1"],
    goodQty1: json["goodQty1"] == null ? null : json["goodQty1"],
    goodUnitId2: json["goodUnitId2"] == null ? null : json["goodUnitId2"],
    goodStockRate1: json["goodStockRate1"] == null ? null : json["goodStockRate1"],
    goodQty2: json["goodQty2"] == null ? null : json["goodQty2"],
    goodPrice2: json["goodPrice2"] == null ? null : json["goodPrice2"],
    goodDiscFormula: json["goodDiscFormula"] == null ? null : json["goodDiscFormula"],
    goodDiscAmnt: json["goodDiscAmnt"] == null ? null : json["goodDiscAmnt"].toDouble(),
    goodStockRate2: json["goodStockRate2"] == null ? null : json["goodStockRate2"],
    miscChargFormula: json["miscChargFormula"],
    goodDiscType: json["goodDiscType"],
    miscChargAmnt: json["miscChargAmnt"] == null ? null : json["miscChargAmnt"],
    chargRemark: json["chargRemark"],
    sumExcludeAmnt: json["sumExcludeAmnt"] == null ? null : json["sumExcludeAmnt"],
    goodCompareQty: json["goodCompareQty"] == null ? null : json["goodCompareQty"],
    goodAmnt: json["goodAmnt"] == null ? null : json["goodAmnt"].toDouble(),
    goodCompareUnitId: json["goodCompareUnitId"],
    markUp: json["markUp"],
    contactName: json["contactName"],
    shipToAddr1: json["shipToAddr1"],
    shipToAddr2: json["shipToAddr2"],
    district: json["district"],
    amphur: json["amphur"],
    province: json["province"],
    postCode: json["postCode"],
    fax: json["fax"],
    tel: json["tel"],
    shipDue: json["shipDue"],
    shipDate: json["shipDate"] == null ? null : DateTime.parse(json["shipDate"]),
    refListNo: json["refListNo"],
    remaBefoQty: json["remaBefoQty"] == null ? null : json["remaBefoQty"],
    remark: json["remark"],
    lotNo: json["lotNo"] == null ? null : json["lotNo"],
    lotFlag: json["lotFlag"] == null ? null : json["lotFlag"],
    goodType: json["goodType"] == null ? null : json["goodType"],
    serialFlag: json["serialFlag"] == null ? null : json["serialFlag"],
    goodStockUnitId: json["goodStockUnitId"] == null ? null : json["goodStockUnitId"],
    postFlag: json["postFlag"],
    goodStockQty: json["goodStockQty"] == null ? null : json["goodStockQty"],
    goodCost: json["goodCost"] == null ? null : json["goodCost"],
    vatType: json["vatType"] == null ? null : json["vatType"],
    vatrate: json["vatrate"],
    stockFlag: json["stockFlag"] == null ? null : json["stockFlag"],
    goodFlag: json["goodFlag"] == null ? null : json["goodFlag"],
    remaQty: json["remaQty"] == null ? null : json["remaQty"],
    reserveQty: json["reserveQty"] == null ? null : json["reserveQty"],
    freeFlag: json["freeFlag"] == null ? null : json["freeFlag"],
    resvStr1: json["resvStr1"],
    resvStr2: json["resvStr2"],
    resvStr3: json["resvStr3"],
    resvAmnt1: json["resvAmnt1"] == null ? null : json["resvAmnt1"],
    resvAmnt2: json["resvAmnt2"] == null ? null : json["resvAmnt2"],
    resvDate1: json["resvDate1"],
    goodRemaQty1: json["goodRemaQty1"] == null ? null : json["goodRemaQty1"],
    goodRemaQty2: json["goodRemaQty2"] == null ? null : json["goodRemaQty2"],
    shipToCode: json["shipToCode"],
    markUpAmnt: json["markUpAmnt"] == null ? null : json["markUpAmnt"],
    commisFormula: json["commisFormula"],
    commisAmnt: json["commisAmnt"] == null ? null : json["commisAmnt"],
    refno: json["refno"],
    poqty: json["poqty"] == null ? null : json["poqty"],
    remaQtyPkg: json["remaQtyPkg"] == null ? null : json["remaQtyPkg"],
    expireflag: json["expireflag"] == null ? null : json["expireflag"],
    poststock: json["poststock"] == null ? null : json["poststock"],
    afterMarkupamnt: json["afterMarkupamnt"] == null ? null : json["afterMarkupamnt"],
    remaGoodStockQty: json["remaGoodStockQty"] == null ? null : json["remaGoodStockQty"],
    remaamnt: json["remaamnt"] == null ? null : json["remaamnt"].toDouble(),
    serialsNo: json["serialsNo"],
    isTransfer: json["isTransfer"],
  );

  Map<String, dynamic> toJson() => {
    "refSoid": refSoid == null ? null : refSoid,
    "soid": soid == null ? null : soid,
    "listNo": listNo == null ? null : listNo,
    "docuType": docuType == null ? null : docuType,
    "jobId": jobId == null ? null : jobId,
    "vatgroupId": vatgroupId  == null ? null : vatgroupId,
    "goodId": goodId == null ? null : goodId,
    "goodName": goodName == null ? null : goodName,
    "inveId": inveId == null ? null : inveId,
    "locaId": locaId == null ? null : locaId,
    "goodUnitId1": goodUnitId1 == null ? null : goodUnitId1,
    "goodPrice1": goodPrice1 == null ? null : goodPrice1,
    "goodQty1": goodQty1 == null ? null : goodQty1,
    "goodUnitId2": goodUnitId2 == null ? null : goodUnitId2,
    "goodStockRate1": goodStockRate1 == null ? null : goodStockRate1,
    "goodQty2": goodQty2 == null ? null : goodQty2,
    "goodPrice2": goodPrice2 == null ? null : goodPrice2,
    "goodDiscFormula": goodDiscFormula == null ? null : goodDiscFormula,
    "goodDiscAmnt": goodDiscAmnt == null ? null : goodDiscAmnt,
    "goodStockRate2": goodStockRate2 == null ? null : goodStockRate2,
    "miscChargFormula": miscChargFormula,
    "goodDiscType": goodDiscType,
    "miscChargAmnt": miscChargAmnt == null ? null : miscChargAmnt,
    "chargRemark": chargRemark,
    "sumExcludeAmnt": sumExcludeAmnt == null ? null : sumExcludeAmnt,
    "goodCompareQty": goodCompareQty == null ? null : goodCompareQty,
    "goodAmnt": goodAmnt == null ? null : goodAmnt,
    "goodCompareUnitId": goodCompareUnitId,
    "markUp": markUp,
    "contactName": contactName,
    "shipToAddr1": shipToAddr1,
    "shipToAddr2": shipToAddr2,
    "district": district,
    "amphur": amphur,
    "province": province,
    "postCode": postCode,
    "fax": fax,
    "tel": tel,
    "shipDue": shipDue,
    "shipDate": shipDate == null ? null : shipDate.toIso8601String(),
    "refListNo": refListNo,
    "remaBefoQty": remaBefoQty == null ? null : remaBefoQty,
    "remark": remark,
    "lotNo": lotNo == null ? null : lotNo,
    "lotFlag": lotFlag == null ? null : lotFlag,
    "goodType": goodType == null ? null : goodType,
    "serialFlag": serialFlag == null ? null : serialFlag,
    "goodStockUnitId": goodStockUnitId == null ? null : goodStockUnitId,
    "postFlag": postFlag,
    "goodStockQty": goodStockQty == null ? null : goodStockQty,
    "goodCost": goodCost == null ? null : goodCost,
    "vatType": vatType == null ? null : vatType,
    "vatrate": vatrate,
    "stockFlag": stockFlag == null ? null : stockFlag,
    "goodFlag": goodFlag == null ? null : goodFlag,
    "remaQty": remaQty == null ? null : remaQty,
    "reserveQty": reserveQty == null ? null : reserveQty,
    "freeFlag": freeFlag == null ? null : freeFlag,
    "resvStr1": resvStr1,
    "resvStr2": resvStr2,
    "resvStr3": resvStr3,
    "resvAmnt1": resvAmnt1 == null ? null : resvAmnt1,
    "resvAmnt2": resvAmnt2 == null ? null : resvAmnt2,
    "resvDate1": resvDate1,
    "goodRemaQty1": goodRemaQty1 == null ? null : goodRemaQty1,
    "goodRemaQty2": goodRemaQty2 == null ? null : goodRemaQty2,
    "shipToCode": shipToCode,
    "markUpAmnt": markUpAmnt == null ? null : markUpAmnt,
    "commisFormula": commisFormula,
    "commisAmnt": commisAmnt == null ? null : commisAmnt,
    "refno": refno,
    "poqty": poqty == null ? null : poqty,
    "remaQtyPkg": remaQtyPkg == null ? null : remaQtyPkg,
    "expireflag": expireflag == null ? null : expireflag,
    "poststock": poststock == null ? null : poststock,
    "afterMarkupamnt": afterMarkupamnt == null ? null : afterMarkupamnt,
    "remaGoodStockQty": remaGoodStockQty == null ? null : remaGoodStockQty,
    "remaamnt": remaamnt == null ? null : remaamnt,
    "serialsNo": serialsNo,
    "isTransfer": isTransfer,
  };
}
