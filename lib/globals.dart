library app.globals;
import 'dart:async';

import 'package:flutter/material.dart';

import 'models/companies.dart';
import 'models/employee.dart';
import 'models/customer.dart';
import 'models/product.dart';
import 'models/product_cart.dart';
import 'models/stock.dart';
import 'models/shipto.dart';
import 'models/goods_unit.dart';
import 'models/saleOrder_header.dart';
import 'models/saleOrder_detail.dart';
import 'models/master_remark.dart';
import 'models/discount.dart';
import'package:data_connection_checker/data_connection_checker.dart';

enum DiscountType{ THB, PER }
enum annualCycle{ monthly, quarterly, yearly }

String publicAddress = 'https://smartsalesbis.com';
String company;
List<Company> allCompany;
bool enableEditPrice = false;
Employee employee;
Customer customer;
Customer selectedOrderCustomer;
List<Customer> allCustomer;
List<Shipto> allShipto;
Product selectedProduct;
List<Product> allProduct;
Stock selectedStock;
List<Stock> groupStock;
List<Stock> allStock;
MasterRemark selectedRemark = MasterRemark();
MasterRemark selectedRemarkDraft = MasterRemark();
MasterRemark selectedRemarkDuplicate = MasterRemark();
List<MasterRemark> allRemark = List<MasterRemark>();
ProductCart editingProductCart;
List<GoodsUnit> allGoodsUnit = new List<GoodsUnit>();
double newPrice;
List<SaleOrderHeader> tempSOHD = new List<SaleOrderHeader>();
StreamSubscription<DataConnectionStatus> listener;
DiscountType discountType = DiscountType.THB;
/// Sale Order
bool isDraftInitial = false;
bool isCopyInitial = false;
List<ProductCart> productCart = new List<ProductCart>();
List<ProductCart> productCartDraft = new List<ProductCart>();
List<ProductCart> productCartCopy = List<ProductCart>();
Shipto selectedShipto;
Shipto selectedShiptoDraft;
Shipto selectedShiptoCopy;
Discount discountBill = Discount(number: 0, amount: 0, type: 'THB');
Discount discountBillCopy = Discount(number: 0, amount: 0, type: 'THB');
Discount discountBillDraft = Discount(number: 0, amount: 0, type: 'THB');
bool isMainData = false;
annualCycle selectedCycle = annualCycle.monthly;
String docKeyword = '';
int docTypeKeyword;
String docTransferKeyword;
bool isLockPrice;

void clearOrder(){
  productCart = new List<ProductCart>();
  editingProductCart = null;
  selectedProduct = null;
  discountBill = Discount(number: 0, amount: 0, type: 'THB');
}

void clearDraftOrder(){
  productCartDraft = new List<ProductCart>();
  editingProductCart = null;
  selectedProduct = null;
  discountBillDraft = Discount(number: 0, amount: 0, type: 'THB');
}

void clearCopyOrder(){
  productCartCopy = new List<ProductCart>();
  editingProductCart = null;
  selectedProduct = null;
  discountBillCopy = Discount(number: 0, amount: 0, type: 'THB');
}

Future<DataConnectionStatus> checkConnection(BuildContext context) async{
  var internetStatus = "Unknown";
  var contentMessage = "Unknown";
  listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status){
      // case DataConnectionStatus.connected:
      //   internetStatus = "Connected to the Internet";
      //   contentMessage = "Connected to the Internet";
      //   showAlertDialog(internetStatus, contentMessage, context);
      //   break;
      case DataConnectionStatus.disconnected:
        internetStatus = "You are disconnected to the Internet. ";
        contentMessage = "Please check your internet connection";
        showAlertDialog(internetStatus, contentMessage, context);
        break;
    }
  });
  return await DataConnectionChecker().connectionStatus;
}

void showAlertDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Close"))
            ]
        );
      }
  );
}

showLoaderDialog(BuildContext context){
  var alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7),
            child:Text("  Loading ..." )
        ),
      ],),
  );

  showDialog(
    barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

