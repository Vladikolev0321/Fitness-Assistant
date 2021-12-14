import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:frontend/google_sign_in._api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/strava.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../secret.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SignInButton(
                  Buttons.Google,
                  text: "Sign up with Google",
                  onPressed: signInWithGoogle,
                ),
              ],
            ),
          ),
        
      ),
    );
  }
}


Future signInWithGoogle() async{
  final user = await GoogleSignInApi.login();
  print(user.email);
}

class ConnectionWithApis extends StatelessWidget {
  const ConnectionWithApis({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton(
            child: Text("Connect to Fitbit"),
            onPressed: () async {
              String userId = await FitbitConnector.authorize(
                context: context,
                clientID: fitbitOauth,
                clientSecret: fitbitClientSecret,
                redirectUri: fitbitRedirectUrl,
                callbackUrlScheme: "com.example.frontend");
                print(userId);

                // print(GetIt.instance<SharedPreferences>().getString("fitbitAccessToken"));
                // print(GetIt.instance<SharedPreferences>().getString("fitbitRefreshToken"));
                
                
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String fitbitAccessToken = prefs.getString("fitbitAccessToken");
                String fitbitRefreshToken = prefs.getString("fitbitRefreshToken");
                // print(fitbitAccessToken);
                // print(fitbitRefreshToken);
            },
          ),
          TextButton(
          child: Text("Connect to Strava"),
          onPressed: () async {
            Strava strava = new Strava(true, stravaSecret);
           // strava.
            strava.oauth(stravaClientId, "activity:read", stravaSecret, "auto");

        },
      ),
        ],
      ),
     
    );
  }
}