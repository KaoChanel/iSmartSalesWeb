import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/models/stock.dart';

class ItemStockDetail extends StatefulWidget {
  ItemStockDetail({
    @required this.isInTabletLayout,
    @required this.selectedStock
  });

  final bool isInTabletLayout;
  final Stock selectedStock;

  @override
  _ItemStockDetailState createState() => _ItemStockDetailState();
}

class _ItemStockDetailState extends State<ItemStockDetail> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<Stock> stockByProd = new List<Stock>();

  void setSelectedItem(){
    int index = 1;
    stockByProd = globals.allStock.where((element) => element.goodid == widget.selectedStock?.goodid).toList();
    stockByProd.forEach((element) {element.orderNumber = index++;});
  }

  Widget createTable(){
    int index = 0;
    return DataTable(
      headingRowColor:
      MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
      headingTextStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.normal),
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'ลำดับ',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'รหัสสินค้า',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        // DataColumn(
        //   label: Text(
        //     'ชื่อสินค้า',
        //     style: TextStyle(fontStyle: FontStyle.italic),
        //   ),
        // ),
        DataColumn(
          label: Text(
            'Lot No.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Expire Date',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          numeric: true,
          label: Text(
            'คงเหลือ',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'หน่วย',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],

      rows: // Loops through dataColumnText, each iteration assigning the value to element
      stockByProd.map(
        ((element) =>  DataRow(
          cells: <DataCell>[
            DataCell(Container(alignment: AlignmentDirectional.center, child: Text(element.orderNumber.toString()))), //Extracting from Map element the value
            DataCell(Container(child: Text(element.goodCode))),
            //DataCell(Text(element.goodName1)),
            DataCell(Container(width:90, child: Text(element.lotNo))),
            DataCell(Text(formatter.format(element.expiredate))),
            DataCell(Text(element.remaqty.toString())),
            DataCell(Container(width: 80, child: Text(element.goodUnitCode))),
          ],
        )),
      )
          .toList() ?? [],

    );
  }

  @override
  Widget build(BuildContext context) {
    setSelectedItem();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Expanded(child: createTable()),
        ],
      ),
    );
  }
}
