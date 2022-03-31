import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/models/dashboard_info.dart';
import 'package:frontend/providers/strava_fitbit.dart';
import 'package:frontend/secret.dart';
import 'package:http/http.dart' as http;

import '../models/steps_data.dart';

class FitnessInfoProvider {
  final _user = FirebaseAuth.instance.currentUser;

  DashboardInfo dashboardInfo;
  List<LineChartBarData> runLineChartBarData;
  List<LineChartBarData> rideLineChartBarData;
  List<LineChartBarData> walkLineChartBarData;
  List<LineChartBarData> hikeLineChartBarData;
  List<LineChartBarData> caloriesLineChartBarData;
  List<LineChartBarData> weightLineChartBarData;
  double runAverage;
  double rideAverage;
  double walkAverage;
  double hikeAverage;
  List<StepsData> stepsData;
  int stepsAverage;
  int caloriesAverage;
  double weightAverage;

  void setValues(List<LineChartBarData> runLineChartData, List<LineChartBarData> rideLineChartData,
                List<LineChartBarData> walkLineChartData, List<LineChartBarData> hikeLineChartData,
                List<LineChartBarData> caloriesLineChartData, List<LineChartBarData> weightLineChartData,
                double runAverage, double rideAverage, double walkAverage, double hikeAverage,
                List<StepsData> stepsData, int stepsAverage, int caloriesAverage, double weightAverage){
     runLineChartBarData = runLineChartData;
     rideLineChartBarData = rideLineChartData;
     walkLineChartBarData = walkLineChartData;
     hikeLineChartBarData = hikeLineChartData;
     caloriesLineChartBarData = caloriesLineChartData;
     weightLineChartBarData = weightLineChartData;
     this.runAverage = double.parse(runAverage.toStringAsFixed(2));
     this.rideAverage = double.parse(rideAverage.toStringAsFixed(2));
     this.walkAverage = double.parse(walkAverage.toStringAsFixed(2));
     this.hikeAverage = double.parse(hikeAverage.toStringAsFixed(2));
     this.stepsData = stepsData;
     this.stepsAverage = stepsAverage;
     this.caloriesAverage = caloriesAverage;
     this.weightAverage = weightAverage;
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
        await http.get(Uri.parse("$baseUrl/dashboard/steps_info"), headers: {
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

  Future<void> fetchInfo() async {
    List<http.Response> responses = await Future.wait([
      this.getDashboardInfo(),
      this.getActivitiesAverages(),
      this.getCaloriesInfo(),        
      this.getWeightstInfo(),
      this.getStepsInfo()
    ]);
    if(responses.every((response) => response.statusCode == 200)){
      
      Map<String, dynamic> dashboardData = jsonDecode(responses[0].body);
      Map<String, dynamic> activitiesAveragesData = jsonDecode(responses[1].body);
      Map<String, dynamic> caloriesData = jsonDecode(responses[2].body);
      Map<String, dynamic> weightData = jsonDecode(responses[3].body);
      Map<String, dynamic> stepsInfo = jsonDecode(responses[4].body);

      this.dashboardInfo = DashboardInfo.fromJson(dashboardData);
      
      final List<double> runValues = activitiesAveragesData['average_speed_list']['runs_averages'].cast<double>();
      final List<double> rideValues = activitiesAveragesData['average_speed_list']['rides_averages'].cast<double>();
      final List<double> walkValues = activitiesAveragesData['average_speed_list']['walks_averages'].cast<double>();
      final List<double> hikeValues = activitiesAveragesData['average_speed_list']['hikes_averages'].cast<double>();
      double rideAverage = activitiesAveragesData['average_for_activity']['rides_average'];
      double runAverage = activitiesAveragesData['average_for_activity']['runs_average'];
      double walkAverage = activitiesAveragesData['average_for_activity']['walks_average'];
      double hikeAverage = activitiesAveragesData['average_for_activity']['hikes_average'];

      final List<double> caloriesValues = (caloriesData['calories_burned_list'] as List).map((dict) => double.parse(dict['value'])).toList().cast<double>();
      final int caloriesAverage = caloriesData['calories_burned_average'].round();
      
      final List<double> weightsValues = (weightData['weight_dates_info'] as List).map((value) => double.parse(value.toStringAsFixed(2))).toList().cast<double>();
      final double weightAverage = double.parse(weightData['weights_average'].toStringAsFixed(2));

      List<StepsData> stepsParsed = List<StepsData>.from(stepsInfo['steps'].map((i) => StepsData.fromJson(i)));
      int stepsAverage = stepsInfo['steps_average'].round();

      this.setValues(
                      this.parseLineChartData(runValues),
                      this.parseLineChartData(rideValues),
                      this.parseLineChartData(walkValues),
                      this.parseLineChartData(hikeValues),
                      this.parseLineChartData(caloriesValues),
                      this.parseLineChartData(weightsValues),
                      runAverage, rideAverage, walkAverage, hikeAverage, stepsParsed, stepsAverage, caloriesAverage, weightAverage);
      
    }
  }

}
