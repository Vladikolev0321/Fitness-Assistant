import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/dashboard_info.dart';
import 'package:frontend/providers/fitness_api.dart';
import 'package:frontend/screens/activities_screen.dart';
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
                    GestureDetector(
                      onTap: (){
                         Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ActivityScreen()));
                      },
                      child: ActivityPieChart(
                        runSection: dashboardInfo.runPercentage,
                        rideSection: dashboardInfo.ridePercentage,
                        walkSection: dashboardInfo.walkPercentage,
                        hikeSection: dashboardInfo.hikePercentage,
                        runDistance: dashboardInfo.runDistance,
                        rideDistance: dashboardInfo.rideDistance,
                        walkDistance: dashboardInfo.walkDistance,
                        hikeDistance: dashboardInfo.hikeDistance,
                      ),
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
                                  child: Row(
                                    children: [
                                      Text(
                                        'Calories Burned',
                                      ),
                                    ],
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
      await _getActivityAverages();
      setState(() {
        Provider.of<FitnessInfoProvider>(context, listen: false).dashboardInfo = DashboardInfo.fromJson(data);
        _isLoading = false;
      });
    }
  }


  Future<void> _getActivityAverages() async{
    final response = await Provider.of<FitnessInfoProvider>(context, listen: false).getActivitiesAverages();
    if(response.statusCode == 200){
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<double> runValues = responseBody['average_speed_list']['runs_average'].cast<double>();
      final List<double> rideValues = responseBody['average_speed_list']['rides_average'].cast<double>();
      final List<double> walkValues = responseBody['average_speed_list']['walks_average'].cast<double>();
      final List<double> hikeValues = responseBody['average_speed_list']['hikes_average'].cast<double>();
      

      Provider.of<FitnessInfoProvider>(context, listen: false).setValues(
                              Provider.of<FitnessInfoProvider>(context, listen: false).parseLineChartData(runValues),
                              Provider.of<FitnessInfoProvider>(context, listen: false).parseLineChartData(rideValues),
                              Provider.of<FitnessInfoProvider>(context, listen: false).parseLineChartData(walkValues),
                              Provider.of<FitnessInfoProvider>(context, listen: false).parseLineChartData(hikeValues));
    
    }
  }
}
