import 'package:ismart_crm/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:ismart_crm/globals.dart' as globals;

class ItemCustomerDetail extends StatefulWidget {
  // const ItemListDetails({ Key key }) : super(key: key);
  const ItemCustomerDetail({
    @required this.isInTabletLayout,
    @required this.customer,
  });

  final bool isInTabletLayout;
  final Customer customer;

  @override
  _ItemCustomerDetailState createState() => _ItemCustomerDetailState();
}

class _ItemCustomerDetailState extends State<ItemCustomerDetail> {
  final currency = NumberFormat("#,##0.00", "en_US");
  TextEditingController txtCustName = TextEditingController();
  TextEditingController txtCustCode = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtContact = TextEditingController();
  TextEditingController txtTel = TextEditingController();
  TextEditingController txtRemark = TextEditingController();
  TextEditingController txtCustGroup = TextEditingController();
  TextEditingController txtCustType = TextEditingController();
  TextEditingController txtCustTaxId = TextEditingController();
  TextEditingController txtBranch = TextEditingController();
  TextEditingController txtCreditType = TextEditingController();
  TextEditingController txtCreditDays = TextEditingController();
  TextEditingController txtCreditAmnt = TextEditingController();
  TextEditingController txtCreditState = TextEditingController();
  TextEditingController txtInactive = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //globals.customer = widget.customer;
      txtCustCode.text = widget.customer?.custCode;
      txtCustName.text = widget.customer?.custName;
      txtAddress.text = '${widget.customer?.custAddr1 ?? ''} ${widget.customer?.custAddr2 ?? ''} ${widget.customer?.district ?? ''} ${widget.customer?.amphur ?? ''} ${widget.customer?.province ?? ''} ${widget.customer?.postCode ?? ''}';
      txtTel.text = widget.customer?.contTel ?? '';
      txtCustGroup.text = widget.customer?.custGroupName ?? '';
      txtCustType.text = widget.customer?.custTypeName;
      txtBranch.text = widget.customer?.brchName;
      txtCustTaxId.text = widget.customer?.taxId;
      //txtCreditType.text = widget.customer?.typ;
      txtCreditType.text = widget.customer?.creditType;
      txtCreditDays.text = widget.customer?.creditDays.toString();
      txtCreditAmnt.text = currency.format(widget.customer?.creditAmnt ?? 0);
      txtCreditState.text = widget.customer?.creditState == '2' ? 'ปกติ' : 'ทั่วไป';
      txtInactive.text = widget.customer?.inactive == 'A' ? 'พร้อมใช้งาน' : widget.customer?.inactive == 'I' ? 'ไม่พร้อมใช้งาน' : 'Holding';
    });

    final TextTheme textTheme = Theme.of(context).textTheme;
    final Widget content = ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('รหัสลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 4,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCustCode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "รหัสลูกค้า",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ชื่อลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 5,
                    child: ListTile(
                  title: TextFormField(
                    //initialValue: txtCustName,
                    readOnly: true,
                    controller: txtCustName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "ชื่อลูกค้า",
                    ),
                  ),
                )
                ),

                // Flexible(
                //   flex: 2,
                //     child: ElevatedButton.icon(
                //         onPressed: () {
                //           setState(() {
                //             globals.customer = widget.customer;
                //           });
                //
                //           Navigator.pop(context);
                //         },
                //         icon: Icon(Icons.check_circle_sharp),
                //         label: Text(
                //           'เลือกลูกค้า',
                //           style: TextStyle(fontSize: 18),
                //         ),
                //         style:
                //         ElevatedButton.styleFrom(padding: EdgeInsets.all(12), primary: Colors.green)
                //     ),
                // ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ที่อยู่',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        //floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "ที่อยู่",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ผู้ติดต่อ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      initialValue: '',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "ผู้ติดต่อ",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtTel,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "โทรศัพท์",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('กลุ่มลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCustGroup,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "กลุ่มลูกค้า",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('สถานะลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtInactive,
                      // controller: txtCustType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "สถานะลูกค้า",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('เลขประจำตัวผู้เสียภาษี',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCustTaxId,
                      textAlign: TextAlign.left,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "เลขประจำตัวผู้เสียภาษี",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtBranch,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "สาขา",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('วงเงินทั้งหมด',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      initialValue: '',
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "วงเงินทั้งหมด",
                      ),
                    ),
                  ),
                ),

                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      initialValue: '',
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "วงเงินที่ใช้ไป",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('วงเงินคงเหลือ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditAmnt,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "วงเงินคงเหลือ",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditState,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "สถานะ",
                      ),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ประเภทเครดิต',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "ประเภทเครดิต",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditDays,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "เครดิต / วัน",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('DSO',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      initialValue: '',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "DSO",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      initialValue: '',
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "ชำระเงินครั้งล่าสุด",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('หมายเหตุ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtRemark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "หมายเหตุ",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Text(
            //   item?.title ?? 'No item selected!',
            //   style: textTheme.headline,
            // ),
            // Text(
            //   item?.subtitle ?? 'Please select one on the left.',
            //   style: textTheme.subhead,
            // ),
          ],
        )
      ],
    );

    if (widget.isInTabletLayout) {
      return Center(child: content);
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.customer?.custName)),
      ),
      body: ListView(children: [
        Center(child: content),
      ]),
    );
  }
}
