import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/dashboard_info.dart';
import 'package:frontend/providers/fitness_api.dart';
import 'package:frontend/screens/steps_chart_screen.dart';
import 'package:frontend/widgets/pie_chart.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key,}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = false;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    DashboardInfo dashboardInfo = Provider.of<FitnessInfoProvider>(context, listen: false).dashboardInfo;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _getDashboardInfo,
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      //padding: EdgeInsets.only(left: 20),
                      child: Center(
                        child: Text(
                          "Hello, ${_user.displayName}",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ActivityPieChart(
                      runSection: dashboardInfo.runPercentage,
                      rideSection: dashboardInfo.ridePercentage,
                      walkSection: dashboardInfo.walkPercentage,
                      hikeSection: dashboardInfo.hikePercentage,
                      runDistance: dashboardInfo.runDistance,
                      rideDistance: dashboardInfo.rideDistance,
                      walkDistance: dashboardInfo.walkDistance,
                      hikeDistance: dashboardInfo.hikeDistance,
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StepsChartScreen()));
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      dashboardInfo.stepsCount.toString(),
                                    ),
                                    trailing: Icon(
                                      FontAwesomeIcons.walking,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Steps',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 100,
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  title: Text(dashboardInfo.caloriesBurned.toString()),
                                  trailing: Icon(
                                    FontAwesomeIcons.fire,
                                    color: Colors.red,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Calories Burned',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 100,
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  title: Text(dashboardInfo.weight.toString()),
                                  trailing: Icon(
                                    FontAwesomeIcons.weight,
                                    color: Colors.blue,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Current weight',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          );
  }

  @override
  void initState() {
    super.initState();
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
