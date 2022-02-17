import 'dart:async';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:frontend/secret.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/strava.dart';

class StravaFitbitProvider{

  String _fitbitUserId;

  Future connectToFitbit(BuildContext context) async {
    _fitbitUserId = await FitbitConnector.authorize(
                context: context,
                clientID: fitbitOauth,
                clientSecret: fitbitClientSecret,
                redirectUri: fitbitRedirectUrl,
                callbackUrlScheme: "com.example.frontend");
  }

  Future connectToStrava() async {
    Strava strava = new Strava(true, stravaSecret);
    await strava.oauth(stravaClientId, "activity:read_all", stravaSecret, "auto");
  }

  Future<Map<String, dynamic>> getFitbitTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTokenValid = await FitbitConnector.isTokenValid();
    if(!isTokenValid){
      FitbitConnector.refreshToken(userID:_fitbitUserId, clientID:fitbitOauth, clientSecret:fitbitClientSecret);
    }
    String fitbitAccessToken = prefs.getString("fitbitAccessToken");
    String fitbitRefreshToken = prefs.getString("fitbitRefreshToken");
    return {"fitbitAccessToken":fitbitAccessToken, "fitbitRefreshToken":fitbitRefreshToken};
  }

  Future<Map<String, dynamic>> getStravaTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String stravaAccessToken = prefs.getString("strava_accessToken");
    final String stravaRefreshToken = prefs.getString("strava_refreshToken");
    return {"stravaAccessToken":stravaAccessToken, "stravaRefreshToken":stravaRefreshToken};
  }

}