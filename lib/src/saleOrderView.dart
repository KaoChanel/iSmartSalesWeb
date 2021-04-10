import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ismart_crm/models/discount.dart';
import 'package:ismart_crm/models/product_cart.dart';
import 'package:ismart_crm/models/shipto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ismart_crm/src/saleOrderCopy.dart';
import 'package:ismart_crm/src/saleOrderDraft.dart';
import 'containerProduct.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';
import 'package:ismart_crm/models/saleOrder_header.dart';
import 'package:ismart_crm/models/saleOrder_detail.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SaleOrderView extends StatefulWidget {
  SaleOrderView({@required this.saleOrderHD});

  final SaleOrderHeader saleOrderHD;

  @override
  _SaleOrderViewState createState() => _SaleOrderViewState();
}

class _SaleOrderViewState extends State<SaleOrderView> {
  ApiService _apiService = ApiService();
  SaleOrderHeader SOHD = SaleOrderHeader();
  List<SaleOrderDetail> SODT = List<SaleOrderDetail>();
  Shipto selectedShipTo = Shipto();
  final currency = NumberFormat("#,##0.00", "en_US");
  String runningNo;
  String docuNo;
  String refNo;
  double vat = 0.7;
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  DateTime _docuDate;
  DateTime _shiptoDate;
  DateTime _orderDate;
  bool isInitial = false;
  bool editedDocuDate = false;
  bool editedShipDate = false;

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtSONo;
  TextEditingController txtDeptCode;
  TextEditingController txtCopyDocuNo;
  TextEditingController txtEmpCode = TextEditingController();
  TextEditingController txtEmpName = TextEditingController();
  TextEditingController txtCustCode = TextEditingController();
  TextEditingController txtCustName = TextEditingController();
  TextEditingController txtCustRemark = TextEditingController();
  TextEditingController txtCreditType = TextEditingController();
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

  TextEditingController txtDocuDate = TextEditingController();
  TextEditingController txtShiptoDate = TextEditingController();
  TextEditingController txtOrderDate = TextEditingController();

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
  }

  void setHeader() async {
    SOHD = widget.saleOrderHD;
    SODT = await _apiService.getSODT(SOHD.soid);
    runningNo = SOHD.docuNo ?? '';
    refNo = SOHD.refNo ?? '';
    // _docuDate = editedDocuDate == false ? SOHD.docuDate : _docuDate;
    // _shiptoDate = editedShipDate == false ? SOHD.shipDate : _shiptoDate;
    _docuDate = SOHD.docuDate;
    _shiptoDate = SOHD.shipDate;
    _orderDate = SOHD.custPodate;
    discountBill = SOHD.billDiscAmnt;

    txtRunningNo.text = runningNo;
    txtRefNo.text = refNo;
    txtDocuNo.text = SOHD.docuNo;
    txtDocuDate.text = DateFormat('dd/MM/yyyy').format(_docuDate);
    txtShiptoDate.text = _shiptoDate != null ? DateFormat('dd/MM/yyyy').format(_shiptoDate) : '';
    txtShiptoRemark.text = '';
    txtOrderDate.text = _orderDate != null ? DateFormat('dd/MM/yyyy').format(_orderDate) : '';
    txtEmpCode.text = '${globals.employee?.empCode}';
    txtCustCode.text = globals.allCustomer
            ?.firstWhere(
                (element) => element.custId == SOHD.custId)
            ?.custCode ??
        '';
    txtCustName.text = SOHD.custName ?? '';
    txtCredit.text = SOHD.creditDays.toString() ?? '0';
    txtRemark.text = SOHD.remark ?? '';
    double DiscountTotal = 0;
    SODT.where((element) => element.soid == SOHD.soid).forEach((element) {DiscountTotal += element.goodDiscAmnt;});
    txtDiscountTotal.text = currency.format(DiscountTotal);
    txtPriceTotal.text = currency.format(SOHD.sumGoodAmnt);
    txtDiscountBill.text = currency.format(SOHD.billDiscAmnt);
    txtPriceAfterDiscount.text = currency.format(SOHD.billAftrDiscAmnt);
    txtVatTotal.text = currency.format(SOHD.vatamnt ?? 0);
    txtNetTotal.text = currency.format(SOHD.netAmnt);
  }

  void setSelectedShipto() {
    setState(() {
      selectedShipTo.shiptoAddr1 = widget.saleOrderHD?.shipToAddr1 ?? '';
      selectedShipTo.shiptoAddr2 = widget.saleOrderHD?.shipToAddr2 ?? '';
      selectedShipTo.district = widget.saleOrderHD?.district ?? '';
      selectedShipTo.amphur = widget.saleOrderHD?.amphur ?? '';
      selectedShipTo.province = widget.saleOrderHD?.province ?? '';
      selectedShipTo.postcode = widget.saleOrderHD?.postCode ?? '';
      selectedShipTo.remark = widget.saleOrderHD?.remark ?? '';
      selectedShipTo.shiptoAddr1 = widget.saleOrderHD?.shipToAddr1 ?? '';

      txtShiptoAddress.text = '${widget.saleOrderHD?.shipToAddr1 ?? ''} '
          '${widget.saleOrderHD.shipToAddr2 ?? ''} '
          '${widget.saleOrderHD.district ?? ''} '
          '${widget.saleOrderHD.amphur ?? ''} '
          '${widget.saleOrderHD.province ?? ''} '
          '${widget.saleOrderHD.postCode ?? ''}';
      txtShiptoProvince.text = widget.saleOrderHD.province ?? '';
      txtShiptoRemark.text = widget.saleOrderHD.remark ?? '';
    });
  }

  Widget getShiptoListWidgets(BuildContext context) {
    List<Shipto> shiptoList = globals.allShipto
            .where((element) => element.custId == widget.saleOrderHD.custId)
            ?.toList() ??
        [];
    print(shiptoList[0].shiptoAddr1);
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < shiptoList.length; i++) {
      list.add(ListTile(
        title: Text(
            '${shiptoList[i].shiptoAddr1 ?? ''} ${shiptoList[i]?.district ?? ''} ${shiptoList[i]?.amphur ?? ''} ${shiptoList[i]?.province ?? ''} ${shiptoList[i]?.postcode ?? ''}'),
        //subtitle: Text(item?.custCode),
        onTap: () {
          selectedShipTo = shiptoList[i];
          Navigator.pop(context);
          setState(() {});
        },
        selected: selectedShipTo?.shiptoAddr1 == shiptoList[i].shiptoAddr1 ?? '',
        selectedTileColor: Colors.grey[200],
        hoverColor: Colors.grey,
      ));
    }
    return ListView(children: list);
  }

  Widget SaleOrderDetails() {
    return FutureBuilder(
        future: _apiService.getSODT(SOHD.soid),
        builder: (BuildContext context, AsyncSnapshot<Object> snapShot) {
          if (snapShot.hasData) {
            if (isInitial == false) {
              SODT = snapShot.data;
              isInitial = true;
            }
          }
          return DataTable(
            showBottomBorder: true,
            columnSpacing: 26,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'ลำดับ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                ),
              ),
              // DataColumn(
              //   label: Text(
              //     'ประเภท',
              //     style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              //   ),
              // ),
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
              // DataColumn(
              //   label: Text(
              //     '',
              //     style: TextStyle(fontStyle: FontStyle.italic),
              //   ),
              // ),
              // DataColumn(
              //   label: Text(
              //     '',
              //     style: TextStyle(fontStyle: FontStyle.italic),
              //   ),
              // ),
            ],
            rows: SODT
                    .asMap()
                    .map((i, e) => MapEntry(
                        i,
                        DataRow(cells: [
                          DataCell(Text('${i + 1}')),
                          // DataCell(Text(
                          //     '${globals.allProduct.firstWhere((element) => element.goodId == e.goodId).goodTypeFlag}')),
                          DataCell(Text(
                              '${globals.allProduct.firstWhere((element) => element.goodId == e.goodId).goodCode}')),
                          DataCell(Text(
                              '${globals.allProduct.firstWhere((element) => element.goodId == e.goodId).goodName1}')),
                          DataCell(Text('${currency.format(e.goodQty2)}')),
                          DataCell(Text('${currency.format(e.goodPrice2)}')),
                          DataCell(
                              Text('${currency.format(e.goodDiscAmnt)}')),
                          DataCell(Text('${currency.format(e.goodAmnt)}')),
                        ])))
                    .values
                    .toList() ??
                <DataRow>[
                  DataRow(cells: [
                    // DataCell(Text('-')),
                    DataCell(Text('-')),
                    DataCell(Text('-')),
                    DataCell(Text('-')),
                    DataCell(Text('-')),
                    DataCell(Text('-')),
                    DataCell(Text('-')),
                    DataCell(Text('')),
                    // DataCell(Text('')),
                    //DataCell(Text('ยังไม่มีรายการคำสั่ง')),
                  ])
                ]);
        });
  }

  Widget build(BuildContext context) {
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        readOnly: true,
                        initialValue: globals.employee?.empName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        readOnly: true,
                        controller: txtCustCode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        readOnly: true,
                        controller: txtCustName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        //initialValue: globals.customer,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        controller: txtCustRemark,
                        //initialValue: globals.customer?.,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                              labelText: "สถานที่ส่งจริง",
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
                  Flexible(
                    flex: 6,
                    child: ListTile(
                      title: TextFormField(
                        readOnly: true,
                        controller: txtShiptoRemark,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "หมายเหตุ",
                        ),
                      ),
                    ),
                  ),
                  // Flexible(
                  //     flex: 1,
                  //     child: Container(
                  //       height: 47,
                  //       padding: EdgeInsets.only(right: 10),
                  //       child: ElevatedButton.icon(
                  //           onPressed: () {
                  //             //_showShiptoDialog(context);
                  //             _showDialog(context);
                  //           },
                  //           icon: Icon(Icons.airport_shuttle),
                  //           label: Text('สถานที่ส่ง')),
                  //     )),
                  // Flexible(
                  //     flex: 1,
                  //     child: SizedBox(
                  //       height: 47,
                  //       child: ElevatedButton.icon(
                  //           onPressed: () {
                  //             setState(() {
                  //               selectedShipTo = globals.allShipto.firstWhere(
                  //                   (element) =>
                  //                       element.custId ==
                  //                           widget.saleOrderHD?.custId &&
                  //                       element.isDefault == 'Y');
                  //             });
                  //             Fluttertoast.showToast(
                  //                 msg: "ใช้ค่าเริ่มต้นเรียบร้อย",
                  //                 toastLength: Toast.LENGTH_SHORT,
                  //                 gravity: ToastGravity.BOTTOM,
                  //                 timeInSecForIosWeb: 1,
                  //                 backgroundColor: Colors.black54,
                  //                 textColor: Colors.white,
                  //                 fontSize: 18.0);
                  //           },
                  //           icon: Icon(Icons.refresh),
                  //           label: Text('ค่าเริ่มต้น')),
                  //     )),
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
                  ],
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:
                      SaleOrderDetails(),),
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
                      child: Visibility(
                        visible: false,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add_comment),
                          label: Text(
                            'ข้อความหมายเหตุ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    //Expanded(child: SizedBox()),
                    //Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.shortestSide < 400 ? 0 : 410,
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
                        Flexible(
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
                          child: Text('รวมเงิน',
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
                            readOnly: true,
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: "หมายเหตุ",
                              //border: OutlineInputBorder()
                            ),
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
                                width: 195,
                                child: Text('ส่วนลดท้ายบิล',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 8.0),
                              //   child: ElevatedButton(
                              //       onPressed: () {
                              //         showDiscountTypeDialog();
                              //         //focusDiscount.requestFocus();
                              //       },
                              //       child: setDiscountType()),
                              // ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  readOnly: true,
                                  controller: txtDiscountBill,
                                  focusNode: focusDiscount,
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
                                child: Text('ยอดก่อนรวมภาษี',
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
                                child: Text('ภาษี 7%',
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
                                child: Text('รวมสุทธิ',
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

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                            ),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.BOTTOMSLIDE,
                                width: 450,
                                title: 'Duplicate Order ?',
                                desc: 'Are you sure to duplicate sales order ?',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  globals.discountBillCopy = Discount(number: 0, amount: 0, type: 'THB');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SaleOrderCopy(header:widget.saleOrderHD, detail:SODT)));
                                },
                              )..show();
                              //print(jsonEncode(globals.productCart));
                            },
                            child: Text(
                              'ทำรายการคำสั่งซ้ำ',
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    )
                  ],
                ),
                // SizedBox(height: 30,)
              ],
            )
          ]),
        ));
  }
}
