import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int stepsCount = 0;
  int caloriesBurned = 0;
  double runPercentage = 0;
  double ridePercentage = 0;
  double walkPercentage = 0;
  double hikePercentage = 0;
  int runDistance = 0;
  int rideDistance = 0;
  int walkDistance = 0;
  int hikeDistance = 0;
  double weight = 0;
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
    Dashboard(
      stepsCount: stepsCount,
      caloriesBurned: caloriesBurned,
      runPercentage: runPercentage ,
      ridePercentage: ridePercentage,
      walkPercentage: walkPercentage,
      hikePercentage: hikePercentage,
      runDistance: runDistance,
      rideDistance: rideDistance,
      walkDistance: walkDistance,
      hikeDistance: hikeDistance,
      weight: weight,
    ),
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
    Map<String, dynamic> data;
    await Provider.of<FitnessInfoProvider>(context, listen: false)
        .getDashboardInfo()
        .then((response) {
      data = jsonDecode(response.body);
    });
    setState(() {
      /// Check if contains keys
      stepsCount = int.parse(data['steps']);
      caloriesBurned = int.parse(data['burnt_calories']);
      runPercentage = data['percentages']['run_distance_percentage'];
      ridePercentage = data['percentages']['ride_distance_percentage'];
      walkPercentage = data['percentages']['walk_distance_percentage'];
      hikePercentage = data['percentages']['hike_distance_percentage'];
      runDistance = data['distances']['run_distance'];
      rideDistance = data['distances']['ride_distance'];
      walkDistance = data['distances']['walk_distance'];
      hikeDistance = data['distances']['hike_distance'];
      weight = double.parse(data['weight'].toStringAsFixed(2));
      _isLoading = false;
    });
  }
}