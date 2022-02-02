import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:frontend/google_sign_in_api.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/strava.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';

import '../secret.dart';

class LoggedInPage extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;

  LoggedInPage({
    Key key,
     }) : super(key: key);
    

  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {


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

           Text(widget.user.displayName.toString()),
           SizedBox(height: 30),
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

               // Fitbit

                // print(GetIt.instance<SharedPreferences>().getString("fitbitAccessToken"));
                // print(GetIt.instance<SharedPreferences>().getString("fitbitRefreshToken"));
                
                
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String fitbitAccessToken = prefs.getString("fitbitAccessToken");
                String fitbitRefreshToken = prefs.getString("fitbitRefreshToken");
                print(fitbitAccessToken);
                print(fitbitRefreshToken);
            },
          ),
          TextButton(
          child: Text("Connect to Strava"),
          onPressed: () async {
            Strava strava = new Strava(true, stravaSecret);
          //  // strava.
            strava.oauth(stravaClientId, "activity:read_all", stravaSecret, "auto");
            //strava.o
            
            //strava
          //  SharedPreferences prefs = await SharedPreferences.getInstance();
          //  print(prefs.getString("strava_accessToken"));
           // print(prefs.getString("strava_refreshToken"));
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
      // TextButton(
      //   child: Text("Continue"),
      //   onPressed: () async{
      //     final idToken = await widget.user.getIdToken();

      //     SharedPreferences prefs = await SharedPreferences.getInstance();
      //     final String stravaAccessToken = prefs.getString("strava_accessToken");
      //     final String stravaRefreshToken = prefs.getString("strava_refreshToken");
      //     final String fitbitAccessToken = prefs.getString("fitbitAccessToken");
      //     final String fitbitRefreshToken = prefs.getString("fitbitRefreshToken");
      //     print(stravaAccessToken);
      //     print(stravaRefreshToken);
      //     print(fitbitAccessToken);
      //     print(fitbitRefreshToken);
      //     if(stravaAccessToken != null && stravaRefreshToken != null && fitbitAccessToken != null && fitbitRefreshToken != null){
            
      //     //   print("here");
      //     //   final response = await http.post(Uri.parse("$baseUrl/saveTokens"), headers: {'Content-type': 'application/json', "Authorization":idToken}, body: json.encode({
      //     //     "stravaAccessToken":stravaAccessToken, "stravaRefreshToken":stravaRefreshToken, "fitbitAccessToken":fitbitAccessToken,"fitbitRefreshToken":fitbitRefreshToken}));
      //     //   print(response.body);
      //     //  // if(response.statusCode == 200){
      //     //     Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     //     builder: (context) => HomePage(),
      //     //     ));
      //    //   }
      //   // FitbitConnector.
           

      //        final response = await http.get(Uri.parse("$baseUrl/average_speed"), headers: {'Content-type': 'application/json', "Authorization":idToken, 
      //         "stravaAccessToken":stravaAccessToken, "stravaRefreshToken":stravaRefreshToken, "fitbitAccessToken":fitbitAccessToken,"fitbitRefreshToken":fitbitRefreshToken});
      //       print(response.body);



      //     }
      // },)
         ],
       )),
     
    );
  }
}