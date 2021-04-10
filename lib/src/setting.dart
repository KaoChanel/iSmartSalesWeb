import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ismart_crm/models/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ismart_crm/globals.dart' as globals;
import 'package:ismart_crm/api_service.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  ApiService _apiService = new ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('การตั้งค่า')),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
              child: SingleChildScrollView(
                child: ListTileTheme(
                  selectedTileColor: Colors.grey.shade200,
                  selectedColor: Theme.of(context).primaryColor,
                  child: ListTile(
                    leading: Icon(Icons.widgets),
                    title: Text('การใช้งาน'),
                    selected: true,
              ),
            ),
          )),
          Expanded(
            flex: 4,
              child: SingleChildScrollView(
                child: ListTileTheme(
                  child: ListTile(
                    title: Text('แก้ไขราคาสินค้า'),
                    trailing: Switch(
                      value: globals.employee.isLockPrice == 'Y' ? true : false,
                      onChanged: (value) {
                        setState(() async {
                          Employee emp = globals.employee;
                          emp.isLockPrice == 'Y' ? 'N' : 'Y';
                          _apiService.updateEmployee(emp);
                        });
                      },
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
