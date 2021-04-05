import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:google_fonts/google_fonts.dart';
import 'item_stock.dart';
import 'item_stock_detail.dart';
import 'package:ismart_crm/models/stock.dart';
import 'package:ismart_crm/globals.dart' as globals;
import 'package:http/http.dart' as http;

// Widget _buildMobileLayout() {
//   return ItemListing(
//     // Since we're on mobile, just push a new route for the
//     // item details.
//     itemSelectedCallback: (item) {
//       Navigator.push(/* ... */);
//     },
//   );
// }

class ContainerStock extends StatefulWidget {
  //const ContainerProduct({ Key key }) : super(key: key);
  const ContainerStock();

  @override
  _ContainerStockState createState() => _ContainerStockState();
}

class _ContainerStockState extends State<ContainerStock> {
  static const int kTabletBreakpoint = 400;
  Stock _selectedItem = globals.selectedStock;
  var tempStock = globals.allStock.toList();
  List<Stock> allStock = new List<Stock>();
  TextEditingController txtKeyword = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    allStock = tempStock.toList();
    print('Globals Length: ' + globals.allStock.length.toString());
    final ids = allStock.map((e) => e.goodid).toSet();
    allStock.retainWhere((x) => ids.remove(x.goodid));
    allStock.forEach((element) => element.orderNumber = 1);
    print('initial Stock');
    print('Globals Length: ' + globals.allStock.length.toString());
    print('Remove Length: ' + allStock.length.toString());
    super.initState();
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
                onChanged: (value){
                  setState(() {
                    allStock = tempStock
                                .where((x) => x.goodName1.toLowerCase().contains(value) ||
                                x.goodCode.toLowerCase().contains(value))
                                .toList();

                            final ids = allStock.map((e) => e.goodid).toSet();
                            allStock.retainWhere((x) => ids.remove(x.goodid));
                            allStock.forEach((element) => element.orderNumber = 1);
                  });
                },
              ),

              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       String query = txtKeyword.text;
              //       setState(() {
              //         allStock = tempStock
              //             .where((x) => x.goodName1.toLowerCase().contains(query) ||
              //             x.goodCode.toLowerCase().contains(query))
              //             .toList();
              //
              //         final ids = allStock.map((e) => e.goodid).toSet();
              //         allStock.retainWhere((x) => ids.remove(x.goodid));
              //         allStock.forEach((element) => element.orderNumber = 1);
              //       });
              //     },
              //     //style: ButtonStyle(padding:),
              //     icon: Icon(Icons.search),
              //     label: Text(
              //       'ค้นหาสินค้า',
              //       style: TextStyle(fontSize: 18),
              //     ),
              //   ),
              // ),
              Container(
                color: Theme.of(context).primaryColor,
                width: double.infinity,
                margin: EdgeInsets.only(top: 0.0),
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text('สินค้าคงเหลือ ${allStock.length.toString()} รายการ', style: TextStyle(fontSize: 18.0, color: Colors.white),)),
              ),
              Expanded(
                child: ItemStock(
                  // Instead of pushing a new route here, we update
                  // the currently selected item, which is a part of
                  // our state now.
                  allStock: allStock,
                  selectedItem: _selectedItem,
                  itemSelectedCallback: (item) {
                    setState(() {
                      _selectedItem = item;
                      globals.selectedStock = item;
                      //getPrice();
                      // globals.customer = item;
                      print('Item selected: ${item.goodName1}');
                    });
                  },
                ),
              ),
            ]),
          ),
        ),
        Flexible(
          flex: 4,
          child: ItemStockDetail(
            // The item details just blindly accepts whichever
            // item we throw in its way, just like before.
            selectedStock: _selectedItem,
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
              'รายงาน สินค้าคงเหลือ',
              style: GoogleFonts.sarabun(fontSize: 20),
            )),
      ),
      body: content,
    );
  }
}
