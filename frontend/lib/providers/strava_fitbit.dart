import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:frontend/secret.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/strava.dart';
import 'package:http/http.dart' as http;

class StravaFitbitProvider{

  String _fitbitUserId;
  bool areStoredTokens = false;

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

  Future<http.Response> sendTokens(Map<String, dynamic> stravaTokens, Map<String, dynamic> fitbitTokens) async {
    final _user = FirebaseAuth.instance.currentUser;
    final idToken = await _user.getIdToken();
    final http.Response response =
        await http.post(Uri.parse("$baseUrl/tokens"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken,
      "stravaAccessToken": stravaTokens['stravaAccessToken'],
      "stravaRefreshToken": stravaTokens['stravaRefreshToken'],
      "fitbitAccessToken": fitbitTokens['fitbitAccessToken'],
      "fitbitRefreshToken": fitbitTokens['fitbitRefreshToken']
    });

    return response;
  }

  Future<void> checkIfStoredTokens() async {
    final _user = FirebaseAuth.instance.currentUser;
    final idToken = await _user.getIdToken();
    final http.Response response =
        await http.get(Uri.parse("$baseUrl/tokens"), headers: {
      'Content-type': 'application/json',
      "Authorization": idToken
    });

    Map<String, dynamic> result = jsonDecode(response.body);
    if(result['are_tokens_stored']){
      areStoredTokens = true;
    }else{
      areStoredTokens = false;
    }
  }

}