import 'package:flutter/material.dart';
import 'package:ismart_crm/models/product_cart.dart';
import 'package:ismart_crm/src/loginPage.dart';
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  ApiService _apiService = new ApiService();

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', null);
    prefs.setString('company', null);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Smart Sales BIS',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/bg_02.jpg'))),
          ),
          // ListTile(
          //   leading: Icon(Icons.refresh),
          //   title: Text('Refresh'),
          //   onTap: () {
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Sale Order'),
            onTap: () => {},
          ),
          // ListTile(
          //   leading: Icon(Icons.monetization_on),
          //   title: Text('Commission'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          ListTile(
            leading: Icon(Icons.people_alt),
            title: Text('Customers'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              globals.customer = null;
              globals.allCustomer = null;
              globals.selectedShipto = null;
              globals.allShipto = null;
              globals.selectedProduct = null;
              globals.productCart = new List<ProductCart>();
              globals.allProduct = null;
              globals.editingProductCart = null;
              logout();

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}