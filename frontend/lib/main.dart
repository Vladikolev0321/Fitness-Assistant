import 'package:flutter/material.dart';
import 'package:frontend/providers/fitness_api.dart';
import 'package:frontend/providers/strava_fitbit.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'providers/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt locator = GetIt.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(prefs);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(create: (context) => GoogleSignInProvider()),
        Provider<StravaFitbitProvider>(create: (context) => StravaFitbitProvider()),
        ProxyProvider<StravaFitbitProvider, FitnessInfoProvider>(
          update: (context, stravaFitbit, _) => FitnessInfoProvider(stravaFitbit),
          )
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Fitness Assistant",
          home: WelcomeScreen()
        ),
    );
  }
}

