
import 'package:flutter/material.dart';
import 'package:frontend/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fitness Assistant",
      home: WelcomeScreen()
    );
  }
}

