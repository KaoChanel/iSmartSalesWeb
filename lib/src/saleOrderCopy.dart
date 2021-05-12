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
import 'package:ismart_crm/models/saleOrder_detail_remark.dart';
import 'package:ismart_crm/models/saleOrder_header_remark.dart';
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
import 'package:rich_alert/rich_alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SaleOrderCopy extends StatefulWidget {
  SaleOrderCopy({@required this.header, @required this.detail});

  final SaleOrderHeader header;
  final List<SaleOrderDetail> detail;

  @override
  _SaleOrderCopyState createState() => _SaleOrderCopyState();
}

class _SaleOrderCopyState extends State<SaleOrderCopy> {
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
  DateTime _shiptoDate = DateTime.now().add(new Duration(hours: 24));
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

  void setHeader() async {
    localCustomer = globals.allCustomer.firstWhere((e) => e.custId == widget.header.custId, orElse: null);
    globals.customer = localCustomer;
    globals.selectedShipto = globals.allShipto?.firstWhere(
            (element) => element.custId == localCustomer?.custId, orElse: () => null);
    SOHD = widget.header;
    headerRemark = await _apiService.getHeaderRemark(SOHD.soid);
    detailRemark = await _apiService.getDetailRemark(SOHD.soid);
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

    // runningNo = SOHD.docuNo ?? '';
    // refNo = SOHD.refNo ?? '';
    // _docuDate = editedDocuDate == false ? SOHD.docuDate : _docuDate;
    // _shiptoDate = editedShipDate == false ? SOHD.shipDate : _shiptoDate;
    // _docuDate = SOHD.docuDate;
    // _shiptoDate = SOHD.shipDate;
    // _orderDate = SOHD.custPodate;

    //txtRefNo.text = refNo = await _apiService.getRefNo();
    // custPONo = '${globals.employee?.empCode}-${runningNo ?? ''}';
    // txtCustPONo.text = custPONo ?? '';
    // txtRunningNo.text = await runningNo ?? '';

    docuNo = await _apiService.getDocNo();
    txtDocuNo.text = docuNo ?? '';
    refNo = '${globals.company}${globals.employee?.empCode}-${docuNo ?? ''}';
    txtRefNo.text = refNo;
    txtEmpCode.text = globals.employee.empCode;

    discountBill = SOHD.billDiscAmnt;
    vatTotal = SOHD.vatamnt;

    txtDocuDate.text = DateFormat('dd/MM/yyyy').format(_docuDate);

    globals.selectedShiptoCopy = globals.allShipto?.firstWhere((x) =>
        x.custId == widget.header.custId &&
        x.shiptoCode == widget.header.shipToCode, orElse: () => null);
    setSelectedShipto();
    txtShiptoDate.text =
        _shiptoDate != null ? DateFormat('dd/MM/yyyy').format(_shiptoDate) : '';
    txtShiptoRemark.text = SOHD.remark ?? '';
    txtOrderDate.text =
        _orderDate != null ? DateFormat('dd/MM/yyyy').format(_orderDate) : '';
    txtEmpCode.text = '${globals.employee?.empCode}';
    txtCustCode.text = globals.allCustomer
            ?.firstWhere((element) => element.custId == SOHD.custId)
            ?.custCode ??
        '';
    txtCustName.text = SOHD.custName ?? '';
    txtCreditType.text = globals.allCustomer
            .firstWhere((element) => element.custId == SOHD.custId)
            .creditType ??
        '';
    txtCredit.text = globals.allCustomer
            .firstWhere((element) => element.custId == SOHD.custId)
            .creditDays
            .toString() ??
        '0';
    creditState = globals.allCustomer
            .firstWhere((element) => element.custId == SOHD.custId)
            .creditState ??
        '-';
    txtStatus.text = creditState == 'H'
        ? 'Holding'
        : creditState == 'I'
            ? 'Inactive'
            : 'ปกติ';
    txtRemark.text = headerRemark?.remark ?? '';
    // double DiscountTotal = 0;
    // SODT.where((element) => element.soid == SOHD.soid).forEach((element) {DiscountTotal += element.goodDiscAmnt;});
    // txtDiscountTotal.text = currency.format(DiscountTotal);
    txtPriceTotal.text = currency.format(SOHD.sumGoodAmnt);
    txtDiscountBill.text = currency.format(SOHD.billDiscAmnt);
    txtPriceAfterDiscount.text = currency.format(SOHD.billAftrDiscAmnt);
    txtVatTotal.text = currency.format(SOHD.vatamnt ?? 0);
    txtNetTotal.text = currency.format(SOHD.netAmnt);

    globals.discountBillCopy.amount = discountBill;
    ctrl_discountBill.add(discountBill);
    ctrl_vatTotal.add(vatTotal);

    calculateSummary();
  }

  void calculateSummary() {
    try {
      print('Calculate globals.productCartCopy : ' +
          globals.productCartCopy.length.toString());
      if (globals.productCartCopy.length > 0) {
        discountTotal = 0;
        priceTotal = 0;
        globals.productCartCopy.forEach((element) {
          discountTotal += element.discountBase;
        });

        globals.productCartCopy.forEach((element) {
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
      if (globals.discountBillCopy.type == 'PER') {
        double percentDiscount = globals.discountBillCopy.number / 100;
        globals.discountBillCopy.amount = (percentDiscount * priceTotal);
        priceAfterDiscount = priceTotal - globals.discountBillCopy.amount;
      } else {
        priceAfterDiscount = priceTotal - globals.discountBillCopy.amount;
      }

      double sumPriceIncludeVat = 0;
      if (globals.productCartCopy != null) {
        globals.productCartCopy
            .where((element) => element?.vatRate != null)
            .toList()
            .forEach((element) {
          sumPriceIncludeVat += element.goodAmount;
        });
      }

      // vatTotal = (priceAfterDiscount * vat) / 100;
      // vatTotal = (sumPriceIncludeVat * vat) / 100;
      // sumPriceIncludeVat = sumPriceIncludeVat - (globals.discountBillDraft);
      //sumPriceIncludeVat = priceAfterDiscount;
      print('sumPriceIncludeVat:  ' + sumPriceIncludeVat.toString());
      print('globals.discountBillCopy:  ' +
          globals.discountBillCopy.amount.toString());
      //print('sumPriceIncludeVat * 0.07:  ' + (sumPriceIncludeVat + (sumPriceIncludeVat * vat)).toString());
      print((sumPriceIncludeVat * vat).toString());
      vatTotal = (priceAfterDiscount * 0.07);
      netTotal = priceAfterDiscount + vatTotal;

      // txtDiscountTotal.text = currency.format(discountTotal);
      // txtPriceTotal.text = currency.format(priceTotal);
      // txtDiscountBill.text = currency.format(globals.discountBillDraft);
      // txtPriceAfterDiscount.text = currency.format(priceAfterDiscount);
      // txtVatTotal.text = currency.format(vatTotal);
      // txtNetTotal.text = currency.format(netTotal);

      ctrl_discountTotal.add(discountTotal);
      ctrl_priceTotal.add(priceTotal);
      ctrl_discountBill.add(discountBill);
      ctrl_priceAfterDiscount.add(priceAfterDiscount);
      ctrl_vatTotal.add(vatTotal);
      ctrl_netTotal.add(netTotal);
    } catch (e) {
      showDialog(
          builder: (context) => AlertDialog(
                title: Text('Exception'),
                content: Text(e.toString()),
              ),
          context: context);
    }
  }

  Widget setDiscountType() {
    if (globals.discountBillCopy.type == 'THB') {
      return Text('THB');
    } else {
      return Text('%');
    }
  }

  void setSelectedShipto() {
    txtShiptoProvince.text = globals.selectedShiptoCopy?.province ?? '';
    txtShiptoAddress.text = '${globals.selectedShiptoCopy?.shiptoAddr1 ?? ''} '
        '${globals.selectedShiptoCopy?.shiptoAddr2 ?? ''} '
        '${globals.selectedShiptoCopy?.district ?? ''} '
        '${globals.selectedShiptoCopy?.amphur ?? ''} '
        '${globals.selectedShiptoCopy?.province ?? ''} '
        '${globals.selectedShiptoCopy?.postcode ?? ''}';
    txtShiptoRemark.text = globals.selectedShiptoCopy?.remark ?? '';
  }

  Widget getShiptoListWidgets(BuildContext context) {
    List<Shipto> shiptoList = globals.allShipto
        .where((element) => element.custId == widget.header.custId)
        .toList();

    shiptoList.map((e) => print('Shipping to address: ' + e.shiptoAddr1));
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < shiptoList?.length; i++) {
      list.add(ListTile(
        title: Text(
            '${shiptoList[i]?.shiptoAddr1 ?? ''} ${shiptoList[i]?.district ?? ''} ${shiptoList[i]?.amphur ?? ''} ${shiptoList[i]?.province ?? ''} ${shiptoList[i]?.postcode ?? ''}'),
        //subtitle: Text(item?.custCode),

        onTap: () {
          globals.selectedShiptoCopy = shiptoList[i];
          Navigator.pop(context);
          setState(() {});
        },
        selected: globals.selectedShiptoCopy?.shiptoAddr1 ==
                shiptoList[i]?.shiptoAddr1 ??
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
            txtRemark.text = globals.selectedRemarkDraft?.remark;
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

  Future<dynamic> postSaleOrder(String status) async {
    try {
      globals.showLoaderDialog(context, false);
      SaleOrderHeader header = new SaleOrderHeader();
      List<SaleOrderDetail> detail = new List<SaleOrderDetail>();
      // runningNo = custPono;
      // refNo =
      //     '${globals.company}${globals.employee?.empCode}-${runningNo ?? ''}';

      // refNo = refNo;
      // docuNo = docuNo;

      runningNo = await _apiService.getRefNo();
      docuNo = await _apiService.getDocNo();
      refNo =
      '${globals.company}${globals.employee?.empCode}-${runningNo ?? ''}';

      print('DocuNo : ' + docuNo);
      print('refNo : ' + refNo);

      /// Company Info
      header.brchId = 1;

      /// document header.
      header.soid = 0;
      header.saleAreaId = localCustomer.saleAreaId;
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
      // header.remark = txtRemark.text ?? '';
      header.postdocutype = 1702;

      /// VAT Info
      header.vatgroupId = globals.vatGroup.vatgroupId;
      header.vatRate = globals.vatGroup.vatRate;
      header.vatType = globals.vatGroup.vatType;
      header.vatamnt = vatTotal;

      /// employee information.
      header.empId = globals.employee.empId;
      header.deptId = globals.employee.deptId;

      /// customer information.
      header.custId = localCustomer.custId;
      header.custName = localCustomer.custName;
      header.creditDays = localCustomer.creditDays;

      /// Cost Summary.
      header.sumGoodAmnt = priceTotal;
      header.billAftrDiscAmnt = priceAfterDiscount;
      header.netAmnt = netTotal;
      header.billDiscAmnt = globals.discountBillCopy.amount;

      /// Discount

      /// shipment to customer.
      header.shipToCode = globals.selectedShiptoCopy.shiptoCode;
      header.transpId = globals.selectedShiptoCopy.transpId;
      header.transpAreaId = globals.selectedShiptoCopy.transpAreaId;
      header.shipToAddr1 = globals.selectedShiptoCopy.shiptoAddr1;
      header.shipToAddr2 = globals.selectedShiptoCopy.shiptoAddr2;
      header.district = globals.selectedShiptoCopy.district;
      header.amphur = globals.selectedShiptoCopy.amphur;
      header.province = globals.selectedShiptoCopy.province;
      header.postCode = globals.selectedShiptoCopy.postcode;
      header.remark = globals.selectedShiptoCopy.remark;
      header.isTransfer = status;

      header = await _apiService.addSaleOrderHeader(header);
      print('Add result: ${header.soid}');
      if (header != null) {
        globals.productCartCopy.forEach((e) {
          SaleOrderDetail obj = new SaleOrderDetail();
          obj.soid = header.soid;
          obj.listNo = e.rowIndex;
          obj.docuType = 104;
          obj.goodType = '1';
          obj.goodId = e.goodId;
          obj.goodName = e.goodName1;
          obj.goodUnitId2 = e.mainGoodUnitId;
          obj.goodQty2 = e.goodQty;
          obj.goodPrice2 = e.goodPrice;
          obj.goodAmnt = e.goodAmount;
          obj.afterMarkupamnt = e.goodAmount;
          obj.goodDiscAmnt = e.discountBase;
          obj.isTransfer = status;

          /// Empty Field
          obj.goodQty1 = 0.00;
          obj.goodPrice1 = 0.00;
          obj.goodCompareQty = 0;
          obj.goodCost = 0;
          detail.add(obj);
        });

        if (await _apiService.addSaleOrderDetail(detail) == true) {
          SoHeaderRemark headerRemark = SoHeaderRemark()
            ..soId = header.soid
            ..listNo = 1
            ..remark = txtRemark.text
            ..isTransfer = status;

          if (await _apiService.addSOHeaderRemark(headerRemark)) {
            var dtRemarkAll = List<SoDetailRemark>();
            detail.forEach((e) {
              var dtRemark = SoDetailRemark()
              ..soId = e.soid
              ..refListNo = e.listNo
              ..listNo = e.listNo
              ..remark = e.goodsRemark
              ..isTransfer = status;
              dtRemarkAll.add(dtRemark);
            });

            if (await _apiService.addSODetailRemark(dtRemarkAll)) {
              globals.clearCopyOrder();
              txtRemark.text = '';
              Navigator.pop(context);
              Navigator.pop(context);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StatusTransferDoc()));
              // Navigator.pushReplacement(context,
                  // MaterialPageRoute(builder: (context) => StatusTransferDoc()));
              print('Order Successful.');
              setState(() {});
              return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return RichAlertDialog(
                      //uses the custom alert dialog
                      alertTitle: status == 'N'
                          ? richTitle("Transaction Successfully.")
                          : richTitle("Your draft has saved."),
                      alertSubtitle: richSubtitle("Your order has created. "),
                      alertType: RichAlertType.SUCCESS,
                    );
                  });
            }
          }

          // globals.clearCopyOrder();
          // // Navigator.pop(context);
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => StatusTransferDoc()));
          // // setState(() {});
          // return showDialog<void>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return RichAlertDialog(
          //         //uses the custom alert dialog
          //         alertTitle: richTitle("Transaction Successfully."),
          //         alertSubtitle: richSubtitle("Your order has created. "),
          //         alertType: RichAlertType.SUCCESS,
          //       );
          //     });
          // globals.clearOrder();
          // print('Order Successful.');
        } else {
          Navigator.pop(context);
          return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return RichAlertDialog(
                  //uses the custom alert dialog
                  alertTitle: richTitle("Details of Sales Order was failed."),
                  alertSubtitle: richSubtitle(
                      "Something was wrong while creating SO Details."),
                  alertType: RichAlertType.ERROR,
                );
              });
        }
      }
      else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                //uses the custom alert dialog
                alertTitle: richTitle("Header of Sales Order was failed."),
                alertSubtitle: richSubtitle(
                    "Something was wrong while creating SO Header."),
                alertType: RichAlertType.ERROR,
              );
            });
      }
    } catch (e) {
      Navigator.pop(context);
      return showAboutDialog(
          context: context,
          applicationName: 'Post Sale Order Exception',
          applicationIcon: Icon(Icons.error_outline),
          children: [
            Text(e.toString()),
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
            title: new Text('สถานที่จัดส่ง'),
            content: Container(
                width: 500, height: 300, child: getShiptoListWidgets(context)));
      },
    );
  }

  void _showRemarkDialog(context) async {
    // flutter defined function
    var alert = AlertDialog(
        elevation: 0,
        title: new Text('ข้อความหมายเหตุ'),
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
            title: new Text('ประเภทส่วนลด'),
            content: Container(
                width: 250,
                height: 180,
                child: ListView(children: [
                  ListTile(
                      onTap: () {
                        //discountType = globals.DiscountType.THB;
                        globals.discountBillCopy.type = 'THB';
                        Navigator.pop(context);
                        setState(() {});
                      },
                      selected: globals.discountBillCopy.type == 'THB',
                      selectedTileColor: Colors.black12,
                      title: Text('THB')),
                  ListTile(
                    onTap: () {
                      //discountType = globals.DiscountType.PER;
                      globals.discountBillCopy.type = 'PER';
                      Navigator.pop(context);
                      setState(() {});
                    },
                    selected: globals.discountBillCopy.type == 'PER',
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
        globals.productCartCopy
            .sort((a, b) => a.rowIndex.compareTo(b.rowIndex));
      } else {
        globals.productCartCopy
            .sort((a, b) => b.rowIndex.compareTo(a.rowIndex));
      }
    }
  }

  Widget saleOrderDetails() {
    if (globals.isCopyInitial == false) {
      globals.productCartCopy = List<ProductCart>();
      widget.detail.forEach((x) {
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
          ..discountBase = x.goodDiscAmnt
          ..discountType = x.goodDiscType
          ..mainGoodUnitId = x.goodUnitId2
          ..vatRate = x.vatrate
          ..vatType = x.vatType
          ..isFree = x.goodPrice2 == 0 ? true : false;

        globals.productCartCopy.add(cart);
      });
      globals.isCopyInitial = true;
    }

    globals.productCartDraft
        .where((element) => element.soid == SOHD.soid)
        .forEach((element) {
      discountTotal += element.discountBase ?? 0;
    });

    calculateSummary();

    return DataTable(
        showBottomBorder: true,
        columnSpacing: 26,
        sortColumnIndex: 0,
        columns: <DataColumn>[
          DataColumn(
              label: Text(
                'ลำดับ',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {});
                onSortColumn(columnIndex, ascending);
              }),
          DataColumn(
            label: Text(
              'ประเภท',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'รหัสสินค้า',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'ชื่อสินค้า',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),
          DataColumn(
            numeric: true,
            label: Text(
              'จำนวน',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),
          DataColumn(
            numeric: true,
            label: Text(
              'ราคา / หน่วย',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),
          DataColumn(
            numeric: true,
            label: Text(
              'ส่วนลด',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),
          DataColumn(
            numeric: true,
            label: Text(
              'ยอดสุทธิ',
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
        rows: globals.productCartCopy
            .map((e) => DataRow(cells: [
                  DataCell(Center(child: Text('${e.rowIndex}'))),
                  DataCell(Center(
                      child: Text(
                          '${e.isFree ?? false ? 'แถมฟรี' : 'เพื่อขาย'}'))),
                  DataCell(Text('${e.goodCode}')),
                  DataCell(
                      Container(width: 300, child: Text('${e.goodName1}'))),
                  DataCell(Text('${currency.format(e.goodQty ?? 0)}')),
                  DataCell(Text('${currency.format(e.goodPrice ?? 0)}')),
                  DataCell(Text('${currency.format(e.discountBase ?? 0)}')),
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
                                    builder: (context) => ContainerProduct(
                                        'แก้ไขรายการสินค้า ลำดับที่ ',
                                        e,
                                        'COPY'))).then((value) {
                              setState(() {});
                            });
                          });
                        },
                        child: Icon(Icons.edit),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
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
                          globals.productCartCopy.removeWhere(
                              (element) => element.rowIndex == e.rowIndex);
                          globals.productCartCopy.forEach((element) {
                            element.rowIndex = index++;
                          });
                          //globals.editingProductCart = null;
                          //globals.productCartDraft = List<ProductCart>();
                          print(globals.productCartCopy.length.toString());

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
                          backgroundColor: MaterialStateProperty.all<Color>(
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
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('บันทึกฉบับร่าง ?'),
            content: Text('คุณต้องการบันทึกฉบับร่างนี้หรือไม่ ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  globals.isCopyInitial = false;
                  Navigator.of(context).pop(true);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Launcher(
                                pageIndex: 0,
                              )));
                },
                child: Text('ไม่ต้องการ'),
              ),
              TextButton(
                onPressed: () async {
                  globals.isCopyInitial = false;
                  await postSaleOrder('D');
                  Navigator.of(context).pop(true);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Launcher(
                                pageIndex: 0,
                              )));
                },
                /*Navigator.of(context).pop(true)*/
                child: Text('บันทึก'),
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
              child: Text("Sale Order"),
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
                          'หัวบิล การสั่งสินค้า',
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
                            labelText: "เลขที่ใบสั่งสินค้า",
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
                            labelText: "วันที่เอกสาร",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        //leading: const Icon(Icons.person),
                        title: TextFormField(
                          initialValue: 'ฝ่ายขาย',
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
                            labelText: "แผนก",
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
                            labelText: "วันที่ส่ง (ปกติ 1 วัน)",
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
                            labelText: "เลขที่ใบสั่งซื้อลูกค้า",
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
                            labelText: 'วันที่สั่งซื้อลูกค้า',
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
                            labelText: 'จากใบเสนอราคา',
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
                            labelText: "รหัสพนักงาน",
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
                            labelText: 'ชื่อพนักงาน',
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
                            labelText: "รหัสลูกค้า",
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
                            labelText: 'ชื่อลูกค้า',
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
                            labelText: "ประเภทเครดิต",
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
                            labelText: 'เครดิต',
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
                            labelText: 'สถานะ',
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
                            labelText: "หมายเหตุ",
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
                          'สถานที่จัดส่ง',
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
                        //         labelText: "ชื่อสถานที่ส่งจริง",
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
                        //         labelText: 'สถานที่ส่ง',
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Flexible(
                          flex: 5,
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
                                labelText: "สถานที่ส่งจริง",
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: ListTile(
                            //leading: const Icon(Icons.person),
                            title: TextFormField(
                              readOnly: true,
                              controller: txtShiptoProvince,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                labelText: 'ส่งจังหวัด',
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
                    //         labelText: "สถานที่ส่งจริง",
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
                            labelText: "หมายเหตุ",
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
                              label: Text('สถานที่ส่ง')),
                        )),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 47,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  globals.selectedShiptoCopy = globals.allShipto
                                      .firstWhere((element) =>
                                          element.custId ==
                                              widget.header.custId &&
                                          element.shiptoCode ==
                                              widget.header.shipToCode);
                                });
                                Fluttertoast.showToast(
                                    msg: "ใช้ค่าเริ่มต้นเรียบร้อย",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 18.0);
                              },
                              icon: Icon(Icons.refresh),
                              label: Text('ค่าเริ่มต้น')),
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
                          'รายการสินค้าขาย',
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
                                          'สั่งรายการสินค้า ลำดับที่ ',
                                          null,
                                          'COPY'))).then((value) {
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
                              'เพิ่มรายการสินค้า',
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
                                          'สั่งรายการสินค้า ลำดับที่ ',
                                          null,
                                          'COPY')));
                            },
                            icon: Icon(Icons.local_fire_department,
                                color: Colors.white),
                            color: Colors.deepOrange[400],
                            padding: EdgeInsets.all(10),
                            label: Text(
                              'เพิ่มรายการด่วน',
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
                                          'สั่งรายการสินค้า ลำดับที่ ',
                                          null,
                                          'COPY')));
                            },
                            icon: Icon(Icons.list, color: Colors.white),
                            color: Colors.blueAccent,
                            padding: EdgeInsets.all(10),
                            label: Text(
                              'เพิ่มรายการโปรโมชั่น',
                              style: GoogleFonts.sarabun(
                                  fontSize: 14, color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        saleOrderDetails(),
                      ])),
                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: EdgeInsets.only(top: 11),
                        padding: EdgeInsets.all(10),
                        width: 350,
                        child: Text(
                          'ท้ายบิล การสั่งสินค้า',
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
                            'ข้อความหมายเหตุ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      //Expanded(child: SizedBox()),
                      //Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.shortestSide < 400
                            ? 0
                            : 235,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('รวมส่วนลด',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Flexible(child: streamDiscountTotal()),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 35.0, right: 8.0),
                            child: Text('รวมเงิน',
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
                                labelText: "หมายเหตุ",
                                //border: OutlineInputBorder()
                              ),
                              onChanged: (value) {
                                globals.selectedRemarkDraft.remark = value;
                              },
                            ),
                          )),
                      //Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.shortestSide < 400
                            ? 0
                            : 210,
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
                                  child: Text('ส่วนลดท้ายบิล',
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
                                        if (globals.discountBillCopy.type ==
                                                'PER' &&
                                            double.tryParse(txtDiscountBill.text
                                                    .replaceAll(',', '')) >
                                                100) {
                                          // showDialog(
                                          //     context: context,
                                          //   builder: (BuildContext context){
                                          //       return AlertDialog(
                                          //         title: Text('แจ้งเตือน'),
                                          //         content: Text('ใส่ค่าไม่เกิน 100')
                                          //       );
                                          //   },
                                          // );
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return RichAlertDialog(
                                                  //uses the custom alert dialog
                                                  alertTitle: richTitle(
                                                      "กรอกตัวเลขได้ไม่เกิน 100"),
                                                  alertSubtitle: richSubtitle(
                                                      "ส่วนลดเปอร์เซ็นกรอกได้ไม่เกินหนึ่งร้อย"),
                                                  alertType:
                                                      RichAlertType.WARNING,
                                                );
                                              });
                                        } else if (globals
                                                .discountBillCopy.type ==
                                            'PER') {
                                          globals.discountBillCopy.number =
                                              double.tryParse(txtDiscountBill
                                                  .text
                                                  .replaceAll(',', ''));
                                          FocusScope.of(context).unfocus();
                                        } else {
                                          double disc = double.tryParse(
                                              txtDiscountBill.text
                                                  .replaceAll(',', ''));

                                          globals.discountBillCopy.number =
                                              disc;
                                          globals.discountBillCopy.amount =
                                              disc;
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
                                  child: Text('ยอดก่อนรวมภาษี',
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
                                  child: Text('ภาษี 7%',
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
                                  child: Text('รวมสุทธิ',
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
                  //           labelText: "หมายเหตุ",
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
                  //                   Text('ส่วนลดท้ายบิล'),
                  //                   Expanded(flex:6,child: TextField())
                  //                 ],
                  //               )),
                  //               Expanded(flex:8,child: Row(
                  //                 children: [
                  //                   Text('ส่วนลดท้ายบิล'),
                  //                   Expanded(child: TextField())
                  //                 ],
                  //               )),
                  //               // Expanded(child: TextField()),
                  //               // Text('ส่วนลดท้ายบิล'),
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
                                if (globals.productCartCopy.length == 0) {
                                  return globals.showAlertDialog(
                                      'โปรดเพิ่มรายการสินค้า',
                                      'คุณยังไม่มีรายการสินค้า',
                                      context);
                                }

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  width: 450,
                                  title: 'Confirmation',
                                  desc: 'Are you sure to save draft ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    setState(() {});
                                    globals.isCopyInitial = false;
                                    await postSaleOrder('D');
                                    Navigator.pop(context);
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
                                'บันทึกฉบับร่าง',
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
                                  width: 450,
                                  title: 'Confirmation',
                                  desc: 'Are you sure to create sales order ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    // setState(() {});
                                    globals.isCopyInitial = false;
                                    await postSaleOrder('N');
                                    // Navigator.pop(context);
                                    // postSaleOrder().then((value) => setState((){}));
                                  },
                                )..show();
                                //print(jsonEncode(globals.productCart));
                              },
                              child: Text(
                                'ยืนยันคำสั่งสินค้า',
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
