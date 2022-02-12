import 'package:flutter/material.dart';
import 'package:frontend/providers/fitness_api.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/google_sign_in.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(create: (context) => GoogleSignInProvider()),
        Provider<FitnessInfoProvider>(create: (context) => FitnessInfoProvider())
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Fitness Assistant",
          home: WelcomeScreen()
        ),
    );
  }
}

