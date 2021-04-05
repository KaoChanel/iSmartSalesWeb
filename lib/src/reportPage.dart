import 'package:flutter/material.dart';
import 'containerOrderTracking.dart';
import 'containerStock.dart';
import 'containerCustomer.dart';
import 'package:flutter/cupertino.dart';
import 'package:ismart_crm/widgets/menuCard.dart';
import 'package:ismart_crm/globals.dart' as globals;

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

Widget createCard(context, String title, String imagePath, String routeName){
  return Card(
      color: Colors.white,
      child: InkWell(
        onTap: (){
          if(routeName == 'ContainerOrderTracking'){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContainerOrderTracking()));
          }
          else if(routeName == 'ContainerStock'){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContainerStock()));
          }
        },
        child: Column(
          children: [
            new Container(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(imagePath)
            ),
            new Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(title, style: Theme.of(context).textTheme.headline6)),
                  // Text(choice.date,
                  //     style: TextStyle(color: Colors.black.withOpacity(0.5))),
                  // Text(choice.description),
                ],
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ));
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController txtCustomer = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      txtCustomer.text = globals.customer?.custName;
    });
    return ListView(
      children:[
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                    readOnly: true,
                    //initialValue: 'โรงงานสัตว์เลี้ยง 55555',
                    controller: txtCustomer,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      //labelText: "ลูกค้าของคุณ",
                      hintText: "ลูกค้าของคุณ",
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ContainerCustomer())
                      ).then((value) {setState(() {});
                      });
                    },
                  )),
            ],
          ),
        ),
        Row(
        children: [
          //Container(),
          Expanded(
              child: Container(
                  child: Stack(
                    //height: 200,
                      children: [
                        MenuCard(title:'สถานะเอกสาร', path:'assets/business_click.jpg'),
                        new Positioned.fill(
                            child: new Material(
                                color: Colors.transparent,
                                child: new InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => null,
                                )))
                      ]))
          ),
          Expanded(
              // child:Container(
              //     child: MenuCard(title:'สต๊อคสินค้า', path:'assets/business_inventory.jpg')
              // )
            child: Container(
                child: Stack(
                  //height: 200,
                    children: [
                      MenuCard(title:'ประวัติการสั่งซื้อ', path:'assets/order_02.jpg'),
                      new Positioned.fill(
                          child: new Material(
                              color: Colors.transparent,
                              child: new InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContainerStock()));
                                },
                              )))
                    ])),
          ),
          Expanded(
              child:Container(
              child: Stack(
                //height: 200,
                  children: [
                    MenuCard(title:'วิเคราะห์ขาย สินค้า', path:'assets/analysis_02.jpg'),
                    new Positioned.fill(
                        child: new Material(
                            color: Colors.transparent,
                            child: new InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => null,
                            )))
                  ]))),
          Expanded(child:Container(
              child: Stack(
                //height: 200,
                  children: [
                    MenuCard(title:'วิเคราะห์ขาย ลูกค้า', path:'assets/analysis_05.jpg'),
                    new Positioned.fill(
                        child: new Material(
                            color: Colors.transparent,
                            child: new InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => null,
                            )))
                  ]))),
        ],
      ),
        Row(
          children: [
            Expanded(
              // child:Container(
              //     child: MenuCard(title:'สต๊อคสินค้า', path:'assets/business_inventory.jpg')
              // )
              child: Container(
                  child: Stack(
                    //height: 200,
                      children: [
                        MenuCard(title:'สต๊อคสินค้า', path:'assets/business_inventory.jpg'),
                        new Positioned.fill(
                            child: new Material(
                                color: Colors.transparent,
                                child: new InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ContainerStock()));
                                  },
                                )))
                      ])),
            ),
            Expanded(
              // child:Container(
              //     child: MenuCard(title:'สต๊อคสินค้า', path:'assets/business_inventory.jpg')
              // )
              child: Container(
                  child: Stack(
                    //height: 200,
                      children: [
                        MenuCard(title:'บิลค้างชำระ', path:'assets/analysis_01.jpg'),
                        new Positioned.fill(
                            child: new Material(
                                color: Colors.transparent,
                                child: new InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ContainerStock()));
                                  },
                                )))
                      ])),
            ),
            Expanded(
              child: Visibility(
                visible: false,
                child: Container(),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: false,
                child: Container(),
              ),
            ),
          ],
        )
    ]
    );
  }
}
