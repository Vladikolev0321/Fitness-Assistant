import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/providers/strava_fitbit.dart';
import 'package:frontend/secret.dart';
import 'package:http/http.dart' as http;

class Messages{

  final _user = FirebaseAuth.instance.currentUser;
    StravaFitbitProvider _stravaFitbitProvider;

    Messages(this._stravaFitbitProvider);

    Future<String> message(String message) async {
      final idToken = await _user.getIdToken();
      final stravaTokens = await _stravaFitbitProvider.getStravaTokens();
      final fitbitTokens = await _stravaFitbitProvider.getFitbitTokens();

      http.Client client = getClient();
      final response = await client.post(Uri.parse("$baseUrl/bot/message"),
        headers: {'Content-type': 'application/json', "Authorization":idToken,
        "stravaAccessToken":stravaTokens['stravaAccessToken'], "stravaRefreshToken":stravaTokens['stravaRefreshToken'],
        "fitbitAccessToken":fitbitTokens['fitbitAccessToken'],"fitbitRefreshToken":fitbitTokens['fitbitRefreshToken']},
        body: json.encode({"message": message}),
      );

        Map<String, dynamic> data = jsonDecode(response.body);
        return data['response'];
    }

    http.Client getClient(){
      return http.Client();
    }

}