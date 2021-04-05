import 'package:flutter/material.dart';
import 'package:ismart_crm/models/stock.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;

class ItemStock extends StatefulWidget {
  ItemStock({
    @required this.itemSelectedCallback,
    this.selectedItem,
    this.allStock
  });

  final ValueChanged<Stock> itemSelectedCallback;
  final Stock selectedItem;
  List<Stock> allStock;

  @override
  _ItemStockState createState() => _ItemStockState();
}

class _ItemStockState extends State<ItemStock> {
  ScrollController _scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScrollAtElement(widget.allStock?.indexWhere((x) => x.goodCode == widget.selectedItem?.goodCode));
    print(widget.allStock?.indexWhere((x) => x.goodCode == widget.selectedItem?.goodCode));
  }

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
    return
      Scrollbar(
        controller: _scroll,
        radius: Radius.circular(5.0),
        thickness: 3.0,
        child: ListView(
          controller: _scroll,
          children: widget.allStock?.map((item) {
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
