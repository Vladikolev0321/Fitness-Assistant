import 'dart:io';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:frontend/google_sign_in_api.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/strava.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';

import '../secret.dart';

class LoggedInPage extends StatelessWidget {
  final GoogleSignInAccount user;

  LoggedInPage({
    Key key,
     this.user}) : super(key: key);
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logged in"),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text('Logout'),
            onPressed: () async{
              await GoogleSignInApi.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
              ));
            },
          )
        ],
      ),
     body: Container(
       alignment: Alignment.center,
       color: Colors.blueGrey.shade700,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [

           Text(user.displayName.toString()),
           SizedBox(height: 30),
           TextButton(
             child: Text("Authrorize Fitbit"),
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
          //  // strava.
            strava.oauth(stravaClientId, "activity:read", stravaSecret, "auto");
           // strava.deAuthorize();

            // final queryParameters = {
            //   'client_id': stravaClientId,
            //   'redirect_uri': 'stravaflutter://redirect/',
            //   'response_type': 'code',
            //   'approval_prompt': 'auto',
            //   'scope': 'activity:write,read'
            // };

            // final uri = Uri.https('www.strava.com', '/oauth/mobile/authorize', queryParameters);
            // final response = await http.get(uri);
            // print(response.body);

            //             // Present the dialog to the user
            //             print(uri.toString());
            // final result = await FlutterWebAuth.authenticate(url: uri.toString(), callbackUrlScheme: "com.example.frontend");

            // // Extract token from resulting url
            // final token = Uri.parse(result).queryParameters['token'];


        },
      ),
         ],
       )),
     
    );
  }
}