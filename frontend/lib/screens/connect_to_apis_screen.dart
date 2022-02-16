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

class ConnectToApisScreen extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;
  final Function setSeen;

  ConnectToApisScreen({
    Key key,
     this.setSeen }) : super(key: key);
    

  @override
  _ConnectToApisScreenState createState() => _ConnectToApisScreenState();
}

class _ConnectToApisScreenState extends State<ConnectToApisScreen> {


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
            strava.oauth(stravaClientId, "activity:read_all", stravaSecret, "auto");
        },
      ),
      TextButton(
        child: Text("Continue"),
        onPressed: () async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final String stravaAccessToken = prefs.getString("strava_accessToken");
          final String stravaRefreshToken = prefs.getString("strava_refreshToken");
          final String fitbitAccessToken = prefs.getString("fitbitAccessToken");
          final String fitbitRefreshToken = prefs.getString("fitbitRefreshToken");
          if(stravaAccessToken != null && stravaRefreshToken != null && fitbitAccessToken != null && fitbitRefreshToken != null){
            prefs.setBool('seen', true);
            widget.setSeen();
          } else {
            showAlert(context);
          }
        },
      )
         ],
       )
    ),
     
  );
  }
}

showAlert(BuildContext context) {  
  AlertDialog alert = AlertDialog(  
    title: Text("Connection to APIs alert"),  
    content: Text("Connect to APIs before proceeding"),  
    actions: [  
      TextButton(  
      child: Text("OK"),  
      onPressed: () {  
        Navigator.of(context).pop();  
      },  
      )
    ] 
  );  

  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  