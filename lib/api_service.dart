import 'dart:convert';

// Import the client from the Http Packages
import 'package:ismart_crm/models/employee.dart';
import 'package:ismart_crm/models/saleOrder_detail_remark.dart';
import 'package:ismart_crm/models/saleOrder_header_remark.dart';
import 'package:ismart_crm/models/stock_reserve.dart';

import 'models/companies.dart';
import 'models/customer.dart';
import 'models/option.dart';
import 'models/product.dart';
import 'models/goods_unit.dart';
import 'models/shipto.dart';
import 'models/saleOrder_header.dart';
import 'models/saleOrder_detail.dart';
import 'models/master_remark.dart';
import 'models/stock.dart';
import 'package:ismart_crm/src/saleOrder.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' show Client;

import 'models/vat.dart';

class ApiService {
  // Replace this with your computer's IP Address
  final String baseUrl = "https://smartsalesbis.com/api";
  Client client = Client();

  Future<void> getCompany() async {
    String strUrl = '${globals.publicAddress}/api/company/${globals.company}';
    var response = await client.get(strUrl);
      if (response.statusCode == 200) {
        globals.allCompany = companyFromJson(response.body);
      } else {
        globals.allCompany = null;
      }
  }

  Future<void> getAllCustomer() async {
    String strUrl =
        '${globals.publicAddress}/api/customers/${globals.company}/${globals.employee.empId}/${globals.employee.empHead}';
    var response = await client.get(strUrl);
      if (response.statusCode == 200) {
        globals.allCustomer = customerFromJson(response.body);
      } else {
        globals.allCustomer = null;
      }
  }

  Future<List<Customer>> getCustomerList() async {
    String strUrl =
        '${globals.publicAddress}/api/customers/${globals.company}/${globals.employee.empId}';
    var response = await client.get(strUrl);
    if (response.statusCode == 200) {
      return customerFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Customer> getCustomer(int empId, int custId) async {
    String strUrl =
        '${globals.publicAddress}/api/customers/${globals.company}/$empId';
    var response = await client.get(strUrl);
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
    var response = await client.get(strUrl);

    if (response.statusCode == 200) {
      globals.allProduct = productFromJson(response.body);
    } else {
      globals.allProduct = null;
    }
  }

  Future<bool> updateEmployee(Employee data) async {
    final response = await client.put(
      "$baseUrl/Employees/${globals.company}/${data.empId}",
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
    var response = await client.get(strUrl);

    if (response.statusCode == 200) {
      //globals.allRemark = masterRemarkFromJson(response.body);
      return masterRemarkFromJson(response.body);
    } else {
      //globals.allRemark = null;
      return null;
    }
  }

  Future<double> getPrice(int custId, String goodCode, double quantity) async {
    var response = await client.get(
        '${globals.publicAddress}/api/product/${globals.company}/$custId/$goodCode/$quantity');
    Map values = json.decode(response.body);

    return double.parse(values['price'].toString());
  }

  Future<void> getUnit() async {
    String strUrl;

    strUrl = '${globals.publicAddress}/api/goodsunit/${globals.company}';
    var response = await client.get(strUrl);

    if (response.statusCode == 200) {
      globals.allGoodsUnit = goodsUnitFromJson(response.body);
    } else {
      globals.allGoodsUnit = null;
    }
  }

  Future<void> getStock() async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/stock/${globals.company}';

    var response = await client.get(strUrl);
    if (response.statusCode == 200) {
        globals.allStock = stockFromJson(response.body);
    } else {
      globals.allStock = null;
    }
  }

  Future<void> getStockReserve() async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/stock/GetStockReserve/${globals.company}';

    var response = await client.get(strUrl);
    if (response.statusCode == 200) {
        globals.allStockReserve = stockReserveFromJson(response.body);
    } else {
        globals.allStockReserve = null;
    }
  }

  Future<void> getShipto() async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/shipto/${globals.company}';
    final response = await client.get(strUrl);

    if (response.statusCode == 200) {
      globals.allShipto = shiptoFromJson(response.body);
    } else {
      globals.allShipto = null;
    }
  }

  Future<Shipto> getShiptoByCustomer(int custId) async {
    String strUrl;
    strUrl = '${globals.publicAddress}/api/shipto/${globals.company}';
    final response = await client.get(strUrl);

    if (response.statusCode == 200) {
      return shiptoFromJson(response.body).firstWhere((element) => element.custId == custId, orElse: null);
    } else {
      return null;
    }
  }

  Future<List<SaleOrderHeader>> getSOHD() async {
    final response =
        await client.get("${globals.publicAddress}/api/SaleOrderHeader/${globals.company}");
    var data = saleOrderHeaderFromJson(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      return null;
    }
  }

  Future<List<SaleOrderHeader>> getSOHDByEmp(int id) async {
    final response = await client.get('${globals.publicAddress}/api/SaleOrderHeader/GetTempSohdByEmp/${globals.company}/$id');
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
    final response = await client.get(strUrl);

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
    var response = await client.get(strUrl);
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
    var response = await client.get(strUrl);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }

  Future<Option> getOption() async {
    String strUrl =
        '${globals.publicAddress}/api/Option/${globals.company}';
    var response = await client.get(strUrl);
    if (response.statusCode == 200) {
      globals.options = optionFromJson(response.body).first;
      await getVat();
    } else {
      globals.options = null;
    }
  }

  Future<List<Vat>> getVat() async {
    String strUrl =
        '${globals.publicAddress}/api/Option/GetVat/${globals.company}';
    var response = await client.get(strUrl);
    if (response.statusCode == 200) {
      globals.vatGroup = vatFromJson(response.body).firstWhere((e) => e.vatgroupId == globals.options.vatgroupId);
    } else {
      globals.vatGroup = null;
    }
  }

  Future<SoHeaderRemark> getHeaderRemark(int soId) async {
    String strUrl =
        '${globals.publicAddress}/api/SoHeaderRemark/${globals.company}/$soId';
    var response = await client.get(strUrl);
    if (response.statusCode == 200) {
      return soHeaderRemarkFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<SoDetailRemark>> getDetailRemark(int soId) async {
    String strUrl =
        '${globals.publicAddress}/api/SoDetailRemarks/${globals.company}/$soId';
    var response = await client.get(strUrl);
    if (response.statusCode == 200) {
      return soDetailRemarkFromJson(response.body);
    } else {
      return null;
    }
  }

  // Create a new sohd
  Future<SaleOrderHeader> addSaleOrderHeader(SaleOrderHeader data) async {
    final response = await client.post(
      "$baseUrl/SaleOrderHeader/${globals.company}/",
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: json.encode(data.toJson()),
    );

    print('Status Code: ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 201) {
      return SaleOrderHeader.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> addSaleOrderDetail(List<SaleOrderDetail> data) async {
    final response = await client.post(
      "$baseUrl/SaleOrderDetail/${globals.company}/",
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
    final response = await client.post(
      "$baseUrl/SoHeaderRemark/${globals.company}/",
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
    final response = await client.post(
      "$baseUrl/SoDetailRemarks/${globals.company}/",
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
    final response = await client.put(
      "$baseUrl/SaleOrderHeader/${globals.company}/${data.soid}",
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
    final response = await client.post(
      "$baseUrl/SaleOrderDetail/${globals.company}",
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
    final response = await client.put(
      "$baseUrl/SoHeaderRemark/${globals.company}",
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
    final response = await client.put(
      "$baseUrl/SoDetailRemarks/${globals.company}/",
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "PUT, OPTIONS"
      },
      body: soDetailRemarkToJson(data),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveDraft(SaleOrderHeader header, List<SaleOrderDetail> data) async {
    try {
      var response = await client.put(
        "$baseUrl/SaleOrderHeader/${globals.company}/${header.soid}",
        headers: {
          "content-type": "application/json",
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "PUT, OPTIONS"
        },
        body: json.encode(header.toJson()),
      );

      print('Status Code: ${response.statusCode}');
      print(response.headers);
      print(response.body);

      if (response.statusCode == 204) {
        response = await client.delete(
          "$baseUrl/SaleOrderDetail/${globals.company}/${header.soid}",
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
            "$baseUrl/SaleOrderDetail/${globals.company}/",
            headers: {
              "content-type": "application/json",
              "Access-Control-Allow-Origin": "*", // Required for CORS support to work
              "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
              "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
              "Access-Control-Allow-Methods": "POST, OPTIONS"
            },
            body: saleOrderDetailToJson(data),
          );

          if (response.statusCode == 201) {
            return true;
          }
        }
      }
      return false;
    }
    catch(e){
      print('Exception: ' + e);
    }
  }

// Delete a sohd
  Future<bool> deleteSaleOrderHeader(int Id) async {
    final response = await client.delete(
      "$baseUrl/SaleOrderHeader/$Id",
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

// Get list of all Todo Statuses
  Future<List<String>> getStatuses() async {
    final response = await client.get("$baseUrl/Config");
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body) as List<dynamic>).cast<String>();
      return data;
    } else {
      return null;
    }
  }
}
