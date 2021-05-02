// To parse this JSON data, do
//
//     final option = optionFromJson(jsonString);

import 'dart:convert';

List<Option> optionFromJson(String str) => List<Option>.from(json.decode(str).map((x) => Option.fromJson(x)));

String optionToJson(List<Option> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Option {
  Option({
    this.brchId,
    this.vatgroupId,
    this.era,
    this.postGl,
    this.multiCurrency,
    this.showMoneySign,
    this.signPosition,
    this.amntdec,
    this.qtydec,
    this.unitamntdec,
    this.timeAlertFlag,
    this.timeAlert,
    this.runOption,
    this.logobrch,
    this.isLockPrice,
  });

  int brchId;
  int vatgroupId;
  String era;
  String postGl;
  String multiCurrency;
  dynamic showMoneySign;
  dynamic signPosition;
  dynamic amntdec;
  int qtydec;
  int unitamntdec;
  String timeAlertFlag;
  dynamic timeAlert;
  String runOption;
  dynamic logobrch;
  String isLockPrice;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    brchId: json["brchId"] == null ? null : json["brchId"],
    vatgroupId: json["vatgroupId"] == null ? null : json["vatgroupId"],
    era: json["era"] == null ? null : json["era"],
    postGl: json["postGl"] == null ? null : json["postGl"],
    multiCurrency: json["multiCurrency"] == null ? null : json["multiCurrency"],
    showMoneySign: json["showMoneySign"],
    signPosition: json["signPosition"],
    amntdec: json["amntdec"],
    qtydec: json["qtydec"] == null ? null : json["qtydec"],
    unitamntdec: json["unitamntdec"] == null ? null : json["unitamntdec"],
    timeAlertFlag: json["timeAlertFlag"] == null ? null : json["timeAlertFlag"],
    timeAlert: json["timeAlert"],
    runOption: json["runOption"] == null ? null : json["runOption"],
    logobrch: json["logobrch"],
    isLockPrice: json["isLockPrice"] == null ? null : json["isLockPrice"],
  );

  Map<String, dynamic> toJson() => {
    "brchId": brchId == null ? null : brchId,
    "vatgroupId": vatgroupId == null ? null : vatgroupId,
    "era": era == null ? null : era,
    "postGl": postGl == null ? null : postGl,
    "multiCurrency": multiCurrency == null ? null : multiCurrency,
    "showMoneySign": showMoneySign,
    "signPosition": signPosition,
    "amntdec": amntdec,
    "qtydec": qtydec == null ? null : qtydec,
    "unitamntdec": unitamntdec == null ? null : unitamntdec,
    "timeAlertFlag": timeAlertFlag == null ? null : timeAlertFlag,
    "timeAlert": timeAlert,
    "runOption": runOption == null ? null : runOption,
    "logobrch": logobrch,
    "isLockPrice": isLockPrice == null ? null : isLockPrice,
  };
}
