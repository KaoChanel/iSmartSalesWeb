import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ismart_crm/models/customer.dart';
import 'package:ismart_crm/models/product.dart';
import 'package:ismart_crm/models/product_cart.dart';
import 'package:ismart_crm/models/shipto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ismart_crm/src/dashboardPage.dart';
import 'package:ismart_crm/src/launcher.dart';
import 'package:ismart_crm/src/statusTransferDoc.dart';
import 'containerProduct.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';
import 'package:ismart_crm/models/saleOrder_header.dart';
import 'package:ismart_crm/models/saleOrder_detail.dart';
import 'package:ismart_crm/models/saleOrder_detail_remark.dart';
import 'package:ismart_crm/models/saleOrder_header_remark.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SaleOrderDraft extends StatefulWidget {
  SaleOrderDraft({@required this.saleOrderHeader});

  final SaleOrderHeader saleOrderHeader;

  @override
  _SaleOrderDraftState createState() => _SaleOrderDraftState();
}

class _SaleOrderDraftState extends State<SaleOrderDraft> {
  ApiService _apiService = new ApiService();
  final currency = new NumberFormat("#,##0.00", "en_US");
  StreamController<double> ctrl_discountTotal = StreamController<double>();
  StreamController<double> ctrl_priceTotal = StreamController<double>();
  StreamController<double> ctrl_discountBill = StreamController<double>();
  StreamController<double> ctrl_priceAfterDiscount = StreamController<double>();
  StreamController<double> ctrl_vatTotal = StreamController<double>();
  StreamController<double> ctrl_netTotal = StreamController<double>();
  bool isInitialDraft = false;
  Customer localCustomer;
  String runningNo;
  String docuNo;
  String refNo;
  String custPONo;
  String creditState;
  double vat = 0.07;
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  DateTime _docuDate = DateTime.now();
  DateTime _shiptoDate = DateTime.now().add(Duration(hours: 24));
  DateTime _orderDate = DateTime.now();
  SaleOrderHeader SOHD = SaleOrderHeader();
  List<SaleOrderDetail> SODT = List<SaleOrderDetail>();
  SoHeaderRemark headerRemark = SoHeaderRemark();
  List<SoDetailRemark> detailRemark = List<SoDetailRemark>();
  List<ProductCart> productCart = List<ProductCart>();

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtCustPONo = TextEditingController();
  TextEditingController txtSONo = TextEditingController();
  TextEditingController txtDeptCode = TextEditingController();
  TextEditingController txtCopyDocuNo = TextEditingController();
  TextEditingController txtEmpCode = TextEditingController();
  TextEditingController txtEmpName = TextEditingController();
  TextEditingController txtCustCode = TextEditingController();
  TextEditingController txtCustName = TextEditingController();
  TextEditingController txtCreditType = TextEditingController();
  TextEditingController txtCredit = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtRemark = TextEditingController();

  TextEditingController txtShiptoName = TextEditingController();
  TextEditingController txtShiptoCode = TextEditingController();
  TextEditingController txtShiptoProvince = TextEditingController();
  TextEditingController txtShiptoAddress = TextEditingController();
  TextEditingController txtShiptoRemark = TextEditingController();
  TextEditingController txtPriceTotal = TextEditingController();
  TextEditingController txtDiscountTotal = TextEditingController();
  TextEditingController txtDiscountBill = TextEditingController();
  TextEditingController txtPriceAfterDiscount = TextEditingController();
  TextEditingController txtVatTotal = TextEditingController();
  TextEditingController txtNetTotal = TextEditingController();

  TextEditingController txtDocuDate = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  TextEditingController txtShiptoDate = TextEditingController(
      text: DateFormat('dd/MM/yyyy')
          .format(DateTime.now().add(new Duration(hours: 24))));
  TextEditingController txtOrderDate = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setHeader();
    setSelectedShipto();
    calculateSummary();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusDiscount.dispose();
    ctrl_discountTotal.close();
    ctrl_priceTotal.close();
    ctrl_discountBill.close();
    ctrl_priceAfterDiscount.close();
    ctrl_vatTotal.close();
    ctrl_netTotal.close();
  }

  setHeader() async {
    SOHD = widget.saleOrderHeader;
    headerRemark = await _apiService.getHeaderRemark(SOHD.soid);
    detailRemark = await _apiService.getDetailRemark(SOHD.soid);

    localCustomer = globals.allCustomer.firstWhere((e) => e.custId == widget.saleOrderHeader.custId, orElse: null);
    globals.customer = localCustomer;
    globals.selectedShipto = globals.allShipto?.firstWhere(
            (element) => element.custId == localCustomer?.custId, orElse: () => null);

    // SODT = await _apiService.getSODT(SOHD.soid);
    //
    // /// Mapping
    // SODT.forEach((x) {
    //   ProductCart cart = ProductCart()
    //   ..rowIndex = x.listNo
    //   ..goodId = x.goodId
    //   ..goodCode = globals.allProduct.firstWhere((element) => element.goodId == x.goodId, orElse: null).goodCode
    //   ..goodName2 = x.goodName
    //   ..goodAmount = x.goodAmnt
    //   ..discountBase = x.goodDiscAmnt
    //   ..mainGoodUnitId = x.goodUnitId2
    //   ..vatRate = x.vatrate
    //   ..vatType = x.vatType;
    //
    //   productCart.add(cart);
    // });

    runningNo = SOHD.docuNo ?? '';
    refNo = SOHD.refNo ?? '';
    // _docuDate = editedDocuDate == false ? SOHD.docuDate : _docuDate;
    // _shiptoDate = editedShipDate == false ? SOHD.shipDate : _shiptoDate;
    _docuDate = SOHD.docuDate;
    _shiptoDate = SOHD.shipDate;
    _orderDate = SOHD.custPodate;
    discountBill = SOHD.billDiscAmnt;
    vatTotal = SOHD.vatamnt;

    txtRunningNo.text = runningNo;
    txtRefNo.text = refNo;
    txtDocuNo.text = SOHD.docuNo;
    txtDocuDate.text = DateFormat('dd/MM/yyyy').format(_docuDate);
    txtShiptoDate.text =
        _shiptoDate != null ? DateFormat('dd/MM/yyyy').format(_shiptoDate) : '';
    txtShiptoRemark.text = SOHD.remark;
    txtOrderDate.text =
        _orderDate != null ? DateFormat('dd/MM/yyyy').format(_orderDate) : '';
    txtEmpCode.text = '${globals.employee?.empCode}';
    txtCustCode.text = globals.allCustomer
            ?.firstWhere((element) => element.custId == SOHD.custId)
            ?.custCode ??
        '';
    txtCustName.text = SOHD.custName ?? '';
    txtCreditType.text = globals.allCustomer.firstWhere((element) => element.custId == SOHD.custId).creditType ?? '';
    txtCredit.text = globals.allCustomer.firstWhere((element) => element.custId == SOHD.custId).creditDays.toString() ?? '0';
    creditState = globals.allCustomer.firstWhere((element) => element.custId == SOHD.custId).creditState ?? '';
    txtStatus.text = creditState == 'H' ? 'Holding' : creditState == 'I' ? 'Inactive' : '????????????' ;
    // txtRemark.text = SOHD.remark ?? '';
    txtRemark.text = headerRemark?.remark ?? '';
    // double DiscountTotal = 0;
    // SODT.where((element) => element.soid == SOHD.soid).forEach((element) {DiscountTotal += element.goodDiscAmnt;});
    // txtDiscountTotal.text = currency.format(DiscountTotal);
    txtPriceTotal.text = currency.format(SOHD.sumGoodAmnt);
    txtDiscountBill.text = currency.format(SOHD.billDiscAmnt);
    txtPriceAfterDiscount.text = currency.format(SOHD.billAftrDiscAmnt);
    txtVatTotal.text = currency.format(SOHD.vatamnt ?? 0);
    txtNetTotal.text = currency.format(SOHD.netAmnt);

    globals.discountBillDraft.number = discountBill;
    globals.discountBillDraft.amount = discountBill;
    ctrl_discountBill.add(discountBill);
    ctrl_vatTotal.add(vatTotal);
  }

  void calculateSummary() {
    try {
      print('Calculate globals.productCartDraft : ' +
          globals.productCartDraft.length.toString());
      if (globals.productCartDraft.length > 0) {
        discountTotal = 0;
        priceTotal = 0;
        globals.productCartDraft.forEach((element) {
          discountTotal += element.discountBase;
        });

        globals.productCartDraft.forEach((element) {
          priceTotal += element.goodAmount;
        });
      } else {
        discountTotal = 0;
        priceTotal = 0;
        priceAfterDiscount = 0;
        //globals.discountBillDraft = 0;
        vatTotal = 0;
        netTotal = 0;
      }

      //priceTotal = priceTotal - discountTotal;
      if (globals.discountBillDraft.type == 'PER') {
        double percentDiscount = globals.discountBillDraft.number / 100;
        globals.discountBillDraft.amount = (percentDiscount * priceTotal);
        priceAfterDiscount = priceTotal - globals.discountBillDraft.amount;
      } else {
        priceAfterDiscount = priceTotal - globals.discountBillDraft.number;
      }

      // double sumPriceIncludeVat = 0;
      // if (globals.productCartDraft != null) {
      //   globals.productCartDraft
      //       .where((element) => element?.vatRate != null)
      //       .toList()
      //       .forEach((element) {
      //     sumPriceIncludeVat += element.goodAmount;
      //   });
      // }

      double sumGoodsHasVat = 0;
      double sumGoodsHasNoVat = 0;

      if (globals.productCartDraft != null) {
        globals.productCartDraft
            .where((x) => x.vatRate > 0)
            .toList()
            .forEach((element) => sumGoodsHasVat += element.goodAmount);
        globals.productCartDraft
            .where((x) => x.vatRate == 0)
            .toList()
            .forEach((element) => sumGoodsHasNoVat += element.goodAmount);
      }

      sumGoodsHasVat = sumGoodsHasVat - globals.discountBill.amount;
      double vatBase = 0;
      if (globals.vatGroup.vatgroupCode == 'IN7') {
        vatBase = sumGoodsHasVat / 1.07;
        vatTotal = (sumGoodsHasVat / 1.07) * 0.07;
        netTotal = vatBase + vatTotal + sumGoodsHasNoVat;
      } else if (globals.vatGroup.vatgroupCode == 'EX7') {
        vatBase = sumGoodsHasVat;
        vatTotal = (sumGoodsHasVat * 0.07);
        netTotal = vatBase + vatTotal + sumGoodsHasNoVat;
      } else {
        netTotal = priceAfterDiscount;
      }

      // vatTotal = (priceAfterDiscount * vat) / 100;
      // vatTotal = (sumPriceIncludeVat * vat) / 100;
      // sumPriceIncludeVat = sumPriceIncludeVat - (globals.discountBillDraft);
      //sumPriceIncludeVat = priceAfterDiscount;
      // print('sumPriceIncludeVat:  ' + sumPriceIncludeVat.toString());
      // print('globals.discountBillDraft:  ' +
      //     globals.discountBillDraft.toString());
      // //print('sumPriceIncludeVat * 0.07:  ' + (sumPriceIncludeVat + (sumPriceIncludeVat * vat)).toString());
      // print((sumPriceIncludeVat * vat).toString());
      // vatTotal = (priceAfterDiscount * 0.07);
      // netTotal = priceAfterDiscount + vatTotal;

      // txtDiscountTotal.text = currency.format(discountTotal);
      // txtPriceTotal.text = currency.format(priceTotal);
      // txtDiscountBill.text = currency.format(globals.discountBillDraft);
      // txtPriceAfterDiscount.text = currency.format(priceAfterDiscount);
      // txtVatTotal.text = currency.format(vatTotal);
      // txtNetTotal.text = currency.format(netTotal);

      ctrl_discountTotal.add(discountTotal);
      ctrl_priceTotal.add(priceTotal);
      ctrl_discountBill.add(globals.discountBillDraft.number);
      ctrl_priceAfterDiscount.add(priceAfterDiscount);
      ctrl_vatTotal.add(vatTotal);
      ctrl_netTotal.add(netTotal);
    } catch (e) {
      showDialog(
          builder: (context) => AlertDialog(
            title: Text('Exception'),
            content: Text(e.toString()),
          ), context: context);
    }
  }

  Widget setDiscountType() {
    if (globals.discountBillDraft.type == 'THB') {
      return Text('THB');
    } else {
      return Text('%');
    }
  }

  void setSelectedShipto() {
    txtShiptoProvince.text = widget.saleOrderHeader?.province ?? '';
    txtShiptoAddress.text = '${widget.saleOrderHeader.shipToAddr1 ?? ''} '
        '${widget.saleOrderHeader?.shipToAddr2 ?? ''} '
        '${widget.saleOrderHeader?.district ?? ''} '
        '${widget.saleOrderHeader?.amphur ?? ''} '
        '${widget.saleOrderHeader?.province ?? ''} '
        '${widget.saleOrderHeader?.postCode ?? ''}';
    //txtShiptoRemark.text = widget.saleOrderHeader.remark ?? '';
  }

  Widget getShiptoListWidgets(BuildContext context) {
    List<Shipto> shiptoList = globals.allShipto
        .where((element) => element.custId == widget.saleOrderHeader.custId)
        .toList();
    print(shiptoList);
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < shiptoList?.length; i++) {
      list.add(ListTile(
        title: Text(
            '${shiptoList[i]?.shiptoAddr1 ?? ''} ${shiptoList[i]?.district ?? ''} ${shiptoList[i]?.amphur ?? ''} ${shiptoList[i]?.province ?? ''} ${shiptoList[i]?.postcode ?? ''}'),
        //subtitle: Text(item?.custCode),
        onTap: () {
          //globals.selectedShipto = shiptoList[i];
          widget.saleOrderHeader.shipToAddr1 = shiptoList[i].shiptoAddr1;
          widget.saleOrderHeader.shipToAddr2 = shiptoList[i].shiptoAddr2;
          widget.saleOrderHeader.district = shiptoList[i].district;
          widget.saleOrderHeader.amphur = shiptoList[i].amphur;
          widget.saleOrderHeader.province = shiptoList[i].province;
          widget.saleOrderHeader.postCode = shiptoList[i].postcode;
          Navigator.pop(context);
          setState(() {});
        },
        selected:
            widget.saleOrderHeader.shipToAddr1 == shiptoList[i]?.shiptoAddr1 ??
                '',
        selectedTileColor: Colors.grey[200],
        hoverColor: Colors.grey,
      ));
    }
    return ListView(children: list);
  }

  Future<Widget> getRemarkList(BuildContext context) async {
    //var allRemark = globals.allRemark.toList() ?? [];
    var allRemark = await _apiService.getRemark();
    print(allRemark);
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < allRemark?.length; i++) {
      list.add(ListTile(
        title: Text(allRemark[i]?.remark ?? ''),
        //subtitle: Text(item?.custCode),
        onTap: () {
          globals.selectedRemarkDraft = allRemark[i];
          setState(() {
            txtRemark.text = globals.selectedRemarkDraft?.remark ?? '';
            Navigator.pop(context);
          });
        },
        // selected:
        // globals.selectedRemark.remark ?? '' == allRemark[i]?.remark ?? '',
        // selectedTileColor: Colors.grey[200],
        // hoverColor: Colors.grey,
      ));
    }
    return ListView(children: list);
  }

  Future<dynamic> putSaleOrder(String status) async {
    try {
      globals.showLoaderDialog(context, false);
      SaleOrderHeader header = new SaleOrderHeader();
      List<SaleOrderDetail> detail = new List<SaleOrderDetail>();
      runningNo = '';
      // refNo =
      //     '${globals.company}${globals.employee?.empCode}-${runningNo ?? ''}';
      refNo = SOHD.refNo;
      docuNo = SOHD.docuNo;

      /// Company Info
      header.brchId = 1;

      /// document header.
      header.soid = SOHD.soid;
      header.saleAreaId = globals.customer.saleAreaId;
      header.docuNo = docuNo;
      header.refNo = refNo;
      header.docuType = 104;
      header.docuDate = _docuDate;
      header.shipDate = _shiptoDate;
      header.custPodate = _orderDate;
      header.custPono = txtCustPONo.text;
      header.validDays = 0;
      header.onHold = 'N';
      header.goodType = '1';
      header.docuStatus = 'Y';
      header.isTransfer = status;
      header.postdocutype = 1702;

      /// employee information.
      header.empId = globals.employee.empId;
      header.deptId = globals.employee.deptId;

      /// customer information.
      header.custId = globals.customer.custId;
      header.custName = globals.customer.custName;
      header.creditDays = globals.customer.creditDays;

      /// Discount

      /// shipment to customer.
      header.shipToCode = globals.selectedShipto.shiptoCode;
      header.transpId = globals.selectedShipto.transpId;
      header.transpAreaId = globals.selectedShipto.transpAreaId;
      header.shipToAddr1 = globals.selectedShipto.shiptoAddr1;
      header.shipToAddr2 = globals.selectedShipto.shiptoAddr2;
      header.district = globals.selectedShipto.district;
      header.amphur = globals.selectedShipto.amphur;
      header.province = globals.selectedShipto.province;
      header.postCode = globals.selectedShipto.postcode;
      header.remark = globals.selectedShipto.remark;

      /// VAT Info
      header.vatgroupId = globals.vatGroup.vatgroupId;
      header.vatRate = globals.vatGroup.vatRate;
      header.vatType = globals.vatGroup.vatType;
      header.vatamnt = vatTotal;

      /// Cost Summary.
      header.sumGoodAmnt = priceTotal;
      header.billAftrDiscAmnt = priceAfterDiscount;
      header.netAmnt = netTotal;
      header.billDiscAmnt = globals.discountBillDraft.amount;

      globals.productCartDraft.forEach((e) {
        SaleOrderDetail obj = new SaleOrderDetail();
        obj.soid = header.soid;
        obj.listNo = e.rowIndex;
        obj.docuType = 104;
        obj.goodType = '1';
        obj.goodId = e.goodId;
        obj.goodName = e.goodName1;
        //obj.goodName = e.goodName2;
        obj.goodUnitId2 = e.mainGoodUnitId;
        obj.goodQty2 = e.goodQty;
        obj.goodPrice2 = e.goodPrice;
        obj.goodAmnt = e.goodAmount;
        obj.afterMarkupamnt = e.goodAmount;
        obj.goodDiscAmnt = e.discountBase;
        obj.isTransfer = status;
        detail.add(obj);
      });

      var res = await _apiService.saveDraft(header, detail);
      if (res) {
        // Navigator.pop(context);
        //setState(() {});
        globals.clearDraftOrder();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StatusTransferDoc()));
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                //uses the custom alert dialog
                alertTitle: richTitle("Draft has saved successfully."),
                alertSubtitle: richSubtitle("Your draft has saved. "),
                alertType: RichAlertType.SUCCESS,
                actions: [

                ],
              );
            }).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => StatusTransferDoc()));});
      } else {
        Navigator.pop(context);
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                //uses the custom alert dialog
                alertTitle: richTitle("An error occurred while saving a draft."),
                alertSubtitle: richSubtitle(
                    "Something was wrong while saving method on API."),
                alertType: RichAlertType.ERROR,
              );
            });
      }
      // _apiService.updateSaleOrderHeader(header).then((value) {
      //   print('Add result: ${header.soid}');
      //   if (value == true) {
      //     globals.productCartDraft.forEach((e) {
      //       SaleOrderDetail obj = new SaleOrderDetail();
      //       obj.soid = header.soid;
      //       obj.listNo = e.rowIndex;
      //       obj.docuType = 104;
      //       obj.goodType = '1';
      //       obj.goodId = e.goodId;
      //       obj.goodName = e.goodName1;
      //       //obj.goodName = e.goodName2;
      //       obj.goodUnitId2 = e.mainGoodUnitId;
      //       obj.goodQty2 = e.goodQty;
      //       obj.goodPrice2 = e.goodPrice;
      //       obj.goodAmnt = e.goodAmount;
      //       obj.afterMarkupamnt = e.goodAmount;
      //       obj.goodDiscAmnt = e.discountBase;
      //       detail.add(obj);
      //     });
      //
      //     _apiService.updateSaleOrderDetail(detail).then((value) {
      //       if (value == true) {
      //         //globals.clearOrder();
      //         Navigator.pop(context);
      //         print('Saved Daft Successful.');
      //         setState(() {});
      //         return showDialog<void>(
      //             context: context,
      //             builder: (BuildContext context) {
      //               return RichAlertDialog(
      //                 //uses the custom alert dialog
      //                 alertTitle: richTitle("Draft has saved."),
      //                 alertSubtitle: richSubtitle("Your draft has saved. "),
      //                 alertType: RichAlertType.SUCCESS,
      //               );
      //             });
      //         // globals.clearOrder();
      //         // print('Order Successful.');
      //       } else {
      //         Navigator.pop(context);
      //         return showDialog<void>(
      //             context: context,
      //             builder: (BuildContext context) {
      //               return RichAlertDialog(
      //                 //uses the custom alert dialog
      //                 alertTitle:
      //                     richTitle("Details of Sales Order was failed."),
      //                 alertSubtitle: richSubtitle(
      //                     "Something was wrong while creating SO Details."),
      //                 alertType: RichAlertType.ERROR,
      //               );
      //             });
      //       }
      //     });
      //   } else {
      //     Navigator.pop(context);
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return RichAlertDialog(
      //             //uses the custom alert dialog
      //             alertTitle: richTitle("Header of Sales Order was failed."),
      //             alertSubtitle: richSubtitle(
      //                 "Something was wrong while creating SO Header."),
      //             alertType: RichAlertType.ERROR,
      //           );
      //         });
      //   }
      // });
    } catch (e) {
      Navigator.pop(context);
      return showAboutDialog(
          context: context,
          applicationName: 'Post Sale Order Exception',
          applicationIcon: Icon(Icons.error_outline),
          children: [
            Text(e),
          ]);
    }
  }

// Show Dialog function
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
            elevation: 0,
            title: new Text('???????????????????????????????????????'),
            content: Container(
                width: 500, height: 300, child: getShiptoListWidgets(context)));
      },
    );
  }

  void _showRemarkDialog(context) async {
    // flutter defined function
    var alert = AlertDialog(
        elevation: 0,
        title: new Text('?????????????????????????????????????????????'),
        content: Container(
            width: 500, height: 300, child: await getRemarkList(context)));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return alert;
      },
    );
  }

  void showDiscountTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
            elevation: 0,
            title: new Text('????????????????????????????????????'),
            content: Container(
                width: 250,
                height: 180,
                child: ListView(children: [
                  ListTile(
                      onTap: () {
                        //discountType = globals.DiscountType.THB;
                        globals.discountBillDraft.type = 'THB';
                        Navigator.pop(context);
                        setState(() {});
                      },
                      selected:
                      globals.discountBillDraft.type == 'THB',
                      selectedTileColor: Colors.black12,
                      title: Text('THB')),
                  ListTile(
                    onTap: () {
                      //discountType = globals.DiscountType.PER;
                      globals.discountBillDraft.type = 'PER';
                      Navigator.pop(context);
                      setState(() {});
                    },
                    selected: globals.discountBillDraft.type == 'PER',
                    selectedTileColor: Colors.black12,
                    title: Text('%'),
                  )
                ])));
      },
    );
  }

  Widget streamPriceTotal() {
    return StreamBuilder(
      stream: ctrl_priceTotal.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TextEditingController _controller =
              TextEditingController(text: currency.format(snapshot.data ?? 0));
          return TextFormField(
            readOnly: true,
            controller: _controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              //border: OutlineInputBorder()
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget streamDiscountTotal() {
    return StreamBuilder(
      stream: ctrl_discountTotal.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TextEditingController _controller =
              TextEditingController(text: currency.format(snapshot.data ?? 0));
          return TextFormField(
            readOnly: true,
            controller: _controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              //border: OutlineInputBorder()
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget streamDiscountBill() {
    return StreamBuilder(
      stream: ctrl_discountBill.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TextEditingController _controller =
              TextEditingController(text: currency.format(snapshot.data ?? 0));
          return TextFormField(
            readOnly: true,
            controller: _controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              //border: OutlineInputBorder()
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget streamPriceAfterDiscount() {
    return StreamBuilder(
      stream: ctrl_priceAfterDiscount.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TextEditingController _controller =
              TextEditingController(text: currency.format(snapshot.data ?? 0));
          return TextFormField(
            readOnly: true,
            controller: _controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              //border: OutlineInputBorder()
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget streamVatTotal() {
    return StreamBuilder(
      stream: ctrl_vatTotal.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TextEditingController _controller =
              TextEditingController(text: currency.format(snapshot.data ?? 0));
          return TextFormField(
            readOnly: true,
            controller: _controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              //border: OutlineInputBorder()
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget streamNetTotal() {
    return StreamBuilder(
      stream: ctrl_netTotal.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TextEditingController _controller =
              TextEditingController(text: currency.format(snapshot.data ?? 0));
          return TextFormField(
            readOnly: true,
            controller: _controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              //border: OutlineInputBorder()
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        globals.productCartDraft.sort((a, b) => a.rowIndex.compareTo(b.rowIndex));
      } else {
        globals.productCartDraft.sort((a, b) => b.rowIndex.compareTo(a.rowIndex));
      }
    }
  }

  Widget saleOrderDetails() {
    return FutureBuilder<Object>(
        future: _apiService.getSODT(SOHD.soid),
        builder: (context, snapshot) {
          print('SOHD >>>>>>>>>>>>>>>>>>>>>>>>  ${SOHD.soid ?? 'No SOID'}');
          if (snapshot.hasData) {
            SODT = snapshot.data;

            if (globals.isDraftInitial == false) {
              globals.isDraftInitial = true;
              globals.productCartDraft = List<ProductCart>();

              SODT.forEach((x) {
                ProductCart cart = ProductCart()
                  ..rowIndex = x.listNo
                  ..soid = x.soid
                  ..goodId = x.goodId
                  ..goodCode = globals.allProduct
                          .firstWhere((element) => element.goodId == x.goodId,
                              orElse: null)
                          .goodCode ??
                      '-'
                  ..goodName1 = x.goodName
                  ..goodAmount = x.goodAmnt
                  ..goodQty = x.goodQty2
                  ..goodPrice = x.goodPrice2
                  ..discount = x.goodDiscAmnt
                  ..discountType = x.goodDiscFormula != null && x.goodDiscAmnt < 100 ? 'PER' : 'THB'
                  ..discountBase = x.goodDiscAmnt
                  ..mainGoodUnitId = x.goodUnitId2
                  ..vatRate = x.vatrate
                  ..vatType = x.vatType
                ..isFree = x.goodPrice2 == 0 ? true : false;
                  // ..remark = detailRemark.firstWhere((element) => element.soId == x.soid && element.refListNo == x.listNo).remark;
                print('Cart >>>>>>>>>>>>>>> ${cart.discountType}');
                globals.productCartDraft.add(cart);
              });

              globals.productCartDraft
                  .where((element) => element.soid == SOHD.soid)
                  .forEach((element) {
                discountTotal += element.discountBase ?? 0;
              });
              // globals.productCartDraft.forEach((element) {
              //   priceTotal += element.goodAmount;
              // });
              //
              // ctrl_priceTotal.add(priceTotal);
            } else {print('snapshot has not data');}

            //txtDiscountTotal.text = currency.format(discountTotal ?? 0);
            calculateSummary();
          }
          return DataTable(
              showBottomBorder: true,
              columnSpacing: 26,
              sortColumnIndex: 0,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    '???????????????',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                  onSort: (columnIndex, ascending){
                    setState(() {

                    });
                    onSortColumn(columnIndex, ascending);
                  }
                ),
                DataColumn(
                  label: Text(
                    '??????????????????',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '??????????????????????????????',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '??????????????????????????????',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    '???????????????',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    '???????????? / ???????????????',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    '??????????????????',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    '????????????????????????',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: globals.productCartDraft
                  .map((e) => DataRow(cells: [
                        DataCell(Text('${e.rowIndex}')),
                        DataCell(Text('${e.isFree ?? false ? '??????????????????' : '????????????????????????'}')),
                        DataCell(Text('${e.goodCode}')),
                        DataCell(Text('${e.goodName1}')),
                        DataCell(Text('${currency.format(e.goodQty ?? 0)}')),
                        DataCell(Text('${currency.format(e.goodPrice ?? 0)}')),
                        DataCell(
                            Text('${currency.format(e.discountBase ?? 0)}')),
                        DataCell(Text('${currency.format(e.goodAmount ?? 0)}')),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              ContainerProduct(
                                                  '??????????????????????????????????????????????????? ???????????????????????? ',
                                                  e,
                                                  'DRAFT'))).then((value) {
                                    setState(() {});
                                  });
                                });
                              },
                              child: Icon(Icons.edit),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blueAccent),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //int removeIndex = globals.productCart.indexWhere((element) => element.rowIndex == e.rowIndex);
                                int index = 1;
                                globals.productCartDraft.removeWhere(
                                    (element) =>
                                        element.rowIndex == e.rowIndex);
                                globals.productCartDraft.forEach((element) {
                                  element.rowIndex = index++;
                                });
                                //globals.editingProductCart = null;
                                //globals.productCartDraft = List<ProductCart>();
                                print(
                                    globals.productCartDraft.length.toString());

                                // priceTotal = 0;
                                // globals.productCartDraft.forEach((element) {
                                //   priceTotal += element.goodAmount;
                                // });
                                //
                                // ctrl_priceTotal.add(priceTotal);

                                calculateSummary();

                                setState(() {});
                              },
                              child: Icon(Icons.delete_forever),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent),
                              ),
                            )
                          ],
                        )),
                        // DataCell(ElevatedButton(
                        //     onPressed: () {},
                        //     child: Icon(Icons.delete_forever),
                        //   style: ButtonStyle(
                        //     backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                        //   ),)),
                      ]))
                  ?.toList());
        });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('?????????????????????????????????????????? ?'),
            content: Text('?????????????????????????????????????????????????????????????????????????????????????????????????????? ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  globals.isDraftInitial = false;
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0,)));
                  },
                child: Text('??????????????????????????????'),
              ),
              TextButton(
                onPressed: () async {
                  globals.isDraftInitial = false;
                  await putSaleOrder('D');
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0,)));
                },
                /*Navigator.of(context).pop(true)*/
                child: Text('??????????????????'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget build(BuildContext context) {
    setSelectedShipto();
    calculateSummary();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text("Sale Order (Draft)"),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.9), BlendMode.lighten),
                image: AssetImage("assets/bg_nic.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(children: [
              Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 11),
                        padding: EdgeInsets.all(10),
                        width: 350,
                        //color: Colors.indigo,
                        child: Text(
                          '?????????????????? ???????????????????????????????????????',
                          style: GoogleFonts.sarabun(
                              color: Colors.white, fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                          // boxShadow: [
                          //   BoxShadow(color: Colors.green, spreadRadius: 3),
                          // ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        //
                        title: TextFormField(
                          //initialValue: '00001',
                          readOnly: true,
                          controller: txtDocuNo,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "??????????????????????????????????????????????????????",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextFormField(
                          controller: txtDocuDate,
                          // initialValue: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          readOnly: true,
                          onTap: () async {
                            _docuDate = await showDatePicker(
                              context: context,
                              initialDate: _docuDate != null
                                  ? _docuDate
                                  : DateTime.now(),
                              firstDate: DateTime(1995),
                              lastDate: DateTime(2030),
                            );

                            setState(() {
                              txtDocuDate.text = DateFormat('dd/MM/yyyy')
                                  .format(_docuDate ?? DateTime.now());
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "????????????????????????????????????",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        //leading: const Icon(Icons.person),
                        title: TextFormField(
                          initialValue: '?????????????????????',
                          readOnly: true,
                          onTap: () {
                            //_showDialog(context);
                          },
                          decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.amberAccent[100],
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "????????????",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextFormField(
                          controller: txtShiptoDate,
                          readOnly: true,
                          onTap: () async {
                            _shiptoDate = await showDatePicker(
                              context: context,
                              initialDate: _shiptoDate != null
                                  ? _shiptoDate
                                  : DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(new Duration(days: 365)),
                            );

                            setState(() {
                              txtShiptoDate.text = DateFormat('dd/MM/yyyy')
                                  .format(_shiptoDate ??
                                      DateTime.now()
                                          .add(new Duration(hours: 24)));
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "??????????????????????????? (???????????? 1 ?????????)",
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextField(
                          readOnly: true,
                          controller: txtRefNo,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "??????????????????????????????????????????????????????????????????",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextField(
                          controller: txtOrderDate,
                          readOnly: true,
                          onTap: () async {
                            _orderDate = await showDatePicker(
                              context: context,
                              initialDate: _orderDate != null
                                  ? _orderDate
                                  : DateTime.now(),
                              firstDate: DateTime(1995),
                              lastDate: DateTime(2030),
                            );

                            setState(() {
                              txtOrderDate.text = DateFormat('dd/MM/yyyy')
                                  .format(_orderDate ?? DateTime.now());
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '????????????????????????????????????????????????????????????',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        //leading: const Icon(Icons.person),
                        title: TextField(
                          controller: txtCustPONo,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            labelText: '???????????????????????????????????????',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        title: TextFormField(
                          readOnly: true,
                          //enabled: false,
                          //initialValue: globals.employee?.empCode,
                          controller: txtEmpCode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "?????????????????????????????????",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextFormField(
                          enabled: false,
                          initialValue: globals.employee?.empName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '?????????????????????????????????',
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        title: TextFormField(
                          enabled: false,
                          controller: txtCustCode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "??????????????????????????????",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextFormField(
                          enabled: false,
                          controller: txtCustName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '??????????????????????????????',
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextFormField(
                          readOnly: true,
                          controller: txtCreditType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "????????????????????????????????????",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: TextFormField(
                          readOnly: true,
                          controller: txtCredit,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '??????????????????',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        //leading: const Icon(Icons.person),
                        title: TextFormField(
                          readOnly: true,
                          controller: txtStatus,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            labelText: '???????????????',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Flexible(
                      flex: 6,
                      child: ListTile(
                        title: TextFormField(
                          readOnly: true,
                          //initialValue: globals.customer?.,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "????????????????????????",
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: EdgeInsets.only(top: 11),
                        padding: EdgeInsets.all(10),
                        width: 350,
                        child: Text(
                          '???????????????????????????????????????',
                          style: GoogleFonts.sarabun(
                              color: Colors.white, fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Flexible(
                        //   flex: 2,
                        //   child: ListTile(
                        //     title: TextFormField(
                        //       readOnly: true,
                        //       initialValue: globals.customer?.custName,
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         contentPadding: EdgeInsets.symmetric(
                        //             horizontal: 10, vertical: 0),
                        //         floatingLabelBehavior:
                        //             FloatingLabelBehavior.always,
                        //         labelText: "??????????????????????????????????????????????????????",
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Flexible(
                        //   flex: 2,
                        //   child: ListTile(
                        //     title: TextFormField(
                        //       readOnly: true,
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         contentPadding: EdgeInsets.symmetric(
                        //             horizontal: 10, vertical: 0),
                        //         floatingLabelBehavior:
                        //             FloatingLabelBehavior.always,
                        //         labelText: '??????????????????????????????',
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Flexible(
                          flex: 6,
                          child: ListTile(
                            title: TextFormField(
                              readOnly: true,
                              //initialValue: globals.customer?.,
                              controller: txtShiptoAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "??????????????????????????????????????????",
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: ListTile(
                            //leading: const Icon(Icons.person),
                            title: TextFormField(
                              readOnly: true,
                              controller: txtShiptoProvince,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                labelText: '??????????????????????????????',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                        ),
                      ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(height: 80),
                    // Flexible(
                    //   flex: 6,
                    //   child: ListTile(
                    //     title: TextFormField(
                    //       readOnly: true,
                    //       //initialValue: globals.customer?.,
                    //       controller: txtShiptoAddress,
                    //       decoration: InputDecoration(
                    //         border: OutlineInputBorder(),
                    //         contentPadding: EdgeInsets.symmetric(
                    //             horizontal: 10, vertical: 0),
                    //         floatingLabelBehavior:
                    //             FloatingLabelBehavior.always,
                    //         labelText: "??????????????????????????????????????????",
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        title: TextFormField(
                          readOnly: true,
                          controller: txtShiptoRemark,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "????????????????????????",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          height: 47,
                          padding: EdgeInsets.only(right: 10),
                          child: ElevatedButton.icon(
                              onPressed: () {
                                //_showShiptoDialog(context);
                                _showDialog(context);
                              },
                              icon: Icon(Icons.airport_shuttle),
                              label: Text('??????????????????????????????')),
                        )),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 47,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  globals.selectedShipto = globals.allShipto
                                      .firstWhere((element) =>
                                          element.custId ==
                                              globals.customer.custId &&
                                          element.isDefault == 'Y');
                                });
                                Fluttertoast.showToast(
                                    msg: "?????????????????????????????????????????????????????????????????????",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 18.0);
                              },
                              icon: Icon(Icons.refresh),
                              label: Text('?????????????????????????????????')),
                        )),
                  ]),

                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: EdgeInsets.only(top: 11),
                        padding: EdgeInsets.all(10),
                        width: 350,
                        child: Text(
                          '?????????????????????????????????????????????',
                          style: GoogleFonts.sarabun(
                              color: Colors.white, fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(height: 10),
                        Container(
                            margin: EdgeInsets.only(top: 13, left: 30),
                            child: RaisedButton.icon(
                              onPressed: () {
                                globals.editingProductCart = null;
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ContainerProduct(
                                            '???????????????????????????????????????????????? ???????????????????????? ',
                                            null,
                                            'DRAFT'))).then((value) {
                                  globals.editingProductCart = null;
                                  setState(() {});
                                });
                              },
                              icon: Icon(Icons.add_circle_outline_outlined,
                                  color: Colors.white),
                              color: Colors.green,
                              splashColor: Colors.green,
                              padding: EdgeInsets.all(10),
                              label: Text(
                                '???????????????????????????????????????????????????',
                                style: GoogleFonts.sarabun(
                                    fontSize: 14, color: Colors.white),
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 13, left: 20),
                            child: RaisedButton.icon(
                              onPressed: () {
                                globals.editingProductCart = null;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContainerProduct(
                                            '???????????????????????????????????????????????? ???????????????????????? ',
                                            null,
                                            'DRAFT')));
                              },
                              icon: Icon(Icons.local_fire_department,
                                  color: Colors.white),
                              color: Colors.deepOrange[400],
                              padding: EdgeInsets.all(10),
                              label: Text(
                                '?????????????????????????????????????????????',
                                style: GoogleFonts.sarabun(
                                    fontSize: 14, color: Colors.white),
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 13, left: 20),
                            child: RaisedButton.icon(
                              onPressed: () {
                                globals.editingProductCart = null;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContainerProduct(
                                            '???????????????????????????????????????????????? ???????????????????????? ',
                                            null,
                                            'DRAFT')));
                              },
                              icon: Icon(Icons.list, color: Colors.white),
                              color: Colors.blueAccent,
                              padding: EdgeInsets.all(10),
                              label: Text(
                                '????????????????????????????????????????????????????????????',
                                style: GoogleFonts.sarabun(
                                    fontSize: 14, color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                    ],
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        saleOrderDetails() ?? [],
                      ])),
                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: EdgeInsets.only(top: 11),
                        padding: EdgeInsets.all(10),
                        width: 350,
                        child: Text(
                          '????????????????????? ???????????????????????????????????????',
                          style: GoogleFonts.sarabun(
                              color: Colors.white, fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showRemarkDialog(context);
                          },
                          icon: Icon(Icons.add_comment),
                          label: Text(
                            '?????????????????????????????????????????????',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      //Expanded(child: SizedBox()),
                      //Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.shortestSide < 400 ? 0 : 235,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('???????????????????????????',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Flexible(child: streamDiscountTotal()),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 35.0, right: 8.0),
                            child: Text('?????????????????????',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: streamPriceTotal(),
                              // child: TextFormField(
                              //   readOnly: true,
                              //   controller: txtPriceTotal,
                              //   textAlign: TextAlign.right,
                              //   decoration: InputDecoration(
                              //     border: OutlineInputBorder(),
                              //     contentPadding: EdgeInsets.symmetric(
                              //         horizontal: 10, vertical: 0),
                              //     floatingLabelBehavior:
                              //         FloatingLabelBehavior.never,
                              //     //border: OutlineInputBorder()
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: txtRemark,
                              maxLines: 8,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "????????????????????????",
                                //border: OutlineInputBorder()
                              ),
                              onChanged: (value) {
                                globals.selectedRemarkDraft.remark = value;
                              },
                            ),
                          )),
                      //Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.shortestSide < 400 ? 0 : 210,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 122,
                                  child: Text('???????????????????????????????????????',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        showDiscountTypeDialog();
                                        //focusDiscount.requestFocus();
                                      },
                                      child: setDiscountType()),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: txtDiscountBill,
                                    focusNode: focusDiscount,
                                    textAlign: TextAlign.right,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    onTap: () {
                                      txtDiscountBill.selection = TextSelection(
                                          baseOffset: 0,
                                          extentOffset: txtDiscountBill
                                              .value.text.length);
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        if (globals.discountBillDraft.type == 'PER'
                                            && double.tryParse(txtDiscountBill.text.replaceAll(',', '')) > 100) {
                                          // showDialog(
                                          //     context: context,
                                          //   builder: (BuildContext context){
                                          //       return AlertDialog(
                                          //         title: Text('???????????????????????????'),
                                          //         content: Text('??????????????????????????????????????? 100')
                                          //       );
                                          //   },
                                          // );
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return RichAlertDialog(
                                                  //uses the custom alert dialog
                                                  alertTitle: richTitle(
                                                      "???????????????????????????????????????????????????????????? 100"),
                                                  alertSubtitle: richSubtitle(
                                                      "??????????????????????????????????????????????????????????????????????????????????????????????????????????????????"),
                                                  alertType:
                                                      RichAlertType.WARNING,
                                                );
                                              });
                                        } else if(globals.discountBillDraft.type == 'PER') {
                                          globals.discountBillDraft.number =
                                              double.tryParse(txtDiscountBill
                                                  .text
                                                  .replaceAll(',', ''));
                                          FocusScope.of(context).unfocus();
                                        }
                                        else if(globals.discountBillDraft.type == 'THB') {
                                          double disc = double.tryParse(txtDiscountBill.text.replaceAll(',', ''));
                                          //globals.discountBillDraft.discountNumber = globals.discountBillDraft.discountAmount;
                                          globals.discountBillDraft.number = disc;
                                          globals.discountBillDraft.amount = disc;
                                          FocusScope.of(context).unfocus();
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      //border: OutlineInputBorder()
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 195,
                                  child: Text('??????????????????????????????????????????',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: streamPriceAfterDiscount()))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 195,
                                  child: Text('???????????? 7%',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: streamVatTotal()))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 195,
                                  child: Text('????????????????????????',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: streamNetTotal()),
                                )
                              ],
                            ),
                          ]))
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: TextFormField(
                  //         readOnly: true,
                  //         textAlign: TextAlign.right,
                  //         maxLines: 8,
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           contentPadding:
                  //               EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  //           floatingLabelBehavior: FloatingLabelBehavior.always,
                  //           labelText: "????????????????????????",
                  //           //border: OutlineInputBorder()
                  //         ),
                  //       ),
                  //     ),
                  //     Spacer(),
                  //     Expanded(
                  //       flex: 1,
                  //         child:
                  //         Row(
                  //             children: [
                  //               Expanded(child: Row(
                  //                 children: [
                  //                   Text('???????????????????????????????????????'),
                  //                   Expanded(flex:6,child: TextField())
                  //                 ],
                  //               )),
                  //               Expanded(flex:8,child: Row(
                  //                 children: [
                  //                   Text('???????????????????????????????????????'),
                  //                   Expanded(child: TextField())
                  //                 ],
                  //               )),
                  //               // Expanded(child: TextField()),
                  //               // Text('???????????????????????????????????????'),
                  //               // Expanded(child: TextField()),
                  //             ],
                  //           ),
                  //
                  //         ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (globals.productCartDraft.length == 0) {
                                  return globals.showAlertDialog(
                                      '???????????????????????????????????????????????????????????????',
                                      '?????????????????????????????????????????????????????????????????????',
                                      context);
                                }

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  width: 400,
                                  title: 'Confirmation',
                                  desc: 'Are you sure to save draft ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    // setState(() {});
                                    await putSaleOrder('D');
                                    // postSaleOrder().then((value) => setState((){}));
                                  },
                                )..show();
                                //print(jsonEncode(globals.productCart));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green)),
                              child: Text(
                                '??????????????????????????????????????????',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  width: 400,
                                  title: 'Confirmation',
                                  desc: 'Are you sure to create sales order ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    setState(() {});
                                    await putSaleOrder('N');
                                    // postSaleOrder().then((value) => setState((){}));
                                  },
                                )..show();
                                //print(jsonEncode(globals.productCart));
                              },
                              child: Text(
                                '??????????????????????????????????????????????????????',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      )
                    ],
                  ),
                  //SizedBox(height: 20,)
                ],
              )
            ]),
          )),
    );
  }
}
