import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/strava_fitbit.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
     body: Center(
       child: Container(
         alignment: Alignment.center,
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              Text(
              "Connect to apps",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
           ),
               SizedBox(height: 50),
               TextButton(
                 child: Text("Connect to Fitbit"),
                 onPressed: () async {
                  await Provider.of<StravaFitbitProvider>(context, listen: false).connectToFitbit(context);
                },
              ),
              TextButton(
              child: Text("Connect to Strava"),
              onPressed: () async {
                await Provider.of<StravaFitbitProvider>(context, listen: false).connectToStrava();
            },
        ),
        TextButton(
            child: Text("Continue"),
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final stravaTokens = await Provider.of<StravaFitbitProvider>(context, listen: false).getStravaTokens();
              final fitbitTokens = await Provider.of<StravaFitbitProvider>(context, listen: false).getFitbitTokens();
              if(stravaTokens['stravaAccessToken'] != null && stravaTokens['stravaRefreshToken'] != null && fitbitTokens['fitbitAccessToken'] != null && fitbitTokens['fitbitRefreshToken'] != null){
                final response = await Provider.of<StravaFitbitProvider>(context, listen: false).sendTokens(stravaTokens, fitbitTokens);
                if(response.statusCode == 200){
                  prefs.setBool('seen', true);
                  widget.setSeen();
                  print("here");
                }
                //if(response)
              } else {
                showAlert(context);
              }
            },
        )
             ],
           ),
         )
    ),
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