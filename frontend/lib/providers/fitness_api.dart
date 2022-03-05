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
  List<LineChartBarData> _walkLineChartBarData;
  List<LineChartBarData> _hikeLineChartBarData;
  List<LineChartBarData> _rideLineChartBarData;

  List<LineChartBarData> get runLineChartBarData => _runLineChartBarData;

  set runLineChartBarData(List<LineChartBarData> runLineChartBarData) {
    _runLineChartBarData = runLineChartBarData;
  }

  DashboardInfo get dashboardInfo => _dashboardInfo;

  set dashboardInfo(DashboardInfo dashboardInfo) {
    _dashboardInfo = dashboardInfo;
  }




  Future<http.Response> getDashboardInfo() async {
    final idToken = await _user.getIdToken();
    final stravaTokens = await _stravaFitbitProvider.getStravaTokens();
    final fitbitTokens = await _stravaFitbitProvider.getFitbitTokens();

    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken,
      "stravaAccessToken": stravaTokens['stravaAccessToken'],
      "stravaRefreshToken": stravaTokens['stravaRefreshToken'],
      "fitbitAccessToken": fitbitTokens['fitbitAccessToken'],
      "fitbitRefreshToken": fitbitTokens['fitbitRefreshToken']
    });
    return response;
  }

  Future<http.Response> getStepsInfo() async {
    final idToken = await _user.getIdToken();
    final stravaTokens = await _stravaFitbitProvider.getStravaTokens();
    final fitbitTokens = await _stravaFitbitProvider.getFitbitTokens();

    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard/steps_chart"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken,
      "stravaAccessToken": stravaTokens['stravaAccessToken'],
      "stravaRefreshToken": stravaTokens['stravaRefreshToken'],
      "fitbitAccessToken": fitbitTokens['fitbitAccessToken'],
      "fitbitRefreshToken": fitbitTokens['fitbitRefreshToken']
    });
    return response;
  }

  Future<http.Response> getActivitiesAverages() async {
    final idToken = await _user.getIdToken();
    final stravaTokens = await _stravaFitbitProvider.getStravaTokens();
    final fitbitTokens = await _stravaFitbitProvider.getFitbitTokens();

    final http.Response response =
        await http.get(Uri.parse("$baseUrl/dashboard/activities_average"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken,
      "stravaAccessToken": stravaTokens['stravaAccessToken'],
      "stravaRefreshToken": stravaTokens['stravaRefreshToken'],
      "fitbitAccessToken": fitbitTokens['fitbitAccessToken'],
      "fitbitRefreshToken": fitbitTokens['fitbitRefreshToken']
    });
    return response;
  }
}
