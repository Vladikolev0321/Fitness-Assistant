import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/models/dashboard_info.dart';
import 'package:frontend/providers/strava_fitbit.dart';
import 'package:frontend/secret.dart';
import 'package:http/http.dart' as http;

class FitnessInfoProvider {
  final _user = FirebaseAuth.instance.currentUser;
  StravaFitbitProvider _stravaFitbitProvider;

  FitnessInfoProvider(this._stravaFitbitProvider);

  DashboardInfo _dashboardInfo;
  List<LineChartBarData> _runLineChartBarData;
  List<LineChartBarData> _rideLineChartBarData;
  List<LineChartBarData> _walkLineChartBarData;
  List<LineChartBarData> _hikeLineChartBarData;
  List<LineChartBarData> _caloriesLineChartBarData;
  List<LineChartBarData> _weightLineChartBarData;

  List<LineChartBarData> get weightLineChartBarData => _weightLineChartBarData;

  set weightLineChartBarData(List<LineChartBarData> weightLineChartBarData) {
    _weightLineChartBarData = weightLineChartBarData;
  }

  List<LineChartBarData> get caloriesLineChartBarData => _caloriesLineChartBarData;

  set caloriesLineChartBarData(List<LineChartBarData> caloriesLineChartBarData) {
    _caloriesLineChartBarData = caloriesLineChartBarData;
  }

  List<LineChartBarData> get walkLineChartBarData => _walkLineChartBarData;

  set walkLineChartBarData(List<LineChartBarData> walkLineChartBarData) {
    _walkLineChartBarData = walkLineChartBarData;
  }

  List<LineChartBarData> get hikeLineChartBarData => _hikeLineChartBarData;

  set hikeLineChartBarData(List<LineChartBarData> hikeLineChartBarData) {
    _hikeLineChartBarData = hikeLineChartBarData;
  }

  List<LineChartBarData> get rideLineChartBarData => _rideLineChartBarData;

  set rideLineChartBarData(List<LineChartBarData> rideLineChartBarData) {
    _rideLineChartBarData = rideLineChartBarData;
  }

  List<LineChartBarData> get runLineChartBarData => _runLineChartBarData;

  set runLineChartBarData(List<LineChartBarData> runLineChartBarData) {
    _runLineChartBarData = runLineChartBarData;
  }

  DashboardInfo get dashboardInfo => _dashboardInfo;

  set dashboardInfo(DashboardInfo dashboardInfo) {
    _dashboardInfo = dashboardInfo;
  }


  void setValues(List<LineChartBarData> runLineChartData, List<LineChartBarData> rideLineChartData,
   List<LineChartBarData> walkLineChartData, List<LineChartBarData> hikeLineChartData, List<LineChartBarData> caloriesLineChartData,
   List<LineChartBarData> weightLineChartData){
     runLineChartBarData = runLineChartData;
     rideLineChartBarData = rideLineChartData;
     walkLineChartBarData = walkLineChartData;
     hikeLineChartBarData = hikeLineChartData;
     caloriesLineChartBarData = caloriesLineChartData;
     weightLineChartBarData = weightLineChartData;
  }



  Future<http.Response> getDashboardInfo() async {
    final idToken = await _user.getIdToken();

    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken
    });
    return response;
  }

  Future<http.Response> getStepsInfo() async {
    final idToken = await _user.getIdToken();

    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard/steps_chart"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken
    });
    return response;
  }

  Future<http.Response> getActivitiesAverages() async {
    final idToken = await _user.getIdToken();

    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard/activities_average"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken
    });
    return response;
  }

  Future<http.Response> getCaloriesInfo() async {
    final idToken = await _user.getIdToken();
    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard/calories_info"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken
    });
    return response;
  }

  Future<http.Response> getWeightstInfo() async {
    final idToken = await _user.getIdToken();
    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard/weight_info"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken
    });
    return response;
  }

  List<LineChartBarData> parseLineChartData(List<double> yValues){
    List<FlSpot> spots =  yValues.asMap().entries.map((e) {
         return FlSpot(e.key.toDouble()+1, e.value);
      }).toList();
      
    List<Color> lineColor = [
        Color(0xfff3f169),
    ];

    List<LineChartBarData> lineChartBarData = [
      LineChartBarData(
        colors: lineColor,
        isCurved: true,
        spots: spots
      )
    ];

    return lineChartBarData;

  }
}
