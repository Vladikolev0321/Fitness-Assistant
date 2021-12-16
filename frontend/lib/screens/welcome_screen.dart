import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:frontend/google_sign_in_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/strava.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


import '../secret.dart';
import 'logged_in_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Spacer(flex:1),
                Image.asset("assets/chatbot.png",width:300,height:300),
                Spacer(flex:1),
                Text(
                "Welcome to my \nfitness assistant app",
                style: 
                  Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              
              Spacer(flex: 1),
                Container(
                  child: SignInButton(
                    
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () => signInWithGoogle(context),
                    
                  ),
                ),
                Spacer(flex: 1,)
              ],
            ),
          ),
        
      ),
    );
  }
}


Future signInWithGoogle(BuildContext context) async{
  final user = await GoogleSignInApi.login();

if(user != null){
  
    print(user.email);
    print(user.displayName);
    print(user.id);
    
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoggedInPage(user: user),
      ));
  }else{

  }

  
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