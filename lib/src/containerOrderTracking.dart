import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ismart_crm/models/customer.dart';
import 'item_order_tracking.dart';
import 'item_header_tracking.dart';
import 'package:ismart_crm/globals.dart' as globals;
import 'package:http/http.dart' as http;

import 'item_product.dart';
import 'item_product_detail.dart';

// Widget _buildMobileLayout() {
//   return ItemListing(
//     // Since we're on mobile, just push a new route for the
//     // item details.
//     itemSelectedCallback: (item) {
//       Navigator.push(/* ... */);
//     },
//   );
// }

class ContainerOrderTracking extends StatefulWidget {
  //const ContainerProduct({ Key key }) : super(key: key);
  const ContainerOrderTracking();

  @override
  _ContainerOrderTrackingState createState() => _ContainerOrderTrackingState();
}

class _ContainerOrderTrackingState extends State<ContainerOrderTracking> {
  static const int kTabletBreakpoint = 400;
  Customer _selectedItem = globals.selectedOrderCustomer;
  List<Customer> allCustomer = globals.allCustomer;
  TextEditingController txtKeyword = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getOrderByCustomer() async {
    var response = await http.get(
        '${globals.publicAddress}/api/product/${globals.company}/${_selectedItem?.custCode}/1');
    Map values = json.decode(response.body);

    setState(() {
      // _goodQty = 1;
      // _goodPrice = double.parse(values['price'].toString());
      // _total = double.parse(values['total'].toString());
      //
      // print('Price / Unit: ' +
      //     _goodPrice.toString() +
      //     ' Total: ' +
      //     values['total'].toString());
    });
  }

  Widget _buildTabletLayout() {
    // For tablets, return a layout that has item listing on the left
    // and item details on the right.
    //setEditingSelected();
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 30,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
            child: Column(children: <Widget>[
              TextFormField(
                controller: txtKeyword,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  hintText: 'ชื่อสินค้า, รหัสสินค้า...',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    String query = txtKeyword.text;
                    setState(() {
                      allCustomer = globals.allCustomer
                          .where((x) =>
                              x.custName.toLowerCase().contains(query) ||
                              x.custCode.toLowerCase().contains(query))
                          .toList();
                    });
                  },
                  //style: ButtonStyle(padding:),
                  icon: Icon(Icons.search),
                  label: Text(
                    'ค้นหาลูกค้า',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              Expanded(
                flex: 5,
                child: ItemOrderTracking(
                  // Instead of pushing a new route here, we update
                  // the currently selected item, which is a part of
                  // our state now.
                  allCustomer: allCustomer,
                  selectedItem: _selectedItem,
                  itemSelectedCallback: (item) {
                    setState(() {
                      _selectedItem = item;
                      //getPrice();
                      // globals.customer = item;
                      print('Item selected: ${item.custName}');
                    });
                  },
                ),
              ),
            ]),
          ),
        ),
        Flexible(
          flex: 4,
          child: ItemHeaderTracking(
            // The item details just blindly accepts whichever
            // item we throw in its way, just like before.
            isInTabletLayout: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    if (shortestSide < kTabletBreakpoint) {
      //content = _buildMobileLayout();
      content = _buildTabletLayout();
    } else {
      content = _buildTabletLayout();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(
            child: Text(
          'รายงาน สถานะเอกสาร',
          style: GoogleFonts.sarabun(fontSize: 20),
        )),
      ),
      body: content,
    );
  }
}
