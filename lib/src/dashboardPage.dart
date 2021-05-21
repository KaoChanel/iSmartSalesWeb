import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:ismart_crm/models/goods_unit.dart';
import 'saleOrder.dart';
import 'containerCustomer.dart';
import 'package:flutter/cupertino.dart';
import 'package:ismart_crm/models/customer.dart';
import 'package:ismart_crm/models/product.dart';
import 'package:ismart_crm/models/shipto.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';
import 'package:ismart_crm/widgets/menuCard.dart';
import 'statusTransferDoc.dart';

Widget _menuCard(String _path) {
  return Card(
    semanticContainer: true,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Image.asset(_path),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 5,
    margin: EdgeInsets.all(10),
  );
}

// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sale CRM',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DashboardPage(),
//     );
//   }
// }

class DashboardPage extends StatefulWidget {
  static const routeName = '/';

  State createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  ApiService _apiService = new ApiService();
  TextEditingController txtCustomer = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await _apiService.getOption();
    await _apiService.getAllCustomer();
    await _apiService.getShipto();
    await _apiService.getProduct();
    await _apiService.getUnit();
    await _apiService.getStock();
    await _apiService.getStockReserve();
  }

  @override
  Widget build(BuildContext context) {

      txtCustomer.text = globals.customer?.custName;
      if(globals.customer != null){
        setState(() {
          txtCustomer.text = globals.customer?.custName;
        });
      }
      // globals.selectedShipto = globals.allShipto?.firstWhere((element) => element.custId == globals.customer?.custId);
      // print(globals.customer?.custId.toString());
      // print(globals.selectedShipto?.shiptoAddr1);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    //Padding(padding: null)
                    // SizedBox(
                    // width: 60,
                    // child: Text('ลูกค้า : ',
                    //       style: TextStyle(fontSize: 18)),
                    // ),
                    Flexible(
                        child: TextFormField(
                      readOnly: true,
                      controller: txtCustomer,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        //labelText: "ลูกค้าของคุณ",
                        hintText: "ลูกค้าของคุณ",
                      ),
                      onTap: () {
                        Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ContainerCustomer()))
                            .then((value) {
                          setState(() {});
                        });
                      },
                    )),
                  ],
                )),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        child: Stack(
                            //height: 200,
                            children: [
                      MenuCard(
                          title: 'ใบเสนอราคา',
                          path: 'assets/business_drawing.jpg'),
                      new Positioned.fill(
                          child: new Material(
                              color: Colors.transparent,
                              child: new InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => null,
                              )))
                    ]))),
                Expanded(
                    child: Container(
                        child: MenuCard(
                            title: 'ตารางงาน',
                            path: 'assets/work_schedule_03.jpg'))),
                Expanded(
                    child: Container(
                        child: Stack(
                            //height: 200,
                            children: [
                      MenuCard(
                          title: 'เข้าเยี่ยม', path: 'assets/shakehand_03.jpg'),
                      new Positioned.fill(
                          child: new Material(
                              color: Colors.transparent,
                              child: new InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => null,
                              )))
                    ]))),
                Expanded(
                    child: Container(
                        child: MenuCard(
                            title: 'บันทึกการเข้าเยี่ยม',
                            path: 'assets/shakehand_01.jpg'))),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      child: Stack(
                          //height: 200,
                          children: [
                        MenuCard(
                            title: 'สั่งสินค้า', path: 'assets/order_01.jpg'),
                        new Positioned.fill(
                            child: new Material(
                                color: Colors.transparent,
                                child: new InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    if (globals.customer == null) {
                                      return showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            new CupertinoAlertDialog(
                                          title: new Text("แจ้งเตือน"),
                                          content: new Text(
                                            "กรุณาเลือกลูกค้าของคุณ",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                                isDefaultAction: true,
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("ปิดหน้าต่าง"))
                                          ],
                                        ),
                                      );
                                    }

                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => SaleOrder())).then((value) => setState((){}));
                                  },
                                )))
                      ])),
                ),
                Expanded(
                  child: Visibility(
                    visible: true,
                    child: Container(
                        child: MenuCard(
                            title: 'แจ้งคืนสินค้า',
                            path: 'assets/goods_return.jpg')),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: true,
                    child: Container(
                        child: Stack(children: [
                      MenuCard(
                        title: 'สถานะเอกสาร',
                        path: 'assets/cloud_02.jpg',
                      ),
                      Positioned.fill(
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              StatusTransferDoc())).then((value) => setState((){}));
                                },
                              )))
                    ])),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: false,
                    child: Container(
                        child: MenuCard(
                            title: 'แบบสอบถาม',
                            path: 'assets/business_support.jpg')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          try {
            globals.showLoaderDialog(context, false);
            await loadData();
            Navigator.pop(context);
          }
          catch (error){
            Navigator.pop(context);
            globals.showAlertDialog('Exception', error.toString(), context);
          }
        },
      ),
    );
  }
}
