import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ismart_crm/models/shipto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ismart_crm/src/dashboardPage.dart';
import 'package:ismart_crm/src/statusTransferDoc.dart';
import 'containerProduct.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';
import 'package:ismart_crm/models/saleOrder_header.dart';
import 'package:ismart_crm/models/saleOrder_detail.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ismart_crm/models/saleOrder_header_remark.dart';
import 'package:ismart_crm/models/saleOrder_detail_remark.dart';
import 'package:ismart_crm/models/task_event.dart';

dynamic _selectDate(BuildContext context, DateTime _selectedDate,
    TextEditingController _textEditController) async {
  DateTime newSelectedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
    firstDate: DateTime(1995),
    lastDate: DateTime(2030),
    // builder: (BuildContext context, Widget child) {
    //   return Theme(
    //     data: ThemeData.dark().copyWith(
    //       colorScheme: ColorScheme.dark(
    //         primary: Colors.deepPurple,
    //         onPrimary: Colors.white,
    //         surface: Colors.blueGrey,
    //         onSurface: Colors.yellow,
    //       ),
    //       dialogBackgroundColor: Colors.blue[500],
    //     ),
    //     child: child,
    //   );
    // }
  );

  if (newSelectedDate != null) {
    _selectedDate = newSelectedDate;
    _textEditController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);

    // _textEditingController..text = DateFormat.yMMMd().format(_selectedDate)..selection = TextSelection.fromPosition(TextPosition(
    //       offset: _textEditingController.text.length,
    //       affinity: TextAffinity.upstream));
  }
}

void _showShiptoDialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return alert dialog object
      return AlertDialog(
        title: new Text('??????????????????????????????????????????????????????'),
        content: Container(
          height: 150.0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // new Row(
                //   children: <Widget>[
                //     new Icon(Icons.toys),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 8.0),
                //       child: new Text(' First Item'),
                //     ),
                //   ],
                // ),
                // new SizedBox(
                //   height: 20.0,
                // ),
                // new Row(
                //   children: <Widget>[
                //     new Icon(Icons.toys),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 8.0),
                //       child: new Text(' Second Item'),
                //     ),
                //   ],
                // ),
                // new SizedBox(
                //   height: 20.0,
                // ),
                // new Row(
                //   children: <Widget>[
                //     new Icon(Icons.toys),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 8.0),
                //       child: new Text('Third Item'),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class SaleOrder extends StatefulWidget {
  @override
  _SaleOrderState createState() => _SaleOrderState();
}

class _SaleOrderState extends State<SaleOrder> {
  ApiService _apiService = new ApiService();
  final currency = new NumberFormat("#,##0.00", "en_US");
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

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtCustPONo = TextEditingController();
  TextEditingController txtSONo;
  TextEditingController txtDeptCode;
  TextEditingController txtCopyDocuNo;
  TextEditingController txtEmpCode = TextEditingController();
  TextEditingController txtEmpName;
  TextEditingController txtCustCode;
  TextEditingController txtCustName;
  TextEditingController txtCreditType;
  TextEditingController txtCredit = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtRemark = TextEditingController();

  TextEditingController txtShiptoName;
  TextEditingController txtShiptoCode;
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      globals.showLoaderDialog(context, false);
      await setHeader();
      setSelectedShipto();
      Navigator.pop(context);
    });
    calculateSummary();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusDiscount.dispose();
  }

  setHeader() async {
    try {
      runningNo = await _apiService.getRefNo();
      refNo = '${globals.company}${globals.employee?.empCode}-${runningNo ?? ''}';
      txtRefNo.text = refNo;
      // custPONo = '${globals.employee?.empCode}-${runningNo ?? ''}';
      // txtCustPONo.text = custPONo ?? '';
      // txtRunningNo.text = runningNo ?? '';

      docuNo = await _apiService.getDocNo();
      txtDocuNo.text = docuNo ?? '';
      txtEmpCode.text = '${globals.employee?.empCode}';
      creditState = globals.allCustomer
          .firstWhere((element) => element.custId == globals.customer.custId)
          .creditState ??
          '';
      txtStatus.text = creditState == 'H'
          ? 'Holding'
          : creditState == 'I'
          ? 'Inactive'
          : '????????????';
      txtRemark.text = globals.selectedRemark?.remark ?? '';

      // setState(() {
      //   txtRunningNo.text = runningNo ?? '';
      //   txtRefNo.text = refNo ?? '';
      //   txtDocuNo.text = docuNo ?? '';
      //   txtEmpCode.text = '${globals.company}${globals.employee?.empCode}';
      // });

      print('Set Header.');
      print('Doc No: $docuNo');
      print('Ref No: $refNo');
    }
    catch(e) {
      globals.showAlertDialog('Set Header', e.toString(), context);
    }
  }

  setSelectedShipto() {
    try {
      txtShiptoProvince.text = globals.selectedShipto?.province ?? '';
      txtShiptoAddress.text = '${globals.selectedShipto?.shiptoAddr1 ?? ''} '
          '${globals.selectedShipto?.shiptoAddr2 ?? ''} '
          '${globals.selectedShipto?.district ?? ''} '
          '${globals.selectedShipto?.amphur ?? ''} '
          '${globals.selectedShipto?.province ?? ''} '
          '${globals.selectedShipto?.postcode ?? ''}';
      txtShiptoRemark.text = globals.selectedShipto?.remark ?? '';
    }
    catch(e){
      globals.showAlertDialog('Set Shipment', e.toString(), context);
    }
  }

  Widget setDiscountType() {
    if (globals.discountBill.type == 'THB') {
      return Text('THB');
    } else {
      return Text('%');
    }
  }

  void calculateSummary() {
    try {
      print('Calculate globals.productCart : ' +
          globals.productCart.length.toString());
      if (globals.productCart.length > 0) {
        discountTotal = 0;
        priceTotal = 0;
        globals.productCart.forEach((element) {
          discountTotal += element.discountBase;
        });
        globals.productCart.forEach((element) {
          priceTotal += element.goodAmount;
        });
      } else {
        discountTotal = 0;
        priceTotal = 0;
        priceAfterDiscount = 0;
        // globals.discountBill = 0;
        vatTotal = 0;
        netTotal = 0;
      }

      //priceTotal = priceTotal - discountTotal;
      discountBill = globals.discountBill.number;
      if (globals.discountBill.type == 'PER') {
        double percentDiscount = globals.discountBill.number / 100;
        globals.discountBill.amount = (percentDiscount * priceTotal);
        priceAfterDiscount = priceTotal - globals.discountBill.amount;
      } else {
        globals.discountBill.amount = discountBill;
        priceAfterDiscount = priceTotal - globals.discountBill.number;
      }

      print('globals.discountBill.discountType: >>>> ' +
          globals.discountBill.type);
      print('globals.discountBill.discountAmount: >>>> ' +
          globals.discountBill.amount.toString());

      double sumGoodsHasVat = 0;
      double sumGoodsHasNoVat = 0;

      if (globals.productCart != null) {
        globals.productCart
            .where((x) => x.vatRate > 0)
            .toList()
            .forEach((element) => sumGoodsHasVat += element.goodAmount);
        globals.productCart
            .where((x) => x.vatRate == 0)
            .toList()
            .forEach((element) => sumGoodsHasNoVat += element.goodAmount);
      }

      // vatTotal = (priceAfterDiscount * vat) / 100;
      // vatTotal = (sumPriceIncludeVat * vat) / 100;

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

      setState(() {
        txtDiscountTotal.text = currency.format(discountTotal);
        txtPriceTotal.text = currency.format(priceTotal);
        txtDiscountBill.text = currency.format(globals.discountBill.number);
        txtPriceAfterDiscount.text = currency.format(priceAfterDiscount);
        txtVatTotal.text = currency.format(vatTotal);
        txtNetTotal.text = currency.format(netTotal);
      });
    } catch (e) {
      showDialog(
          builder: (context) => AlertDialog(
                title: Text('Calculation Exception'),
                content: Text(e.toString()),
              ),
          context: context);
    }
  }

  Widget getShiptoList(BuildContext context) {
    List<Shipto> shiptoList = globals.allShipto
        .where((element) => element.custId == globals.customer.custId)
        .toList();
    // print(shiptoList);

    List<Widget> list = new List<Widget>();
    for (var i = 0; i < shiptoList?.length; i++) {
      list.add(ListTile(
        title: Text(
            '${shiptoList[i]?.shiptoAddr1 ?? ''} ${shiptoList[i]?.district ?? ''} ${shiptoList[i]?.amphur ?? ''} ${shiptoList[i]?.province ?? ''} ${shiptoList[i]?.postcode ?? ''}'),
        //subtitle: Text(item?.custCode),
        onTap: () {
          globals.selectedShipto = shiptoList[i];
          Navigator.pop(context);
          setState(() {
            setSelectedShipto();
            calculateSummary();
          });
        },
        selected:
            globals.selectedShipto.shiptoAddr1 == shiptoList[i]?.shiptoAddr1 ??
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
          globals.selectedRemark = allRemark[i];
          setState(() {
            txtRemark.text = globals.selectedRemark?.remark ?? '';
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
                width: 500, height: 300, child: getShiptoList(context)));
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
                        //globals.discountType = globals.DiscountType.THB;
                        globals.discountBill.type = 'THB';
                        Navigator.pop(context);
                        setState(() {calculateSummary();});
                      },
                      selected: globals.discountBill.type == 'THB',
                      selectedTileColor: Colors.black12,
                      title: Text('THB')),
                  ListTile(
                    onTap: () {
                      //discountType = globals.DiscountType.PER;
                      // globals.discountType = globals.DiscountType.PER;
                      globals.discountBill.type = 'PER';
                      Navigator.pop(context);
                      setState(() {calculateSummary();});
                    },
                    selected: globals.discountBill.type == 'PER',
                    selectedTileColor: Colors.black12,
                    title: Text('%'),
                  )
                ])));
      },
    );
  }

  Widget SaleOrderDetails() {
    return DataTable(
        showBottomBorder: true,
        columnSpacing: 26,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              '???????????????',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
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
          // DataColumn(
          //   label: Text(
          //     '',
          //     style: TextStyle(fontStyle: FontStyle.italic),
          //   ),
          // ),
        ],
        rows: globals.productCart
                ?.map((e) => DataRow(cells: [
                      DataCell(Center(child: Text('${e.rowIndex}'))),
                      DataCell(Center(
                          child: Text('${e.isFree ? '??????????????????' : '????????????????????????'}'))),
                      DataCell(Text('${e.goodCode}')),
                      DataCell(Text('${e.goodName1}')),
                      DataCell(Text('${currency.format(e.goodQty)}')),
                      DataCell(Text('${currency.format(e.goodPrice)}')),
                      DataCell(Text('${currency.format(e.discountBase)}')),
                      DataCell(Text('${currency.format(e.goodAmount)}')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ContainerProduct(
                                          '??????????????????????????????????????????????????? ???????????????????????? ',
                                          e,
                                          'ORDER'))).then((value) {
                                setState(() {
                                  calculateSummary();
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
                              globals.productCart.removeWhere(
                                  (element) => element.rowIndex == e.rowIndex);
                              globals.productCart.forEach((element) {
                                element.rowIndex = index++;
                              });
                              globals.editingProductCart = null;
                              print(globals.productCart?.length.toString());
                              setState(() {calculateSummary();});
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
                ?.toList() ??
            <DataRow>[
              DataRow(cells: [
                // DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
                DataCell(Text('????????????????????????????????????????????????????????????')),
              ])
            ]);
  }

  Widget build(BuildContext context) {
    // if(txtDocuNo.text != ''){
    //   Navigator.pop(context);
    // }

    return Scaffold(
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          // _docuDate = await showDatePicker(
                          //   context: context,
                          //   initialDate:
                          //       _docuDate != null ? _docuDate : DateTime.now(),
                          //   firstDate: DateTime(1995),
                          //   lastDate: DateTime(2030),
                          // );
                          //
                          // setState(() {
                          //   if (_docuDate == null) _docuDate = DateTime.now();
                          //   txtDocuDate.text = DateFormat('dd/MM/yyyy').format(_docuDate);
                          // });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                                DateTime.now().add(new Duration(days: 180)),
                          );

                          setState(() {
                            if (_shiptoDate == null)
                              _shiptoDate =
                                  DateTime.now().add(new Duration(hours: 24));

                            txtShiptoDate.text =
                                DateFormat('dd/MM/yyyy').format(_shiptoDate);
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                            if (_orderDate == null) _orderDate = DateTime.now();
                            txtOrderDate.text = DateFormat('dd/MM/yyyy').format(_orderDate);
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        initialValue: globals.customer?.custCode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        initialValue: globals.customer?.custName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        //initialValue: globals.customer,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        initialValue: globals.customer?.creditDays.toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                      Expanded(
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
                              labelText: "??????????????????????????????????????????",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                                          builder: (context) =>
                                              ContainerProduct(
                                                  '???????????????????????????????????????????????? ???????????????????????? ',
                                                  null,
                                                  'ORDER'))).then((value) {
                                    globals.editingProductCart = null;
                                    setState(() {
                                      calculateSummary();
                                    });
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
                          Visibility(
                            visible: false,
                            child: Container(
                                margin: EdgeInsets.only(top: 13, left: 20),
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    globals.editingProductCart = null;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContainerProduct(
                                                    '???????????????????????????????????????????????? ???????????????????????? ',
                                                    null,
                                                    'ORDER'))).then((value) => setState(() => calculateSummary()));
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
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                                margin: EdgeInsets.only(top: 13, left: 20),
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    globals.editingProductCart = null;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContainerProduct(
                                                    '???????????????????????????????????????????????? ???????????????????????? ',
                                                    null,
                                                    'ORDER'))).then((value) => setState(() => calculateSummary()));
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      SaleOrderDetails(),
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
                    // Expanded(flex:2, child: SizedBox()),
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
                          child: Text('???????????????????????????',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: txtDiscountTotal,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              //labelText: "0.00",
                              //border: OutlineInputBorder()
                            ),
                          ),
                        ),
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
                            child: TextFormField(
                              readOnly: true,
                              controller: txtPriceTotal,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                //border: OutlineInputBorder()
                              ),
                            ),
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
                              globals.selectedRemark.remark = value;
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
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onTap: () {
                                    txtDiscountBill.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            txtDiscountBill.value.text.length);
                                  },
                                  onEditingComplete: () {
                                    if(txtDiscountBill.text.isEmpty){return globals.showAlertDialog('???????????????????????????', '?????????????????????????????????????????????', context);}
                                    setState(() {
                                      if (globals.discountBill.type == 'PER' &&
                                          double.tryParse(txtDiscountBill.text
                                                  .replaceAll(',', '')) >
                                              100) {
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
                                      } else if (globals.discountBill.type ==
                                          'PER') {
                                        globals.discountBill.number =
                                            double.tryParse(txtDiscountBill.text
                                                .replaceAll(',', ''));
                                        FocusScope.of(context).unfocus();
                                      } else {
                                        double disc = double.tryParse(
                                            txtDiscountBill.text
                                                .replaceAll(',', ''));

                                        globals.discountBill.number = disc;
                                        globals.discountBill.amount = disc;

                                        FocusScope.of(context).unfocus();
                                      }

                                      calculateSummary();
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
                                child: TextFormField(
                                  readOnly: true,
                                  controller: txtPriceAfterDiscount,
                                  textAlign: TextAlign.right,
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
                                child: Text('???????????? 7%',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  readOnly: true,
                                  controller: txtVatTotal,
                                  textAlign: TextAlign.right,
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
                                child: Text('????????????????????????',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: txtNetTotal,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      //border: OutlineInputBorder()
                                    ),
                                  ),
                                ),
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
                              if (globals.productCart.length == 0) {
                                return globals.showAlertDialog(
                                    '???????????????????????????????????????????????????????????????',
                                    '?????????????????????????????????????????????????????????????????????',
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
                                  // setState(() {});
                                  // await postSaleOrder('D');
                                  // Navigator.pop(context);
                                  TaskEvent event =
                                      await _apiService.postSaleOrder(
                                          'ORDER',
                                          'D',
                                          _docuDate,
                                          _shiptoDate,
                                          _orderDate,
                                          txtCustPONo.text,
                                          txtRemark.text,
                                          priceTotal,
                                          priceAfterDiscount,
                                          vatTotal,
                                          netTotal);

                                  if (event.isComplete) {
                                    txtRemark.text = '';
                                    Navigator.pop(context);
                                    showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return RichAlertDialog(
                                            //uses the custom alert dialog
                                            alertTitle: richTitle(event.title),
                                            alertSubtitle:
                                                richSubtitle(event.message),
                                            alertType: event.eventCode,
                                          );
                                        });

                                    // Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StatusTransferDoc()));
                                  } else {
                                    Navigator.pop(context);
                                    return showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return RichAlertDialog(
                                            //uses the custom alert dialog
                                            alertTitle: richTitle(event.title),
                                            alertSubtitle:
                                                richSubtitle(event.message),
                                            alertType: event.eventCode,
                                          );
                                        });
                                  }

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
                              if (txtDocuNo.text == '') {
                                return globals.showAlertDialog(
                                    '????????????????????????????????????????????????????????????',
                                    '????????????????????????????????????????????????????????????????????????????????????????????????',
                                    context);
                              }

                              if (globals.productCart.length == 0) {
                                return globals.showAlertDialog(
                                    '???????????????????????????????????????????????????????????????',
                                    '?????????????????????????????????????????????????????????????????????',
                                    context);
                              }

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.BOTTOMSLIDE,
                                width: 450,
                                title: 'Confirmation',
                                desc: 'Are you sure to create sale order ?',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  if (this.txtDocuNo.text == '') {}
                                  // setState(() {});
                                  // await postSaleOrder('N');
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             StatusTransferDoc()));
                                  // postSaleOrder().then((value) => setState((){}));

                                  TaskEvent event =
                                      await _apiService.postSaleOrder(
                                          'ORDER',
                                          'N',
                                          _docuDate,
                                          _shiptoDate,
                                          _orderDate,
                                          txtCustPONo.text,
                                          txtRemark.text,
                                          priceTotal,
                                          priceAfterDiscount,
                                          vatTotal,
                                          netTotal);

                                  if (event.isComplete) {
                                    txtRemark.text = '';
                                    Navigator.pop(context);
                                    showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return RichAlertDialog(
                                            //uses the custom alert dialog
                                            alertTitle: richTitle(event.title),
                                            alertSubtitle:
                                                richSubtitle(event.message),
                                            alertType: event.eventCode,
                                          );
                                        });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StatusTransferDoc()));
                                  } else {
                                    Navigator.pop(context);
                                    return showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return RichAlertDialog(
                                            //uses the custom alert dialog
                                            alertTitle: richTitle(event.title),
                                            alertSubtitle:
                                                richSubtitle(event.message),
                                            alertType: event.eventCode,
                                          );
                                        });
                                  }
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
        ));
  }
}
