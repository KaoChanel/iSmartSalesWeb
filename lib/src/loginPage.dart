import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ismart_crm/models/employee.dart';
import 'package:ismart_crm/src/launcher.dart';
import 'package:ismart_crm/widgets/bezierContainer.dart';
import 'package:ismart_crm/models/company.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_crm/models/user.dart';
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Company compValue;
  TextEditingController txtUsername = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  ApiService _apiService = new ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globals.checkConnection(context);
    autoLogIn();
  }

  @override
  void dispose() {
    super.dispose();
    txtUsername.dispose();
    txtPassword.dispose();
    globals.listener.cancel();
  }

@override
Widget build(BuildContext context) {
  final height = MediaQuery
      .of(context)
      .size
      .height;
  final width = MediaQuery
      .of(context)
      .size
      .width;
  return Scaffold(
    // backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .16,
                // right: -MediaQuery
                //     .of(context)
                //     .size
                //     .width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // SizedBox(height: height * .1),
                    _title(),
                    SizedBox(height: 20),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    _companySelect(),
                    SizedBox(height: 20),
                    _submitButton(),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: Text('Forgot Password ?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    // _divider(),
                    //_facebookButton(),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
            // Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ));
}


  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username');
    final String password = prefs.getString('password');
    final String company = prefs.getString('company');
    // globals.isLockPrice = prefs.getBool('lockPrice');

    if(username != null && password != null && company != null){
      getUser(company, username, password);
    }

    txtUsername.text = username ?? '';

    // if (userName != null) {
    //   setState(() {
    //     isLoggedIn = true;
    //     name = userName;
    //   });
    //   return;
    // }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', '');
    prefs.setString('company', '');
    prefs.setString('customer', '');
    prefs.setString('lockPrice', '');

    // setState(() {
    //   name = '';
    //   isLoggedIn = false;
    // });
  }

  Future<Employee> getUser(String company, String username, String password) async {
    try
    {
      globals.showLoaderDialog(context, false);
      String strUrl = '${globals.publicAddress}/api/login/LoginByEmpCode/$company/$username/$password';
      http.Response response = await http.get(strUrl);
      if(response.body.isNotEmpty) {
        var decode = jsonDecode(response.body);

        print(response.body);

        if (decode['empId'] != 0) {
          // _user = userFromJson(response.body);
          //
          // String strUrl = '${globals.publicAddress}/api/employees/$company/${_user.empId}';
          // response = await http.get(strUrl);
          globals.employee = employeeFromJson(response.body);
          if(globals.employee.empHead == null) globals.employee.empHead = globals.employee.empId;
          globals.company = company;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', globals.employee.empCode);
          prefs.setString('password', password);
          prefs.setString('company', company);
          globals.isLockPrice = globals.employee.isLockPrice == 'Y' ? true : false;
          final int custId = prefs.getInt('customer');

          if(custId != null){
            print('custId = ${custId}');
            print('custId != null ${globals.customer}');
            globals.customer = await _apiService.getCustomer(globals.employee.empId, custId);
            print('globals.customer ${globals.customer}');
            if(globals.customer != null){
              print('globals.customer != null');
              globals.selectedShipto = await _apiService.getShiptoByCustomer(custId);
            }
            else{
              prefs.setString('customer', null);
            }
          }

          Navigator.pop(context);
          await _apiService.getCompany();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher()));

          // _apiService.getCompany().then((value) =>
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(builder: (context) => Launcher()))
          // );
        }
        else {
          Navigator.pop(context);
          showAlertDialog(context, 'ไม่พบข้อมูลพนักงาน');
        }
        // Navigator.pop(context);
        //print(_user);
        //     .then((value) {
        //   if(value.statusCode == 200){
        //     print(value.body);
        //     var decode = jsonDecode(value.body);
        //
        //     if (decode['empId'] != 0) {
        //       // _user = userFromJson(response.body);
        //       //
        //       // String strUrl = '${globals.publicAddress}/api/employees/$company/${_user.empId}';
        //       // response = await http.get(strUrl);
        //
        //       globals.employee = employeeFromJson(value.body);
        //       globals.company = company;
        //
        //       Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(builder: (context) => Launcher()));
        //     }
        //     else {
        //       showAlertDialog(context, 'เข้าสู่ระบบไม่สำเร็จ');
        //     }
        //     // Navigator.pop(context);
        //     print(_user);
        //   }
        //   else{
        //     showAlertDialog(context, 'เข้าสู่ระบบไม่สำเร็จ');
        //   }
        // });
      }
      else {
        Navigator.pop(context);
        showAlertDialog(context, 'เข้าสู่ระบบไม่สำเร็จ');
      }
    }
    on SocketException {
      Navigator.pop(context);
      globals.showAlertDialog('Internet Connection', 'ไม่สามารถเชื่อมต่อกับอินเตอร์เน็ต', context);
    }
    catch(error) {
      Navigator.pop(context);
      showAlertDialog(context, 'Get User: ' + error.toString());
    }
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: Column(
        children: [
          SizedBox(
            height: 250,
              width: 250,
              child: CircularProgressIndicator()),
          Container(margin: EdgeInsets.only(left: 7), child:Text("Loading..." )),
        ],),
    );

    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert, onWillPop: () => Future.value(false));
      },
    );
  }

Widget _entryField(String title, TextEditingController controller,
    {bool isPassword = false}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
            controller: controller,
            obscureText: isPassword,
            textInputAction: TextInputAction.next,
            textCapitalization: isPassword == true ? TextCapitalization.none : TextCapitalization.characters,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true))
      ],
    ),
  );
}

showAlertDialog(BuildContext context, String _message) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
      FocusScope.of(context).requestFocus(new FocusNode());
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("แจ้งเตือน"),
    content: Text(_message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget _submitButton() {
  return InkWell(
    onTap: () {
      if(compValue == null || txtUsername.text == '' || txtPassword.text == ''){
        return globals.showAlertDialog('แจ้งเตือน', 'โปรดกรอกข้อมูล', context);
      }

      getUser(compValue.compCode, txtUsername.text, txtPassword.text);
      //Navigator.pop(context);
      print("Username: " + txtUsername?.text + " Password: " + txtPassword?.text);
    },
    child: Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 2,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)]
  )
              ),
      child: Text(
        'เข้าสู่ระบบ',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}

Widget _divider() {
  return Container(
    width: 500,
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
        ),
        Text('or'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    ),
  );
}

Widget _createAccountLabel() {
  return InkWell(
    // onTap: () {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => SignUpPage()));
    // },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Text(
      //       'Don\'t have an account ?',
      //       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      //     ),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Text(
      //       'Register',
      //       style: TextStyle(
      //           color: Color(0xfff79c4f),
      //           fontSize: 13,
      //           fontWeight: FontWeight.w600),
      //     ),
      //   ],
      // ),
    ),
  );
}

// Widget _title() {
//   return RichText(
//     textAlign: TextAlign.center,
//     text: TextSpan(
//         text: 'd',
//         style: GoogleFonts.portLligatSans(
//           textStyle: Theme.of(context).textTheme.display1,
//           fontSize: 30,
//           fontWeight: FontWeight.w700,
//           color: Color(0xffe46b10),
//         ),
//         children: [
//           TextSpan(
//             text: 'ev',
//             style: TextStyle(color: Colors.black, fontSize: 30),
//           ),
//           TextSpan(
//             text: 'rnz',
//             style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
//           ),
//         ]),
//   );
// }

Widget _title() {
  return Image(
    height: 300,
    image: AssetImage('assets/bisgroup_logo_contrast.png'),
  );
}

Widget _emailPasswordWidget() {
  return Container(
    width: MediaQuery
        .of(context)
        .size
        .width / 2,
    child: Column(
      children: <Widget>[
        _entryField("Username :", txtUsername),
        _entryField("Password :", txtPassword, isPassword: true),
      ],
    ),
  );
}

Widget _companySelect() {
  return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 2,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Company :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<Company>(
                value: compValue,
                isExpanded: true,
                items: companys.map((Company value) {
                  return DropdownMenuItem<Company>(
                    value: value,
                    child: Text(value.compName),
                  );
                }).toList(),
                onChanged: (Company value) {
                  setState(() {
                    compValue = value;
                    FocusScope.of(context).requestFocus(new FocusNode());
                    print(compValue.compCode);
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true)
            )
          ]));
}}
