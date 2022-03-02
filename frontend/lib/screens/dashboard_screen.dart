import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/providers/fitness_api.dart';
import 'package:frontend/screens/steps_chart_screen.dart';
import 'package:frontend/widgets/pie_chart.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
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
  Dashboard(
      {Key key,
      this.stepsCount,
      this.caloriesBurned,
      this.runPercentage,
      this.ridePercentage,
      this.walkPercentage,
      this.hikePercentage,
      this.runDistance,
      this.rideDistance,
      this.walkDistance,
      this.hikeDistance,
      this.weight})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = false;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
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
                      runSection: widget.runPercentage,
                      rideSection: widget.ridePercentage,
                      walkSection: widget.walkPercentage,
                      hikeSection: widget.hikePercentage,
                      runDistance: widget.runDistance,
                      rideDistance: widget.rideDistance,
                      walkDistance: widget.walkDistance,
                      hikeDistance: widget.hikeDistance,
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
                                      widget.stepsCount.toString(),
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
                                  title: Text(widget.caloriesBurned.toString()),
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
                                  title: Text(widget.weight.toString()),
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
    //_getDashboardInfo();
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
      print(data);
    });
    setState(() {
      /// Check if contains keys
      widget.stepsCount = int.parse(data['steps']);
      widget.caloriesBurned = int.parse(data['burnt_calories']);
      widget.runPercentage = data['percentages']['run_distance_percentage'];
      widget.ridePercentage = data['percentages']['ride_distance_percentage'];
      widget.walkPercentage = data['percentages']['walk_distance_percentage'];
      widget.hikePercentage = data['percentages']['hike_distance_percentage'];
      widget.runDistance = data['distances']['run_distance'];
      widget.rideDistance = data['distances']['ride_distance'];
      widget.walkDistance = data['distances']['walk_distance'];
      widget.hikeDistance = data['distances']['hike_distance'];
      widget.weight = double.parse(data['weight'].toStringAsFixed(2));
      _isLoading = false;
    });
  }
}
