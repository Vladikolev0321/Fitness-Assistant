import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/strava_fitbit.dart';
import 'apis_connection_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  bool seen;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    seen = Provider.of<StravaFitbitProvider>(context, listen: false).areStoredTokens;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : seen
          ? HomePage()
          : ConnectToApisScreen(
              setSeen: () {
                setState(() {
                  Provider.of<StravaFitbitProvider>(context, listen: false).areStoredTokens = true;
                });
              },
            );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<StravaFitbitProvider>(context, listen: false).checkIfStoredTokens();
    setState(() {
        _isLoading = false;
    });
  }
}