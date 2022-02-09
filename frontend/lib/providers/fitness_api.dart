import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/secret.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FitnessInfoProvider{

    final _user = FirebaseAuth.instance.currentUser;

    Future<http.Response> getDashboardInfo()async {
       final idToken = await _user.getIdToken();
       SharedPreferences prefs = await SharedPreferences.getInstance();
       final String stravaAccessToken = prefs.getString("strava_accessToken");
       final String stravaRefreshToken = prefs.getString("strava_refreshToken");
       final String fitbitAccessToken = prefs.getString("fitbitAccessToken");
       final String fitbitRefreshToken = prefs.getString("fitbitRefreshToken");

       final http.Response response = await http.get(Uri.parse("$baseUrl/dashboard"),
                           headers: {'Content-type': 'application/json', "Authorization":idToken,
                          "stravaAccessToken":stravaAccessToken, "stravaRefreshToken":stravaRefreshToken,
                           "fitbitAccessToken":fitbitAccessToken,"fitbitRefreshToken":fitbitRefreshToken});
        return response;
    }
}