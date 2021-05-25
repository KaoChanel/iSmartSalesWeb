import 'dart:convert';

// Import the client from the Http Packages
import 'package:intl/intl.dart';
import 'package:ismart_crm/models/discount.dart';
import 'package:ismart_crm/models/employee.dart';
import 'package:ismart_crm/models/saleOrder_detail_remark.dart';
import 'package:ismart_crm/models/saleOrder_header_remark.dart';
import 'package:ismart_crm/models/sales_daily.dart';
import 'package:ismart_crm/models/sales_monthly.dart';
import 'package:ismart_crm/models/stock_reserve.dart';

import 'models/companies.dart';
import 'models/customer.dart';
import 'models/option.dart';
import 'models/product.dart';
import 'models/goods_unit.dart';
import 'models/product_cart.dart';
import 'models/sales.dart';
import 'models/shipto.dart';
import 'models/saleOrder_header.dart';
import 'models/saleOrder_detail.dart';
import 'models/master_remark.dart';
import 'models/stock.dart';
import 'package:ismart_crm/src/saleOrder.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' show Client;

import 'models/vat.dart';
import 'models/task_event.dart';

class ApiService {
  // Replace this with your computer's IP Address
  final String baseUrl = "https://smartsalesbis.com/api";
  Client client = Client();

  Future<void> getCompany() async {
    String strUrl = '${globals.publicAddress}/api/company/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));
      if (response.statusCode == 200) {
        globals.allCompany = companyFromJson(response.body);
      } else {
        globals.allCompany = null;
      }
  }

  Future<void> getAllCustomer() async {
    String strUrl =
        '${globals.publicAddress}/api/customers/${globals.company}/${globals.employee.empId}/${globals.employee.empHead}';
    var response = await client.get(Uri.parse(strUrl));
      if (response.statusCode == 200) {
        globals.allCustomer = customerFromJson(response.body);
      } else {
        globals.allCustomer = null;
      }
  }

  Future<List<Customer>> getCustomerList() async {
    String strUrl =
        '${globals.publicAddress}/api/customers/${globals.company}/${globals.employee.empId}';
    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
      return customerFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Customer> getCustomer(int empId, int custId) async {
    String strUrl =
        '${globals.publicAddress}/api/customers/${globals.company}/$empId';
    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
      print('response.statusCode == 200');
      if(response.body != '[]'){
        return customerFromJson(response.body).firstWhere((element) => element.custId == custId, orElse: null) ?? null;
      }
      else{
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> getProduct() async {
    String strUrl;

    strUrl = '${globals.publicAddress}/api/product/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));

    if (response.statusCode == 200) {
      globals.allProduct = productFromJson(response.body);
    } else {
      globals.allProduct = null;
    }
  }

  Future<bool> updateEmployee(Employee data) async {
    String strUrl = "$baseUrl/Employees/${globals.company}/${data.empId}";
    final response = await client.put(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "PUT, OPTIONS"
      },
      body: json.encode(data.toJson()),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // Future<void> getRemark() async {
  //   String strUrl = '${globals.publicAddress}/api/SaleOrderHeader/GetTbmRemark/${globals.company}';
  //   var response = await client.get(strUrl);
  //
  //   if (response.statusCode == 200) {
  //     globals.allRemark = masterRemarkFromJson(response.body);
  //   } else {
  //     globals.allRemark = null;
  //   }
  // }

  Future<List<MasterRemark>> getRemark() async {
    String strUrl = '${globals.publicAddress}/api/SaleOrderHeader/GetTbmRemark/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));

    if (response.statusCode == 200) {
      //globals.allRemark = masterRemarkFromJson(response.body);
      return masterRemarkFromJson(response.body);
    } else {
      //globals.allRemark = null;
      return null;
    }
  }

  Future<double> getPrice(int custId, String goodCode, double quantity) async {
    String strUrl = '${globals.publicAddress}/api/product/${globals.company}/$custId/$goodCode/$quantity';
    var response = await client.get(Uri.parse(strUrl));
    Map values = json.decode(response.body);

    return double.parse(values['price'].toString());
  }

  Future<void> getUnit() async {
    String strUrl;

    strUrl = '${globals.publicAddress}/api/goodsunit/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));

    if (response.statusCode == 200) {
      globals.allGoodsUnit = goodsUnitFromJson(response.body);
    } else {
      globals.allGoodsUnit = null;
    }
  }

  Future<void> getStock() async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/stock/${globals.company}';

    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
        globals.allStock = stockFromJson(response.body);
    } else {
      globals.allStock = null;
    }
  }

  Future<void> getStockReserve() async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/stock/GetStockReserve/${globals.company}';

    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
        globals.allStockReserve = stockReserveFromJson(response.body);
    } else {
        globals.allStockReserve = null;
    }
  }

  Future<void> getShipto() async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/shipto/${globals.company}';
    final response = await client.get(Uri.parse(strUrl));

    if (response.statusCode == 200) {
      globals.allShipto = shiptoFromJson(response.body);
    } else {
      globals.allShipto = null;
    }
  }

  Future<Shipto> getShiptoByCustomer(int custId) async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/shipto/${globals.company}';
    final response = await client.get(Uri.parse(strUrl));

    if (response.statusCode == 200) {
      return shiptoFromJson(response.body).firstWhere((element) => element.custId == custId, orElse: null);
    } else {
      return null;
    }
  }

  Future<List<SaleOrderHeader>> getSOHD() async {
    String strUrl = "${globals.publicAddress}/api/SaleOrderHeader/${globals.company}";
    final response =
        await client.get(Uri.parse(strUrl));
    var data = saleOrderHeaderFromJson(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      return null;
    }
  }

  Future<List<SaleOrderHeader>> getSOHDByEmp(int id) async {
    String strUrl = '${globals.publicAddress}/api/SaleOrderHeader/GetTempSohdByEmp/${globals.company}/$id';
    final response = await client.get(Uri.parse(strUrl));
      if (response.statusCode == 200) {
        List<SaleOrderHeader> data = saleOrderHeaderFromJson(response.body);
        return data;
      } else {
        return null;
      }
  }

  Future<List<SaleOrderDetail>> getSODT(int soId) async {
    //'${globals.publicAddress}/api/SaleOrderDetail/GetTempSodtByEmp/${globals.company}/$id'
    String strUrl = '${globals.publicAddress}/api/SaleOrderDetail/${globals.company}/$soId';
    final response = await client.get(Uri.parse(strUrl));

      if (response.statusCode == 200) {
        var data = saleOrderDetailFromJson(response.body);
        return data;
      } else {
        return null;
      }
  }

  // Future<String> getDocNo() async {
  //   String strUrl =
  //       '${globals.publicAddress}/api/SaleOrderHeader/GenerateDocNo/${globals.company}';
  //   var response = await client.get(strUrl);
  //   print(response.statusCode);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     return '';
  //   }
  // }

  Future<String> getDocNo() async {
    String strUrl =
        '${globals.publicAddress}/api/SaleOrderHeader/GenerateDocNo/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }

  Future<String> getRefNo() async {
    String strUrl =
        '${globals.publicAddress}/api/SaleOrderHeader/GenerateRefNo/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }

  getOption() async {
    String strUrl =
        '${globals.publicAddress}/api/Option/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));
    print('getOption Status Code: ${response.statusCode}');
    print('getOption Body: ${response.body}');
    if (response.statusCode == 200) {
      globals.options = optionFromJson(response.body).first;
      await getVat();
    } else {
      globals.options = null;
    }
  }

  getVat() async {
    String strUrl =
        '${globals.publicAddress}/api/Option/GetVat/${globals.company}';
    var response = await client.get(Uri.parse(strUrl));
    print('Vat Status Code: ${response.statusCode}');
    print('Vat Body: ${response.body}');
    if (response.statusCode == 200) {
      globals.vatGroup = vatFromJson(response.body).firstWhere((e) => e.vatgroupId == globals.options.vatgroupId);
    } else {
      globals.vatGroup = null;
    }
  }

  Future<SoHeaderRemark> getHeaderRemark(int soId) async {
    String strUrl =
        '${globals.publicAddress}/api/SoHeaderRemark/${globals.company}/$soId';
    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
      return soHeaderRemarkFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<SoDetailRemark>> getDetailRemark(int soId) async {
    String strUrl =
        '${globals.publicAddress}/api/SoDetailRemarks/${globals.company}/$soId';
    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
      return soDetailRemarkFromJson(response.body);
    } else {
      return null;
    }
  }

  getSales() async {
    String strUrl =
        '${globals.publicAddress}/api/getsales/${globals.company}/${globals.employee.empId}';
    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
      return salesFromJson(response.body);
    } else {
      return null;
    }
  }

  getSalesDaily() async {
    String strUrl =
        '${globals.publicAddress}/api/getsales/getsalesdaily/${globals.company}/${globals.employee.empId}';
    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
      return salesDailyFromJson(response.body);
    } else {
      return null;
    }
  }

  getSalesMonthly() async {
    String strUrl =
        '${globals.publicAddress}/api/getsales/getsalesmonthly/${globals.company}/${globals.employee.empId}';
    var response = await client.get(Uri.parse(strUrl));
    if (response.statusCode == 200) {
      return salesMonthlyFromJson(response.body);
    } else {
      return null;
    }
  }

  // Create a new sohd
  Future<SaleOrderHeader> addSaleOrderHeader(SaleOrderHeader data) async {
    String strUrl = "$baseUrl/SaleOrderHeader/${globals.company}/";
    final response = await client.post(Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: json.encode(data.toJson()),
    );

    print('Add Sale Header Status Code: ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 201) {
      return SaleOrderHeader.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> addSaleOrderDetail(List<SaleOrderDetail> data) async {
    String strUrl = "$baseUrl/SaleOrderDetail/${globals.company}/";
    final response = await client.post(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: saleOrderDetailToJson(data),
    );

    print('Status Code: ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addSOHeaderRemark(SoHeaderRemark data) async {
    String strUrl = "$baseUrl/SoHeaderRemark/${globals.company}/";
    final response = await client.post(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: soHeaderRemarkToJson(data),
    );

    print('Status Code: ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addSODetailRemark(List<SoDetailRemark> data) async {
    String strUrl = "$baseUrl/SoDetailRemarks/${globals.company}/";
    final response = await client.post(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: soDetailRemarkToJson(data),
    );

    print('Status Code: ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateSaleOrderHeader(SaleOrderHeader data) async {
    String strUrl = "$baseUrl/SaleOrderHeader/${globals.company}/${data.soid}";
    final response = await client.put(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "PUT, OPTIONS"
      },
      body: json.encode(data.toJson()),
    );

    print('Status Code: ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateSaleOrderDetail(List<SaleOrderDetail> data) async {
    String strUrl = "$baseUrl/SaleOrderDetail/${globals.company}";
    final response = await client.post(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: saleOrderDetailToJson(data),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateSOHDRemark(SoHeaderRemark data) async {
    String strUrl = "$baseUrl/SoHeaderRemark/${globals.company}";
    final response = await client.put(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "PUT, OPTIONS"
      },
      body: soHeaderRemarkToJson(data),
    );

    print('Status Code: ${response.statusCode}');
    print(response.headers);
    print(soHeaderRemarkToJson(data));

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateSODTRemark(List<SoDetailRemark> data) async {
    // final response = await client.put(
    //   "$baseUrl/SoDetailRemarks/${globals.company}/",
    //   headers: {
    //     "content-type": "application/json",
    //     "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    //     "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
    //     "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    //     "Access-Control-Allow-Methods": "PUT, OPTIONS"
    //   },
    //   body: soDetailRemarkToJson(data),
    // );
    // if (response.statusCode == 204) {
    //   return true;
    // } else {
    //   return false;
    // }

    String strUrl = "$baseUrl/SoDetailRemarks/${globals.company}/${data.first.soId}";
      final response = await client.delete(
        Uri.parse(strUrl),
        headers: {
          "content-type": "application/json",
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "DELETE, OPTIONS"
        },
      );

      print('SODT Remark Delete: Status Code: ${response.statusCode} | $baseUrl/SoDetailRemarks/${globals.company}/${data.first.soId}');
      print(response.headers);

      if (response.statusCode == 204 || response.statusCode == 404) {
       final response = await client.post(
          Uri.parse("$baseUrl/SoDetailRemarks/${globals.company}"),
          headers: {
            "content-type": "application/json",
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
          },
          body: soDetailRemarkToJson(data),
        );

       print('Status Code: ${response.statusCode}');
       print(response.headers);
       print(soDetailRemarkToJson(data));

        if (response.statusCode == 201) {
          return true;
        }
      }
      return false;
  }

  Future<TaskEvent> postSaleOrder(
      String fromPage,
      String status,
      DateTime docDate,
      DateTime shipDate,
      DateTime orderDate,
      String custPO,
      String remark,
      double totalAmount,
      double afterDiscountAmount,
      double vatAmount,
      double netAmount) async {

    try {
      final currency = NumberFormat("#,##0.00", "en_US");
      TaskEvent event = TaskEvent();
      SaleOrderHeader header = SaleOrderHeader();
      List<SaleOrderDetail> detail = <SaleOrderDetail>[];
      List<ProductCart> detailCart = fromPage == 'ORDER' ? globals.productCart : fromPage == 'COPY' ? globals.productCartCopy : globals.productCartDraft;
      Shipto shipment = fromPage == 'ORDER' ? globals.selectedShipto : fromPage == 'COPY' ? globals.selectedShiptoCopy : globals.selectedShiptoDraft;
      Discount discount = fromPage == 'ORDER' ? globals.discountBill : fromPage == 'COPY' ? globals.discountBillCopy : globals.discountBillDraft;

      String docuNo = await getDocNo();
      String runningNo = await getRefNo();
      String refNo =
      '${globals.company}${globals.employee?.empCode}-${runningNo ?? ''}';
      // DateTime createTime = status == 'N' ? DateTime.now() : null;

      /// Company Info
      header.brchId = globals.options.brchId;

      /// Default filled.
      header.validDays = 0;
      header.onHold = 'N';
      header.goodType = '1';
      header.docuType = 104;
      header.docuStatus = 'N';
      // header.postdocutype = 1702;
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
      header.soid = 0;
      header.saleAreaId = globals.customer.saleAreaId;
      header.docuNo = docuNo;
      header.refNo = refNo;
      header.docuDate = docDate;
      header.shipDate = shipDate;

      /// VAT Info
      header.vatgroupId = globals.vatGroup.vatgroupId;
      header.vatRate = globals.vatGroup.vatRate;
      header.vatType = globals.vatGroup.vatType;
      header.vatamnt = vatAmount;

      /// employee information.
      header.empId = globals.employee.empId;
      header.deptId = globals.employee.deptId;

      /// customer information.
      header.custId = globals.customer.custId;
      header.custName = globals.customer.custName ?? '';
      header.contactName = globals.customer.custName ?? '';
      header.creditDays = globals.customer.creditDays ?? 0;
      header.custPodate = orderDate;
      header.custPono = custPO;

      /// Cost Summary.
      header.sumGoodAmnt = totalAmount;
      header.totaBaseAmnt = afterDiscountAmount;
      header.netAmnt = netAmount;

      /// Discount
      header.billDiscFormula = discount.type == 'PER' ? '${discount.number.toInt().toString()}%' : currency.format(discount.amount);
      header.billDiscAmnt = discount.amount;
      header.billAftrDiscAmnt = afterDiscountAmount;

      /// shipment to customer.
      header.contactnameShip = shipment.contName ?? '';
      header.shipToCode = shipment.shiptoCode ?? '';
      header.transpId = shipment.transpId;
      header.transpAreaId = shipment.transpAreaId;
      header.shipToAddr1 = shipment.shiptoAddr1 ?? '';
      header.shipToAddr2 = shipment.shiptoAddr2 ?? '';
      header.district = shipment.district ?? '';
      header.amphur = shipment.amphur ?? '';
      header.province = shipment.province ?? '';
      header.postCode = shipment.postcode ?? '';
      header.tel = shipment.tel ?? '';
      header.condition = shipment.condition ?? '';
      header.remark = shipment.remark ?? '';
      header.isTransfer = status;
      if(status == 'N'){
        header.createTime = DateTime.now();
      }
      // header.createTime = createTime;

      header = await addSaleOrderHeader(header);
      print('Add result: ${header.soid}');
      if (header != null) {

        detailCart.forEach((e) {
          SaleOrderDetail obj = SaleOrderDetail();
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
          // obj.goodDiscType = e.discountType;
          obj.goodDiscFormula = e.discountType == 'PER' ? '${e.discount.toInt().toString()}%' : currency.format(e.discountBase);
          obj.goodDiscAmnt = e.discountBase;
          obj.goodsRemark = e.remark;
          obj.shipDate = shipDate;
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
          obj.sumExcludeAmnt = 0;

          detail.add(obj);
        });

        if (await addSaleOrderDetail(detail) == true) {
          // var hdRemark = SoHeaderRemark()..soId = header.soid..listNo = 1..remark = txtRemark.text;
          SoHeaderRemark headerRemark = SoHeaderRemark()
            ..soId = header.soid
            ..listNo = 1
            ..remark = remark
            ..isTransfer = status;

          if (await addSOHeaderRemark(headerRemark)) {
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

            if (await addSODetailRemark(dtRemarkAll)) {
              if(fromPage == 'ORDER'){
                globals.clearOrder();
              }
              else{
                globals.clearCopyOrder();
              }

              event.isComplete = true;
              event.eventCode = 1;
              event.title = status == 'N' ? 'Transaction Successfully.' : 'Your draft has saved.';
              event.message = 'Your order has created.';

              print('Task Event: ' + event.title);
              return event;
            }
            else {
              event.isComplete = false;
              event.title = 'Remark details has failed.';
              event.message = 'Something was wrong while creating remark detail.';
              event.eventCode = 0;
            }
          }
          else {
            event.isComplete = false;
            event.title = 'Remark header has failed.';
            event.message = 'Something was wrong while creating remark header.';
            event.eventCode = 0;
          }

          // globals.clearOrder();
          // print('Order Successful.');
        } else {
          event.isComplete = false;
          event.title = 'Sales Order details has failed.';
          event.message = 'Something was wrong while creating Sale order details.';
          event.eventCode = 0;

          // Navigator.pop(context);
          // return showDialog<void>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return RichAlertDialog(
          //         //uses the custom alert dialog
          //         alertTitle: richTitle("Details of Sales Order was failed."),
          //         alertSubtitle: richSubtitle(
          //             "Something was wrong while creating SO Details."),
          //         alertType: RichAlertType.ERROR,
          //       );
          //     });
        }
      }
      else {
        event.isComplete = false;
        event.eventCode = 0;
        event.title = 'Sale order header has failed.';
        event.message = 'Something was wrong while creating sale order header.';
        // Navigator.pop(context);
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return RichAlertDialog(
        //         //uses the custom alert dialog
        //         alertTitle: richTitle("Header of Sales Order was failed."),
        //         alertSubtitle: richSubtitle(
        //             "Something was wrong while creating SO Header."),
        //         alertType: RichAlertType.ERROR,
        //       );
        //     });
      }
    } catch (e) {
      return TaskEvent()..isComplete = false..eventCode = 0..title = 'Post order Exception'..message = e.toString();
      // Navigator.pop(context);
      // return showAboutDialog(
      //     context: context,
      //     applicationName: 'Post Sale Order Exception',
      //     applicationIcon: Icon(Icons.error_outline),
      //     children: [
      //       Text(e.toString()),
      //     ]);
    }
  }

  Future<bool> saveDraft(SaleOrderHeader header, List<SaleOrderDetail> data) async {
    try {
      var response = await client.put(
        Uri.parse("$baseUrl/SaleOrderHeader/${globals.company}/${header.soid}"),
        headers: {
          "content-type": "application/json",
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "PUT, OPTIONS"
        },
        body: json.encode(header.toJson()),
      );

      print('Update Header Status Code: ${response.statusCode}');
      print(response.headers);
      print(response.body);

      if (response.statusCode == 204) {
        response = await client.delete(
          Uri.parse("$baseUrl/SaleOrderDetail/${globals.company}/${header.soid}"),
          headers: {
            "content-type": "application/json",
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "DELETE, OPTIONS"
          },
        );

        if (response.statusCode == 204 || response.statusCode == 404) {
          response = await client.post(
            Uri.parse("$baseUrl/SaleOrderDetail/${globals.company}/"),
            headers: {
              "content-type": "application/json",
              "Access-Control-Allow-Origin": "*", // Required for CORS support to work
              "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
              "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
              "Access-Control-Allow-Methods": "POST, OPTIONS"
            },
            body: saleOrderDetailToJson(data),
          );

          print('Insert Detail Status Code: ${response.statusCode}');
          print(response.headers);
          print(response.body);

          if (response.statusCode == 201) {
            return true;
          }
        }
      }
      return false;
    }
    catch(e){
      print('Save Draft Exception: ' + e.toString());
      return false;
    }
  }

// Delete a sohd
  Future<bool> deleteSaleOrderHeader(int Id) async {
    String strUrl = "$baseUrl/SaleOrderHeader/$Id";
    final response = await client.delete(
      Uri.parse(strUrl),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

// Get list of all Todo Statuses
//   Future<List<String>> getStatuses() async {
//     final response = await client.get("$baseUrl/Config");
//     if (response.statusCode == 200) {
//       var data = (jsonDecode(response.body) as List<dynamic>).cast<String>();
//       return data;
//     } else {
//       return null;
//     }
//   }
}
