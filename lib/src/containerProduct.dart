import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ismart_crm/models/product.dart';
import 'package:ismart_crm/models/product_cart.dart';
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

class ContainerProduct extends StatefulWidget {
  //const ContainerProduct({ Key key }) : super(key: key);
  const ContainerProduct(this.title, this.editing_product, this.docType);

  final String title;
  final ProductCart editing_product;
  final String docType;

  @override
  _ContainerProductState createState() => _ContainerProductState();
}

class _ContainerProductState extends State<ContainerProduct> {
  static const int kTabletBreakpoint = 400;
  double _goodQty = 0;
  double _goodPrice = 0;
  double editedPrice = 0;
  double _total = 0;
  double _discount = 0;
  String _discountType;
  Product _selectedItem = globals.selectedProduct;
  List<Product> allProduct = globals.allProduct;
  TextEditingController txtKeyword = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setEditingSelected();
  }

  void setEditingSelected() {
    if (widget.editing_product != null) {
      globals.editingProductCart = widget.editing_product;

      _selectedItem = allProduct.firstWhere(
            (element) => element.goodCode == widget.editing_product.goodCode);
      _goodQty = widget.editing_product.goodQty;
      _goodPrice = widget.editing_product.goodPrice;
      _discount = widget.editing_product.discount;
      _total = widget.editing_product.goodAmount;

      print(widget.editing_product.goodCode);
      print('Editing Qty: ${widget.editing_product.goodQty}');
      print('Editing GoodQty: $_goodQty');
      print('Editing Good Price: ${widget.editing_product.goodPrice}');
      print(widget.editing_product.goodAmount);
    }
  }

  Future<void> getPrice() async {
    var response = await http.get(
        '${globals.publicAddress}/api/product/${globals.company}/${_selectedItem?.goodCode}/1');
    Map values = json.decode(response.body);

    _goodQty = 1;
    _goodPrice = double.parse(values['price'].toString());
    _total = double.parse(values['total'].toString());

    print('Price / Unit: ' + _goodPrice.toString() + ' Total: ' + values['total'].toString());
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
                    allProduct = globals.allProduct
                                .where((x) =>
                                    x.goodName1.toLowerCase().contains(value) ||
                                    x.goodCode.toLowerCase().contains(value))
                                .toList();
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
              //         allProduct = globals.allProduct
              //             .where((x) =>
              //                 x.goodName1.toLowerCase().contains(query) ||
              //                 x.goodCode.toLowerCase().contains(query))
              //             .toList();
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
                child: Center(child: Text('สินค้าทั้งหมด ${allProduct != null ? allProduct.length.toString() : 0} รายการ', style: TextStyle(fontSize: 18.0, color: Colors.white),)),
              ),
              Expanded(
                flex: 5,
                child: ItemProduct(
                  // Instead of pushing a new route here, we update
                  // the currently selected item, which is a part of
                  // our state now.
                  allProduct: allProduct,
                  selectedItem: _selectedItem,
                  itemSelectedCallback: (item) {
                    setState(() {
                      _selectedItem = item;
                      getPrice();
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
          child: ItemProductDetail(
            // The item details just blindly accepts whichever
            // item we throw in its way, just like before.
            product: _selectedItem,
            quantity: widget.docType != 'ORDER' ? widget.editing_product != null ? widget.editing_product.goodQty : _goodQty : _goodQty,
            price: widget.docType != 'ORDER' ? widget.editing_product != null ? widget.editing_product?.goodPrice : _goodPrice : _goodPrice,
            editedPrice: 0,
            total: _total,
            isInTabletLayout: true,
            docType: widget.docType,
            productCart: widget.editing_product,
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
          '${widget.title} ${widget.editing_product?.rowIndex ?? globals.productCart.length + 1}',
          style: GoogleFonts.sarabun(fontSize: 20),
        )),
      ),
      body: content,
    );
  }
}
