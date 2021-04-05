import 'package:flutter/material.dart';
import 'package:ismart_crm/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';

class ItemCustomer extends StatefulWidget {
  ItemCustomer(
      {@required this.itemSelectedCallback,
      this.selectedItem,
      this.allCustomer});

  final ValueChanged<Customer> itemSelectedCallback;
  final Customer selectedItem;
  List<Customer> allCustomer;

  @override
  _ItemCustomerState createState() => _ItemCustomerState();
}

class _ItemCustomerState extends State<ItemCustomer> {
  final ScrollController _scroll = ScrollController();
  ApiService _apiService = ApiService();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scroll.dispose();
  }

  void getScrollAtElement(int index) {
      //widget.allCustomer = globals.allCustomer;
      /// Wait till Build finish.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //write or call your logic
        //code will run when widget rendering complete
        if (_scroll.hasClients) {
          _scroll.animateTo((72.0 * index),
              // 100 is the height of container and index of 6th element is 5
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    getScrollAtElement(widget.allCustomer?.indexWhere((x) => x.custCode == widget.selectedItem?.custCode));
    return Scrollbar(
      controller: _scroll,
      isAlwaysShown: false,
      thickness: 3.0,
      radius: Radius.circular(20.0),
      child: ListView(
        controller: _scroll,
        // children: widget.allCustomer?.map((item) {
        children: widget.allCustomer.map((item) {
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                    BorderSide(width: 0.5, color: Colors.black26))),
            child: ListTile(
              title: Text(item?.custName),
              subtitle: Text(item?.custCode),
              onTap: () => widget.itemSelectedCallback(item),
              selected: widget.selectedItem?.custCode == item?.custCode,
              selectedTileColor: Colors.grey[200],
              hoverColor: Colors.grey,
            ),
          );
        })?.toList() ??
            [],
      ),
    );
  }
}
