import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/strava_fitbit.dart';
import 'package:frontend/secret.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FitnessInfoProvider{

    final _user = FirebaseAuth.instance.currentUser;
    StravaFitbitProvider _stravaFitbitProvider;

    FitnessInfoProvider(this._stravaFitbitProvider);

    Future<http.Response> getDashboardInfo()async {
       final idToken = await _user.getIdToken();
      final stravaTokens = await _stravaFitbitProvider.getStravaTokens();
      final fitbitTokens = await _stravaFitbitProvider.getFitbitTokens();

      final http.Response response = await http.get(Uri.parse("$baseUrl/dashboard"),
                           headers: {'Content-type': 'application/json', "Authorization":idToken,
                          "stravaAccessToken":stravaTokens['stravaAccessToken'], "stravaRefreshToken":stravaTokens['stravaRefreshToken'],
                           "fitbitAccessToken":fitbitTokens['fitbitAccessToken'],"fitbitRefreshToken":fitbitTokens['fitbitRefreshToken']});
      return response;
    }
}