import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:frontend/providers/google_sign_in.dart';

import 'connect_to_apis_screen.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _seen;
  Future<bool> checkIfFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _seen
                  ? HomePage()
                  : ConnectToApisScreen(
                      setSeen: () {
                        setState(() {
                          _seen = true;
                        });
                      },
                    );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            } else {
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Spacer(flex: 1),
                      Image.asset("assets/chatbot.png",
                          width: 300, height: 300),
                      Spacer(flex: 1),
                      Text(
                        "Welcome to my \nfitness assistant app",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(flex: 1),
                      Container(
                        child: SignInButton(Buttons.Google,
                            text: "Sign up with Google", onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.googleLogin();
                        }),
                      ),
                      Spacer(
                        flex: 1,
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    checkIfFirstSeen().then((value) {
      _seen = value;
    });
  }
}
