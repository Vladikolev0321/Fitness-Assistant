import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart';
import 'package:frontend/providers/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    // Text(
    //   'Index 0: Dashboard',
    // ),
    DashBoard(),
    ChatBody(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(child: Text(user.email), onPressed: (){
          final provider = Provider.of<GoogleSignInProvider>(context, listen:false);
          provider.logout();
        },)
        //_widgetOptions.elementAt(_selectedIndex),

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
    ],
    currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[600],
        onTap: _onItemTapped,
  ),
  
    );
  }
}