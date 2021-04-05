import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;

class ItemHeaderTracking extends StatefulWidget {
  ItemHeaderTracking({
        @required this.isInTabletLayout
  });

  final bool isInTabletLayout;

  @override
  _ItemHeaderTrackingState createState() => _ItemHeaderTrackingState();
}

class _ItemHeaderTrackingState extends State<ItemHeaderTracking> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'ลำดับ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'ใบสั่งซื้อ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'เลขที่อ้างอิง',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'เลขที่อ้างอิง',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'ใบสั่งจอง',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'SO',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'บิล',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],

        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Sarah')),
              DataCell(Text('19')),
              DataCell(Text('Student')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Janine')),
              DataCell(Text('43')),
              DataCell(Text('Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('William')),
              DataCell(Text('27')),
              DataCell(Text('Associate Professor')),
            ],
          ),
        ],
      ),
    );
  }
}
