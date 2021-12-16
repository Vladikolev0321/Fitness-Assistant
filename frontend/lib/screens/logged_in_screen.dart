import 'package:flutter/material.dart';
import 'package:frontend/google_sign_in_api.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
     // body: Text(user.displayName.toString()),
    );
  }
}