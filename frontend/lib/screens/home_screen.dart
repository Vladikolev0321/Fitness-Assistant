import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/dashboard_info.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/user_screen.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_api.dart';
import 'dashboard_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ChatBody(),
    UserScreen()
  ];

    return _isLoading
        ? Center(child: CircularProgressIndicator())
      : Scaffold(
      body: Center(
         child:  _widgetOptions.elementAt(_selectedIndex),

      ),
      
      bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Chat',
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.user),
        label: 'Profile',
      ),
    ],
    currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[600],
        onTap: _onItemTapped,
  ),
  
    );
  }

  @override
  void initState() {
    super.initState();
    _getDashboardInfo();
  }


  Future<void> _getDashboardInfo() async {
    setState(() {
      _isLoading = true;
    });
    
    final response = await Provider.of<FitnessInfoProvider>(context, listen: false).getDashboardInfo();
    if(response.statusCode == 200){
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        Provider.of<FitnessInfoProvider>(context, listen: false).dashboardInfo = DashboardInfo.fromJson(data);
        _isLoading = false;
      });
    }
  }
}