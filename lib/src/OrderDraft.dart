import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ismart_crm/api_service.dart';
import 'package:ismart_crm/models/customer.dart';
import 'package:ismart_crm/models/discount.dart';
import 'package:ismart_crm/models/product_cart.dart';
import 'package:ismart_crm/models/saleOrder_header.dart';
import 'package:ismart_crm/models/saleOrder_detail.dart';
import 'package:ismart_crm/models/saleOrder_header_remark.dart';
import 'package:ismart_crm/models/saleOrder_detail_remark.dart';
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/models/shipto.dart';
import 'package:ismart_crm/src/statusTransferDoc.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'containerProduct.dart';

class OrderDraft extends StatefulWidget {
  OrderDraft({@required this.header});

  final SaleOrderHeader header;

  @override
  _OrderDraftState createState() => _OrderDraftState();
}

class _OrderDraftState extends State<OrderDraft> {
  @override
  Widget build(BuildContext context) {
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
                          'หัวบิล การสั่งสินค้า',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                            // _docuDate = await showDatePicker(
                            //   context: context,
                            //   initialDate: _docuDate != null
                            //       ? _docuDate
                            //       : DateTime.now(),
                            //   firstDate: DateTime.now().add(Duration(days: -90)),
                            //   lastDate: DateTime.now().add(Duration(days: 365)),
                            // );
                            //
                            // setState(() {
                            //   if (_docuDate == null) _docuDate = DateTime.now();
                            //   txtDocuDate.text = DateFormat('dd/MM/yyyy').format(_docuDate);
                            // });
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
                              if (_shiptoDate == null)
                                _shiptoDate =
                                    DateTime.now().add(new Duration(hours: 24));

                              txtShiptoDate.text =
                                  DateFormat('dd/MM/yyyy').format(_shiptoDate);
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
                              if (_orderDate == null) _orderDate = DateTime.now();
                              txtOrderDate.text = DateFormat('dd/MM/yyyy').format(_orderDate);
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                                  globals.selectedShipto = globals.allShipto
                                      .firstWhere((element) =>
                                          element.custId ==
                                              globals.customer.custId &&
                                          element.isDefault == 'Y');
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContainerProduct(
                                                    'สั่งรายการสินค้า ลำดับที่ ',
                                                    null,
                                                    'DRAFT'))).then((value) {
                                      globals.editingProductCart = null;
                                      setState(() {calculateSummary();});
                                    });
                                  },
                                  icon: Icon(Icons.add_circle_outline_outlined,
                                      color: Colors.white),
                                  color: Colors.green,
                                  splashColor: Colors.green,
                                  padding: EdgeInsets.all(10),
                                  label: Text(
                                    'เพิ่มรายการสินค้า',
                                    style: TextStyle(
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
                                                      'สั่งรายการสินค้า ลำดับที่ ',
                                                      null,
                                                      'DRAFT')));
                                    },
                                    icon: Icon(Icons.local_fire_department,
                                        color: Colors.white),
                                    color: Colors.deepOrange[400],
                                    padding: EdgeInsets.all(10),
                                    label: Text(
                                      'เพิ่มรายการด่วน',
                                      style: TextStyle(
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
                                                      'สั่งรายการสินค้า ลำดับที่ ',
                                                      null,
                                                      'DRAFT')));
                                    },
                                    icon: Icon(Icons.list, color: Colors.white),
                                    color: Colors.blueAccent,
                                    padding: EdgeInsets.all(10),
                                    label: Text(
                                      'เพิ่มรายการโปรโมชั่น',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Expanded(
                      child: getOrderDetails(),
                    )
                  ]),
                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: EdgeInsets.only(top: 11),
                        padding: EdgeInsets.all(10),
                        width: 350,
                        child: Text(
                          'ท้ายบิล การสั่งสินค้า',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                          Flexible(
                              child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.right,
                            controller: txtDiscountTotal,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              //border: OutlineInputBorder()
                            ),
                          )),
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
                                        if (globals.discountBillDraft.type ==
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
                                                .discountBillDraft.type ==
                                            'PER') {
                                          globals.discountBillDraft.number =
                                              double.tryParse(txtDiscountBill
                                                  .text
                                                  .replaceAll(',', ''));
                                          FocusScope.of(context).unfocus();
                                          calculateSummary();
                                        } else if (globals
                                                .discountBillDraft.type ==
                                            'THB') {
                                          double disc = double.tryParse(
                                              txtDiscountBill.text
                                                  .replaceAll(',', ''));
                                          //globals.discountBillDraft.discountNumber = globals.discountBillDraft.discountAmount;
                                          globals.discountBillDraft.number =
                                              disc;
                                          globals.discountBillDraft.amount =
                                              disc;
                                          FocusScope.of(context).unfocus();
                                          calculateSummary();
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
                                          textAlign: TextAlign.right,
                                          controller: txtPriceAfterDiscount,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 0),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            //border: OutlineInputBorder()
                                          ),
                                        )))
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
                                          textAlign: TextAlign.right,
                                          controller: txtVatTotal,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 0),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            //border: OutlineInputBorder()
                                          ),
                                        )))
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
                                        textAlign: TextAlign.right,
                                        controller: txtNetTotal,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          //border: OutlineInputBorder()
                                        ),
                                      )),
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
                              onPressed: () {
                                if (globals.productCartDraft.length == 0) {
                                  return globals.showAlertDialog(
                                      'โปรดเพิ่มรายการสินค้า',
                                      'คุณยังไม่มีรายการสินค้า',
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
                                    await saveOrder('D');
                                    Navigator.pop(context);
                                    Navigator.pop(context);
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
                                  width: 400,
                                  title: 'Confirmation',
                                  desc: 'Are you sure to create sales order ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    // setState(() {});
                                    await saveOrder('N');
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
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
  ApiService _apiService = new ApiService();
  DateTime _docuDate = DateTime.now();
  DateTime _shiptoDate = DateTime.now().add(Duration(hours: 24));
  DateTime _orderDate = DateTime.now();

  List<ProductCart> productCart = <ProductCart>[];
  SaleOrderHeader SOHD = SaleOrderHeader();
  List<SaleOrderDetail> SODT = <SaleOrderDetail>[];
  SoHeaderRemark headerRemark = SoHeaderRemark();
  List<SoDetailRemark> detailRemark = <SoDetailRemark>[];

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

    globals.discountBillDraft = Discount(number: 0, amount: 0, type: 'THB');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      globals.showLoaderDialog(context, false);
      setCustomer();
      initShipto();
      setHeader();
      await setDetails();
      await setRemark();
      Navigator.pop(context);
    });
    
    calculateSummary();
  }

  setCustomer() {
    globals.customer = globals.allCustomer
        .firstWhere((e) => e.custId == widget.header.custId, orElse: null);
    globals.selectedShipto = globals.allShipto?.firstWhere(
            (e) => e.custId == widget.header.custId && e.shiptoCode == widget.header.shipToCode,
        orElse: () => null);

    globals.selectedShiptoDraft = globals.selectedShipto;
  }

  initShipto() {
    txtShiptoProvince.text = widget.header.province ?? '';
    txtShiptoAddress.text = '${widget.header.shipToAddr1 ?? ''} '
        '${widget.header.shipToAddr2 ?? ''} '
        '${widget.header.district ?? ''} '
        '${widget.header.amphur ?? ''} '
        '${widget.header.province ?? ''} '
        '${widget.header.postCode ?? ''}';
    txtShiptoRemark.text = widget.header.remark ?? '';
  }

  setShipto() {
    txtShiptoProvince.text = globals.selectedShiptoDraft?.province ?? '';
    txtShiptoAddress.text = '${globals.selectedShiptoDraft?.shiptoAddr1 ?? ''} '
        '${globals.selectedShiptoDraft?.shiptoAddr2 ?? ''} '
        '${globals.selectedShiptoDraft?.district ?? ''} '
        '${globals.selectedShiptoDraft?.amphur ?? ''} '
        '${globals.selectedShiptoDraft?.province ?? ''} '
        '${globals.selectedShiptoDraft?.postcode ?? ''}';
    txtShiptoRemark.text = globals.selectedShiptoDraft?.remark ?? '';
  }

  setHeader() {
    SOHD = widget.header;

    runningNo = SOHD.docuNo ?? '';
    refNo = SOHD.refNo ?? '';
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
        '';
    txtStatus.text = creditState == 'H'
        ? 'Holding'
        : creditState == 'I'
            ? 'Inactive'
            : 'ปกติ';

    globals.discountBillDraft.type = 'THB';
    globals.discountBillDraft.number = discountBill;
    globals.discountBillDraft.amount = discountBill;

    // txtPriceTotal.text = currency.format(SOHD.sumGoodAmnt);
    // txtDiscountBill.text = currency.format(discountBill);
    // txtPriceAfterDiscount.text = currency.format(SOHD.billAftrDiscAmnt);
    // txtVatTotal.text = currency.format(vatTotal);
    // txtNetTotal.text = currency.format(SOHD.netAmnt);
  }

  setDetails() async {
    SODT = await _apiService.getSODT(widget.header.soid);
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
        ..beforeDiscountAmount = x.afterMarkupamnt
        ..goodAmount = x.goodAmnt
        ..goodQty = x.goodQty2
        ..goodPrice = x.goodPrice2
        ..discount = x.goodDiscAmnt
        ..discountType =
            x.goodDiscFormula != null && x.goodDiscAmnt < 100 ? 'PER' : 'THB'
        ..discountBase = x.goodDiscAmnt
        ..mainGoodUnitId = x.goodUnitId2
        ..vatRate = x.vatrate
        ..vatType = x.vatType
        ..lotFlag = x.lotFlag
        ..expireFlag = x.expireflag
        ..serialFlag = x.serialFlag
        ..isFree = x.goodPrice2 == 0 ? true : false;
      // ..remark = detailRemark.firstWhere((element) => element.soId == x.soid && element.refListNo == x.listNo).remark;
      print('Cart >>>>>>>>>>>>>>> ${cart.discountType}');
      globals.productCartDraft.add(cart);
    });

    setState(() {
      calculateSummary();
    });

    // globals.productCartDraft
    //     .where((element) => element.soid == SOHD.soid)
    //     .forEach((element) {
    //   discountTotal += element.discountBase ?? 0;
    // });

    // globals.productCartDraft.forEach((element) {
    //   priceTotal += element.goodAmount;
    // });
    //
  }

  setRemark() async {
    headerRemark = await _apiService.getHeaderRemark(SOHD.soid);
    detailRemark = await _apiService.getDetailRemark(SOHD.soid);
    txtRemark.text = headerRemark.remark ?? '';

    globals.productCartDraft.forEach((element) {
      element.remark = detailRemark
              .firstWhere(
                  (x) =>
                      x.soId == widget.header.soid &&
                      x.listNo == element.rowIndex,
                  orElse: () => null)
              .remark ??
          '';
    });
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
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0,)));
                },
                child: Text('ไม่ต้องการ'),
              ),
              TextButton(
                onPressed: () async {
                  await saveOrder('D');
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0,)));
                },
                /*Navigator.of(context).pop(true)*/
                child: Text('บันทึก'),
              ),
            ],
          ),
        ) ??
        false;
  }

  getShiptoList(BuildContext context) {
    List<Shipto> shiptoList = globals.allShipto
        .where((element) => element.custId == widget.header.custId)
        .toList();

    List<Widget> list = new List<Widget>();
    for (var i = 0; i < shiptoList?.length; i++) {
      list.add(ListTile(
        title: Text(
            '${shiptoList[i]?.shiptoAddr1 ?? ''} ${shiptoList[i]?.district ?? ''} ${shiptoList[i]?.amphur ?? ''} ${shiptoList[i]?.province ?? ''} ${shiptoList[i]?.postcode ?? ''}'),
        //subtitle: Text(item?.custCode),
        onTap: () {
          // widget.header.shipToAddr1 = shiptoList[i].shiptoAddr1;
          // widget.header.shipToAddr2 = shiptoList[i].shiptoAddr2;
          // widget.header.district = shiptoList[i].district;
          // widget.header.amphur = shiptoList[i].amphur;
          // widget.header.province = shiptoList[i].province;
          // widget.header.postCode = shiptoList[i].postcode;
          globals.selectedShiptoDraft = shiptoList[i];
          Navigator.pop(context);
          setState(() {
            setShipto();
            calculateSummary();
          });
        },
        selected: globals.selectedShiptoDraft.shiptoAddr1 == shiptoList[i]?.shiptoAddr1 ?? '',
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
                width: 500, height: 300, child: getShiptoList(context)));
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

  setDiscountType() {
    if (globals.discountBillDraft.type == 'THB') {
      return Text('THB');
    } else {
      return Text('%');
    }
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
                        globals.discountBillDraft.type = 'THB';
                        Navigator.pop(context);
                        setState(() {
                          calculateSummary();
                        });
                      },
                      selected: globals.discountBillDraft.type == 'THB',
                      selectedTileColor: Colors.black12,
                      title: Text('THB')),
                  ListTile(
                    onTap: () {
                      //discountType = globals.DiscountType.PER;
                      globals.discountBillDraft.type = 'PER';
                      Navigator.pop(context);
                      setState(() {
                        calculateSummary();
                      });
                    },
                    selected: globals.discountBillDraft.type == 'PER',
                    selectedTileColor: Colors.black12,
                    title: Text('%'),
                  )
                ])));
      },
    );
  }

  Widget getOrderDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          showBottomBorder: true,
          columnSpacing: 25,
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
                  // onSortColumn(columnIndex, ascending);
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
              label: Center(
                child: Text(
                  'ชื่อสินค้า',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                ),
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
          rows: globals.productCartDraft
              .toList()
              .map((e) => DataRow(cells: [
                    DataCell(Center(child: Text('${e.rowIndex}'))),
                    DataCell(
                        Text('${e.isFree ?? false ? 'แถมฟรี' : 'เพื่อขาย'}')),
                    DataCell(Text('${e.goodCode}')),
                    DataCell(Text('${e.goodName1}')),
                    DataCell(Text('${currency.format(e.goodQty ?? 0)}')),
                    DataCell(Text('${currency.format(e.goodPrice ?? 0)}')),
                    DataCell(Text('${currency.format(e.discountBase ?? 0)}')),
                    DataCell(Text('${currency.format(e.goodAmount ?? 0)}')),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContainerProduct(
                                        'แก้ไขรายการสินค้า ลำดับที่ ',
                                        e,
                                        'DRAFT'))).then((value) {
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
                            globals.productCartDraft.removeWhere(
                                (element) => element.rowIndex == e.rowIndex);
                            globals.productCartDraft.forEach((element) {
                              element.rowIndex = index++;
                            });
                            //globals.editingProductCart = null;
                            //globals.productCartDraft = List<ProductCart>();
                            print(globals.productCartDraft.length.toString());

                            // priceTotal = 0;
                            // globals.productCartDraft.forEach((element) {
                            //   priceTotal += element.goodAmount;
                            // });
                            //
                            // ctrl_priceTotal.add(priceTotal);

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
              ?.toList()),
    );
  }

  calculateSummary() {
    try {
      if (globals.productCartDraft.length != 0) {
        priceTotal = 0;
        discountTotal = 0;

        globals.productCartDraft.forEach((element) {
          priceTotal += element.goodAmount;
        });

        globals.productCartDraft.forEach((element) {
          discountTotal += element.discountBase;
        });
      } else {
        priceTotal = 0;
        discountTotal = 0;
        priceAfterDiscount = 0;
        globals.discountBillDraft = Discount(number: 0, amount: 0, type: 'THB');
        vatTotal = 0;
        netTotal = 0;
      }

      discountBill = globals.discountBillDraft.number;
      //priceTotal = priceTotal - discountTotal;
      if (globals.discountBillDraft.type == 'PER') {
        double percentDiscount = globals.discountBillDraft.number / 100;
        globals.discountBillDraft.amount = (percentDiscount * priceTotal);
        priceAfterDiscount = priceTotal - globals.discountBillDraft.amount;
      } else {
        globals.discountBillDraft.amount = discountBill;
        priceAfterDiscount = priceTotal - globals.discountBillDraft.amount;
      }

      double sumGoodsHasVat = 0;
      double sumGoodsHasNoVat = 0;

      if (globals.productCartDraft.length != 0) {
        globals.productCartDraft
            .where((x) => x.vatRate != null ? x.vatRate > 0 : false)
            .toList()
            .forEach((element) => sumGoodsHasVat += element.goodAmount);
        globals.productCartDraft
            .where((x) => x.vatRate != null ? x.vatRate == 0 : false)
            .toList()
            .forEach((element) => sumGoodsHasNoVat += element.goodAmount);
      }

      sumGoodsHasVat = sumGoodsHasVat - globals.discountBillDraft.amount;
      print('sumGoodsHasVat : $sumGoodsHasVat');
      print('sumGoodsHasNoVat : $sumGoodsHasNoVat');
      double vatBase = 0;
      print(globals.vatGroup.vatgroupCode);
      if (globals.vatGroup.vatgroupCode == 'IN7') {
        vatBase = sumGoodsHasVat / 1.07;
        vatTotal = vatBase * 0.07;
        netTotal = vatBase + vatTotal + sumGoodsHasNoVat;
      } else if (globals.vatGroup.vatgroupCode == 'EX7') {
        vatBase = sumGoodsHasVat;
        vatTotal = vatBase * 0.07;
        netTotal = vatBase + vatTotal + sumGoodsHasNoVat;
      } else {
        netTotal = priceAfterDiscount;
      }

      setState(() {
        txtPriceTotal.text = currency.format(priceTotal);
        txtDiscountTotal.text = currency.format(discountTotal);

        txtDiscountBill.text = currency.format(discountBill);
        txtPriceAfterDiscount.text = currency.format(priceAfterDiscount);
        txtVatTotal.text = currency.format(vatTotal);
        txtNetTotal.text = currency.format(netTotal);
      });
    } catch (e) {
      showDialog(
          builder: (context) => AlertDialog(
                title: Text('Calculating Exception'),
                content: Text(e.toString()),
              ),
          context: context);
    }
  }

  Future<dynamic> saveOrder(String status) async {
    try {
      globals.showLoaderDialog(context, false);
      SaleOrderHeader header = new SaleOrderHeader();
      List<SaleOrderDetail> detail = <SaleOrderDetail>[];
      runningNo = '';
      // refNo =
      //     '${globals.company}${globals.employee?.empCode}-${runningNo ?? ''}';
      refNo = SOHD.refNo;
      docuNo = SOHD.docuNo;

      /// Company Info
      header.brchId = globals.options.brchId;

      /// Default filled.
      header.validDays = 0;
      header.onHold = 'N';
      header.goodType = '1';
      header.docuType = 104;
      header.docuStatus = 'N';
      header.postdocutype = 1702;
      header.exchRate = 1;
      header.sumIncludeAmnt = 0;
      header.sumExcludeAmnt = 0;
      header.commissionAmnt = 0;
      header.clearSo = 'N';
      header.miscChargAmnt = 0;
      header.multiCurrency = 'N';
      header.resvAmnt1 = 0;
      header.resvAmnt2 = 0;
      header.resvAmnt3 = 0;
      header.resvAmnt4 = 0;
      header.quotStatus = 'รอผู้ใหญ่ตัดสินใจ';
      header.appvFlag = 'W';
      header.pkgStatus = 'N';
      header.refeflag = 'N';
      header.alertFlag = 'N';
      header.clearflag = 'N';

      /// document header.
      header.soid = SOHD.soid;
      header.saleAreaId = globals.customer.saleAreaId;
      header.docuNo = docuNo;
      header.refNo = refNo;
      header.docuDate = _docuDate;
      header.shipDate = _shiptoDate;
      header.custPodate = _orderDate;
      header.custPono = txtCustPONo.text;
      header.isTransfer = status;

      /// employee information.
      header.empId = globals.employee.empId;
      header.deptId = globals.employee.deptId;

      /// customer information.
      header.custId = globals.customer.custId;
      header.custName = globals.customer.custName;
      header.creditDays = globals.customer.creditDays;

      /// shipment to customer.
      header.shipToCode = globals.selectedShiptoDraft.shiptoCode;
      header.transpId = globals.selectedShiptoDraft.transpId;
      header.transpAreaId = globals.selectedShiptoDraft.transpAreaId;
      header.shipToAddr1 = globals.selectedShiptoDraft.shiptoAddr1;
      header.shipToAddr2 = globals.selectedShiptoDraft.shiptoAddr2;
      header.district = globals.selectedShiptoDraft.district;
      header.amphur = globals.selectedShiptoDraft.amphur;
      header.province = globals.selectedShiptoDraft.province;
      header.postCode = globals.selectedShiptoDraft.postcode;
      header.remark = globals.selectedShiptoDraft.remark;

      /// VAT Info
      header.vatgroupId = globals.vatGroup.vatgroupId;
      header.vatRate = globals.vatGroup.vatRate;
      header.vatType = globals.vatGroup.vatType;
      header.vatamnt = vatTotal;

      /// Discount
      header.billDiscFormula = globals.discountBillDraft.type == 'PER' ? '${globals.discountBillDraft.number.toInt().toString()}%' : currency.format(globals.discountBillDraft.amount);
      header.billDiscAmnt = globals.discountBillDraft.amount;

      /// Cost Summary.
      header.sumGoodAmnt = priceTotal;
      header.billAftrDiscAmnt = priceAfterDiscount;
      header.netAmnt = netTotal;

      globals.productCartDraft.forEach((e) {
        SaleOrderDetail obj = new SaleOrderDetail();
        obj.soid = header.soid;
        obj.listNo = e.rowIndex;
        obj.docuType = 104;
        obj.goodId = e.goodId;
        obj.goodName = e.goodName1;
        obj.goodStockUnitId = e.mainGoodUnitId;
        obj.goodUnitId2 = e.mainGoodUnitId;
        obj.goodQty2 = e.goodQty;
        obj.poqty = e.goodQty;
        obj.remaQty = e.goodQty;
        obj.remaQtyPkg = e.goodQty;
        obj.goodStockQty = e.goodQty;
        obj.goodRemaQty1 = e.goodQty;
        obj.remaGoodStockQty = e.goodQty;
        obj.goodPrice2 = e.goodPrice;
        obj.goodAmnt = e.goodAmount;
        obj.remaamnt = e.goodAmount;
        obj.afterMarkupamnt = e.beforeDiscountAmount;
        obj.goodDiscAmnt = e.discountBase;
        obj.goodsRemark = e.remark;
        obj.isTransfer = status;

        /// Stock Information
        obj.lotFlag = e.lotFlag;
        obj.expireflag = e.expireFlag;
        obj.serialFlag = e.serialFlag;

        /// Vat Goods
        obj.vatgroupId = e.vatGroupId;
        obj.vatType = e.vatType;
        obj.vatrate = e.vatRate;

        /// Default Field
        obj.goodQty1 = 0.00;
        obj.goodPrice1 = 0.00;
        obj.goodCompareQty = 0;
        obj.goodCost = 0;
        obj.goodStockRate1 = 0;
        obj.goodStockRate2 = 0;
        obj.miscChargAmnt = 0;
        obj.remaBefoQty = 0;
        obj.goodType = '1';
        obj.stockFlag = -1;
        obj.goodFlag = 'G';
        obj.freeFlag = 'N';
        obj.reserveQty = 0;
        obj.resvAmnt1 = 0;
        obj.resvAmnt2 = 0;
        obj.goodRemaQty2 = 0;
        obj.poststock = 'N';
        obj.markUpAmnt = 0;
        obj.commisAmnt = 0;

        detail.add(obj);
      });

      if (await _apiService.saveDraft(header, detail)) {
        SoHeaderRemark headerRemark = SoHeaderRemark()
          ..soId = header.soid
          ..listNo = 1
          ..remark = txtRemark.text
          ..isTransfer = status;

        if (await _apiService.updateSOHDRemark(headerRemark)) {
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

          if (await _apiService.updateSODTRemark(dtRemarkAll)) {
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
                    actions: [],
                  );
                });
          }
        }
      } else {
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                //uses the custom alert dialog
                alertTitle:
                    richTitle("An error occurred while saving a draft."),
                alertSubtitle: richSubtitle(
                    "Something was wrong while saving method on API."),
                alertType: RichAlertType.ERROR,
              );
            });
      }
    } catch (e) {
      return showAboutDialog(
          context: context,
          applicationName: 'Post Sale Order Exception',
          applicationIcon: Icon(Icons.error_outline),
          children: [
            Text(e.toString()),
          ]);
    }
  }
}
