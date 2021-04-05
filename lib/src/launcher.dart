import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:ismart_crm/widgets/navDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'dashboardPage.dart';
import 'reportPage.dart';
import 'newsPage.dart';
import 'employee_profile.dart';
import 'package:ismart_crm/globals.dart' as globals;

class Launcher extends StatefulWidget {
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 3;
  PageController _pageController = new PageController();
  List<Widget> _pageWidget = <Widget>[
    DashboardPage(),
    ReportPage(),
    NewsPage(),
    EmployeeProfile(),
  ];
  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Main'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart),
      title: Text('Report'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.info_outline_rounded),
      title: Text('News'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_rounded),
      title: Text('Profile'),
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text('BIS Group (${globals.allCompany?.first?.compNameEng ?? ''})')),
      ),
      body: SizedBox(
        child: PageView(
          controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
          children: [
            DoubleBackToCloseApp(
              snackBar: const SnackBar(
                duration: Duration(milliseconds: 800),
                  content: Text(
                'Tap back again to exit',
                textAlign: TextAlign.center,
              )),
              child: _pageWidget.elementAt(_selectedIndex)),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _menuBar,
        onTap: _onItemTapped,

        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
      ),
    );
  }
}
