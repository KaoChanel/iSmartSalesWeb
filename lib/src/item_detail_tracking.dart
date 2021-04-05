import 'package:flutter/material.dart';

class ItemDetailTracking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(child: null),
                Expanded(child: null),
                Expanded(child: null),
              ],
            ),
            Row(
              children: [
                Expanded(child: null),
                Expanded(child: null),
                Expanded(child: null),
                Expanded(child: null),
              ],
            ),
            Row(
              children: [
                Expanded(child: null),
                Expanded(child: null),
                Expanded(child: null),
                Expanded(child: null),
              ],
            ),
            Row(
              children: [
                Expanded(child: null),
                Expanded(child: null)
              ],
            ),
            Row(
              children: [
                SingleChildScrollView(
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
                          'รหัสสินค้า',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'ชื่อสินค้า',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'หน่วย',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'จำนวน',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'จำนวนเงิน',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'ส่งจำนวน',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'ส่งจำนวนเงิน',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'ค้างส่งจำนวน',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'ค้างส่งจำนวนเงิน',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'หมายเหตุยกเลิก',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],

                    rows: const <DataRow>[

                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(child: null),
                      Expanded(child: null),
                      Expanded(child: null),
                      Expanded(child: null),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(child: null),
                      Expanded(child: null),
                      Expanded(child: null),
                      Expanded(child: null),
                    ],
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
