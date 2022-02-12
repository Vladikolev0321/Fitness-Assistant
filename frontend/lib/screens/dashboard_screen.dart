import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/providers/fitness_api.dart';
import 'package:frontend/providers/google_sign_in.dart';
import 'package:frontend/secret.dart';
import 'package:frontend/widgets/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _stepsCount = 0;
  int _caloriesBurned = 0;
  double _runPercentage = 0;
  double _ridePercentage = 0;
  double _walkPercentage = 0;
  double _hikePercentage = 0;
  int _runDistance = 0;
  int _rideDistance = 0;
  int _walkDistance = 0;
  int _hikeDistance = 0;
  double _weight = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                ActivityPieChart(
                  runSection: _runPercentage,
                  rideSection: _ridePercentage,
                  walkSection: _walkPercentage,
                  hikeSection: _hikePercentage,
                  runDistance: _runDistance,
                  rideDistance: _rideDistance,
                  walkDistance: _walkDistance,
                  hikeDistance: _hikeDistance,
                ),
                const SizedBox(height: 10.0),
                Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                _stepsCount.toString(),
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
                    const SizedBox(height: 10.0),
                    Container(
                      height: 100,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Text(_caloriesBurned.toString()),
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
                              title: Text(_weight.toString()),
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
            ));
  }

  @override
  void initState() {
    super.initState();
    _getDashboardInfo();
  }

  _getDashboardInfo() async {
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
      _stepsCount = int.parse(data['steps']);
      _caloriesBurned = int.parse(data['burnt_calories']);
      _runPercentage = data['percentages']['run_distance_percentage'];
      _ridePercentage = data['percentages']['ride_distance_percentage'];
      _walkPercentage = data['percentages']['walk_distance_percentage'];
      _hikePercentage = data['percentages']['hike_distance_percentage'];
      _runDistance = data['distances']['run_distance'];
      _rideDistance = data['distances']['ride_distance'];
      _walkDistance = data['distances']['walk_distance'];
      _hikeDistance = data['distances']['hike_distance'];
      _weight = double.parse(data['weight'].toStringAsFixed(2));
      _isLoading = false;
    });
  }
}
