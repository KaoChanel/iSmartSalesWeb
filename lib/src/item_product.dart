import 'package:flutter/material.dart';
import 'package:ismart_crm/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;

class ItemProduct extends StatefulWidget {
  ItemProduct({
    @required this.itemSelectedCallback,
    this.selectedItem,
    this.allProduct
  });

  final ValueChanged<Product> itemSelectedCallback;
  final Product selectedItem;
  List<Product> allProduct;

  @override
  _ItemProductState createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scroll.dispose();
  }

  void getScrollAtElement(int index){
    setState(() {
      //widget.allCustomer = globals.allCustomer;
      /// Wait till Build finish.
      WidgetsBinding.instance.addPostFrameCallback((_){
        //write or call your logic
        //code will run when widget rendering complete
        if(_scroll.hasClients) {
          _scroll.animateTo((72.0 * index),
              // 100 is the height of container and index of 6th element is 5
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getScrollAtElement(widget.allProduct?.indexWhere((x) => x.goodCode == widget.selectedItem?.goodCode));
    return Scrollbar(
        controller: _scroll,
        isAlwaysShown: false,
        thickness: 3.0,
        radius: Radius.circular(20.0),
        child: ListView(
          controller: _scroll,
          children: widget.allProduct?.map((item) {
            return Container(
              decoration:
              new BoxDecoration(
                  border: new Border(
                      bottom: new BorderSide(width: 0.5, color: Colors.black26)
                  )
              ),
              child: ListTile(
                  title: Text(item?.goodName1),
                  subtitle: Text(item?.goodCode),
                  onTap: () {
                    widget.itemSelectedCallback(item);
                    },
                  selected: widget.selectedItem?.goodCode == item?.goodCode,
                  selectedTileColor: Colors.grey[200],
                  hoverColor: Colors.grey,
                ),
            );
          })?.toList() ?? [],
        ),
      );
  }
}
