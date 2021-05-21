library app.globals;
import 'dart:async';

import 'package:flutter/cupertino.dart';
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
import 'models/option.dart';
import 'models/stock_reserve.dart';
import 'models/vat.dart';

enum DiscountType{ THB, PER }
enum annualCycle{ monthly, quarterly, yearly }

String publicAddress = 'https://smartsalesbis.com';
Option options = Option();
Vat vatGroup = Vat();
String company = '';
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
List<StockReserve> allStockReserve = <StockReserve>[];
List<MasterRemark> allRemark = <MasterRemark>[];
ProductCart editingProductCart;
List<GoodsUnit> allGoodsUnit = <GoodsUnit>[];
double newPrice = 0;
double goodsQuantity = 0;
List<SaleOrderHeader> tempSOHD = <SaleOrderHeader>[];
StreamSubscription<DataConnectionStatus> listener;
DiscountType discountType = DiscountType.THB;

/// Sale Order
bool isDraftInitial = false;
bool isCopyInitial = false;
List<ProductCart> productCart = <ProductCart>[];
List<ProductCart> productCartDraft = <ProductCart>[];
List<ProductCart> productCartCopy = <ProductCart>[];
Shipto selectedShipto;
Shipto selectedShiptoDraft;
Shipto selectedShiptoCopy;
Discount discountBill = Discount(number: 0, amount: 0, type: 'THB');
Discount discountBillCopy = Discount(number: 0, amount: 0, type: 'THB');
Discount discountBillDraft = Discount(number: 0, amount: 0, type: 'THB');
MasterRemark selectedRemark = MasterRemark();
MasterRemark selectedRemarkDraft = MasterRemark();
MasterRemark selectedRemarkCopy = MasterRemark();
bool isMainData = false;
annualCycle selectedCycle = annualCycle.monthly;
String docKeyword = '';
int docTypeKeyword = 0;
String docTransferKeyword = '';
bool isLockPrice = false;

void clearOrder() {
  productCart = <ProductCart>[];
  editingProductCart = null;
  selectedProduct = null;
  // selectedShipto = null;
  selectedRemark = MasterRemark();
  discountBill = Discount(number: 0, amount: 0, type: 'THB');
}

void clearDraftOrder(){
  productCartDraft = <ProductCart>[];
  editingProductCart = null;
  selectedProduct = null;
  // selectedShiptoDraft = null;
  selectedRemarkDraft = MasterRemark();
  discountBillDraft = Discount(number: 0, amount: 0, type: 'THB');
}

void clearCopyOrder(){
  productCartCopy = <ProductCart>[];
  editingProductCart = null;
  selectedProduct = null;
  // selectedShiptoCopy = null;
  selectedRemarkCopy = MasterRemark();
  discountBillCopy = Discount(number: 0, amount: 0, type: 'THB');
}

double vatInclude(double summary, double vatBase) {
  double vatTotal = (summary / 1.07) * 0.07;
  return vatBase + vatTotal;
}

double vatExclude(double summary, double vatBase) {
  double vatTotal = vatBase * 0.07;
  return vatBase + vatTotal;
}

Future<DataConnectionStatus> checkConnection(BuildContext context) async {
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
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ]
        );
      }
  );
}

showLoaderDialog(BuildContext context, bool dismiss){
  var alert = AlertDialog(
    content: Container(
      height: 120,
      child: Column(
        children: [
          SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 7.0,
              )),
          Container(
              // margin: EdgeInsets.only(left: 7),
            padding: EdgeInsets.only(top: 25.0),
              child:Text("กำลังโหลด ...", style: TextStyle(fontSize: 18.0),)
          ),
        ],),
    ),
  );

  showDialog(
    barrierDismissible: dismiss,
    context:context,
    builder:(BuildContext context){
      if(dismiss == false){
        return WillPopScope(
            child: alert,
            onWillPop: () async => false);
      }
      else {
        return alert;
      }
    },
  );
}

