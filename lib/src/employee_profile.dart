import 'package:flutter/material.dart';
import 'package:ismart_crm/models/employee.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ismart_crm/charts/lineChart.dart';
import 'package:ismart_crm/charts/pieChart.dart';
import 'package:ismart_crm/charts/barChart.dart';
import 'package:ismart_crm/charts/indicator.dart';
import 'package:ismart_crm/models/sales.dart';
import 'package:ismart_crm/models/sales_daily.dart';
import 'package:ismart_crm/models/sales_monthly.dart';

class EmployeeProfile extends StatefulWidget {
  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> with TickerProviderStateMixin {
  static const routeName = '/employee_profile';
  bool isShowingMainData;
  int touchedIndex;
  Employee _employees;
  TabController _controller;
  List<Sales> allSales = <Sales>[];
  List<SalesDaily> allSalesDaily = <SalesDaily>[];
  List<SalesMonthly> allSalesMonthly = <SalesMonthly>[];
  ApiService _apiService = ApiService();

  Future<void> getEmployee(String empId) async {
    String strUrl = '${globals.publicAddress}/api/employees/$empId';
    var response = await http.get(Uri.parse(strUrl));

    setState(() {
      _employees = employeeFromJson(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isShowingMainData = true;
    _controller = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(globals.options == null || globals.vatGroup == null || globals.allShipto == null
      || globals.allCustomer == null || globals.allProduct == null || globals.allStock == null
      || globals.allGoodsUnit == null || globals.allRemark == null || globals.allStockReserve == null) {
        globals.showLoaderDialog(this.context, false);
        await loadData();
        Navigator.pop(this.context);
      }
    });
    // if(globals.allCustomer == null || globals.allProduct == null || globals.allGoodsUnit == null || globals.allShipto == null || globals.allStock == null || globals.allRemark == null){
    //   //_apiService.getCompany();
    //   loadData();
    // }
  }

  loadData() async {
    await _apiService.getOption();
    await _apiService.getAllCustomer();
    await _apiService.getProduct();
    await _apiService.getUnit();
    await _apiService.getShipto();
    await _apiService.getStock();
    await _apiService.getStockReserve();
    await _apiService.getRemark();
  }

  Widget lineChartBox(bool isShowingMainData) {
    return FutureBuilder(
      future: globals.selectedCycle == globals.annualCycle.monthly
          ? _apiService.getSalesDaily()
          : globals.selectedCycle == globals.annualCycle.quarterly
          ? _apiService.getSalesMonthly()
          : _apiService.getSales(),

      builder: (BuildContext context, AsyncSnapshot<Object> snapShot) {
        if(snapShot.hasData){
          globals.selectedCycle == globals.annualCycle.monthly
              ? allSalesDaily = snapShot.data
              : globals.selectedCycle == globals.annualCycle.quarterly
              ? allSalesMonthly = snapShot.data
              : allSales = snapShot.data;

          globals.selectedCycle == globals.annualCycle.monthly
              ? allSalesDaily.sort((a, b) => a.xMonth.compareTo(b.xMonth))
              : globals.selectedCycle == globals.annualCycle.quarterly
              ? allSalesMonthly.sort((a, b) => a.xMonth.compareTo(b.xMonth))
              : allSales.sort((a, b) => a.xDay.compareTo(b.xDay));

          // allSales.sort((a, b) => a.xDay.compareTo(b.xDay));
          // allSalesDaily.sort((a, b) => a.xMonth.compareTo(b.xMonth));
          // allSalesMonthly.sort((a, b) => a.xMonth.compareTo(b.xMonth));
          // summaryDaily(allSales);
          return AspectRatio(
            aspectRatio: 1.20,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff2c274c),
                    Color(0xff46426c),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Summary ${DateTime.now().year.toString()}',
                        style: TextStyle(
                          color: Color(0xff827daa),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        globals.selectedCycle == globals.annualCycle.monthly ? 'Monthly Sales' : globals.selectedCycle == globals.annualCycle.quarterly ? 'Quarterly Sales' : 'Yearly Sales',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 37,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: globals.selectedCycle == globals.annualCycle.monthly
                              ? barChart(allSalesDaily) : globals.selectedCycle == globals.annualCycle.quarterly
                              ? lineChartQuarter(allSalesMonthly) : barChart1(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: IconButton(
                            alignment: Alignment.centerLeft,
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white.withOpacity(globals.isMainData ? 1.0 : 0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                globals.isMainData = !globals.isMainData;
                              });
                            },
                          )),
                      TextButton(
                        child: Text(
                            'Month',
                            style: TextStyle(color: globals.selectedCycle == globals.annualCycle.monthly ? Colors.white : Colors.grey)),
                        onPressed: (){
                          setState(() {
                            globals.selectedCycle = globals.annualCycle.monthly;
                          });
                        },
                      ),
                      TextButton(
                        child: Text('Quarter', style: TextStyle(color: globals.selectedCycle == globals.annualCycle.quarterly ? Colors.white : Colors.grey)),
                        onPressed: (){
                          setState(() {
                            globals.selectedCycle = globals.annualCycle.quarterly;
                          });
                        },
                      ),
                      FlatButton(
                        child: Text('Year', style: TextStyle(color: globals.selectedCycle == globals.annualCycle.yearly ? Colors.white : Colors.grey)),
                        onPressed: (){
                          setState(() {
                            globals.selectedCycle = globals.annualCycle.yearly;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        else{
          return CircularProgressIndicator();
        }
      }
    );
  }

  Widget pieChartBox(){
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'First',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Second',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Third',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'Fourth',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: SafeArea(
            child: Row(
              children:[
                Expanded(
                  flex: 2,
                  child: ListView(
                  children:[
                    Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/bg_04.jpg"),
                                fit: BoxFit.fitWidth
                            )
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: Container(
                            alignment: Alignment(0.0, 5.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/avatar_01.png"),
                              radius: 60.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        "${globals.employee?.empTitle}${globals.employee?.empName}"
                        ,style: TextStyle(
                          fontSize: 20.0,
                          color:Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400
                      ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        globals.employee?.postName ?? 'Technicial & Product Advisor'
                        ,style: TextStyle(
                          fontSize: 18.0,
                          color:Colors.black45,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300
                      ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        globals.allCompany?.first?.compNameEng ?? ''
                        ,style: TextStyle(
                          fontSize: 15.0,
                          color:Colors.black45,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300
                      ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Card(
                      //     margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                      //     elevation: 2.0,
                      //     child: Padding(
                      //         padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                      //         child: Text("Skill Sets",style: TextStyle(
                      //             letterSpacing: 2.0,
                      //             fontWeight: FontWeight.w300
                      //         ),))
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Text(
                      //   "App Developer || Digital Marketer"
                      //   ,style: TextStyle(
                      //     fontSize: 18.0,
                      //     color:Colors.black45,
                      //     letterSpacing: 2.0,
                      //     fontWeight: FontWeight.w300
                      // ),
                      // ),
                      // Card(
                      //   margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Expanded(
                      //           child: Column(
                      //             children: [
                      //               Text("Project",
                      //                 style: TextStyle(
                      //                     color: Colors.blueAccent,
                      //                     fontSize: 22.0,
                      //                     fontWeight: FontWeight.w600
                      //                 ),),
                      //               SizedBox(
                      //                 height: 7,
                      //               ),
                      //               Text("15",
                      //                 style: TextStyle(
                      //                     color: Colors.black,
                      //                     fontSize: 22.0,
                      //                     fontWeight: FontWeight.w300
                      //                 ),)
                      //             ],
                      //           ),
                      //         ),
                      //         Expanded(
                      //           child:
                      //           Column(
                      //             children: [
                      //               Text("Followers",
                      //                 style: TextStyle(
                      //                     color: Colors.blueAccent,
                      //                     fontSize: 22.0,
                      //                     fontWeight: FontWeight.w600
                      //                 ),),
                      //               SizedBox(
                      //                 height: 7,
                      //               ),
                      //               Text("2000",
                      //                 style: TextStyle(
                      //                     color: Colors.black,
                      //                     fontSize: 22.0,
                      //                     fontWeight: FontWeight.w300
                      //                 ),)
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 50,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     RaisedButton(
                      //       onPressed: (){
                      //       },
                      //       shape:  RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(80.0),
                      //       ),
                      //       child: Ink(
                      //         decoration: BoxDecoration(
                      //           gradient: LinearGradient(
                      //               begin: Alignment.centerLeft,
                      //               end: Alignment.centerRight,
                      //               colors: [Colors.pink,Colors.redAccent]
                      //           ),
                      //           borderRadius: BorderRadius.circular(30.0),
                      //         ),
                      //         child: Container(
                      //           constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                      //           alignment: Alignment.center,
                      //           child: Text(
                      //             "Contact me",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 12.0,
                      //                 letterSpacing: 2.0,
                      //                 fontWeight: FontWeight.w300
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     RaisedButton(
                      //       onPressed: (){
                      //       },
                      //       shape:  RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(80.0),
                      //       ),
                      //       child: Ink(
                      //         decoration: BoxDecoration(
                      //           gradient: LinearGradient(
                      //               begin: Alignment.centerLeft,
                      //               end: Alignment.centerRight,
                      //               colors: [Colors.pink,Colors.redAccent]
                      //           ),
                      //           borderRadius: BorderRadius.circular(80.0),
                      //         ),
                      //         child: Container(
                      //           constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                      //           alignment: Alignment.center,
                      //           child: Text(
                      //             "Portfolio",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 12.0,
                      //                 letterSpacing: 2.0,
                      //                 fontWeight: FontWeight.w300
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //  ],
                      //)
                    ],
                  )],
              ),
                ),
                Expanded(
                  flex: 4,
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            lineChartBox(isShowingMainData),
                          // pieChartBox(),
                        ],
                      )],
                    ),
                    // child: AspectRatio(
                    //   aspectRatio: 1.23,
                    //   child: Container(
                    //     decoration: const BoxDecoration(
                    //       borderRadius: BorderRadius.all(Radius.circular(18)),
                    //       gradient: LinearGradient(
                    //         colors: [
                    //           Color(0xff2c274c),
                    //           Color(0xff46426c),
                    //         ],
                    //         begin: Alignment.bottomCenter,
                    //         end: Alignment.topCenter,
                    //       ),
                    //     ),
                    //     child: Stack(
                    //       children: <Widget>[
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           children: <Widget>[
                    //             const SizedBox(
                    //               height: 37,
                    //             ),
                    //             Text(
                    //               'Summary ${DateTime.now().year.toString()}',
                    //               style: TextStyle(
                    //                 color: Color(0xff827daa),
                    //                 fontSize: 16,
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //             const SizedBox(
                    //               height: 4,
                    //             ),
                    //             const Text(
                    //               'Monthly Sales',
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 32,
                    //                   fontWeight: FontWeight.bold,
                    //                   letterSpacing: 2),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //             const SizedBox(
                    //               height: 37,
                    //             ),
                    //             Expanded(
                    //               child: Padding(
                    //                 padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    //                 child: LineChart(
                    //                   isShowingMainData ? sampleData1() : sampleData2(),
                    //                   swapAnimationDuration: const Duration(milliseconds: 250),
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               height: 10,
                    //             ),
                    //           ],
                    //         ),
                    //         IconButton(
                    //           icon: Icon(
                    //             Icons.refresh,
                    //             color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                    //           ),
                    //           onPressed: () {
                    //             setState(() {
                    //               isShowingMainData = !isShowingMainData;
                    //             });
                    //           },
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // )
                )
            ]),
          )
      ),
    );
  }
}
