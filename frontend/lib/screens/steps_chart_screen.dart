import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/steps_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:frontend/widgets/steps_chart.dart';
import 'package:provider/provider.dart';

import '../providers/fitness_api.dart';

class StepsChartScreen extends StatefulWidget {
  StepsChartScreen({ Key key }) : super(key: key);

  @override
  State<StepsChartScreen> createState() => _StepsChartScreenState();
}

class _StepsChartScreenState extends State<StepsChartScreen> {

  @override
  Widget build(BuildContext context) {  
    final stepsAverage = Provider.of<FitnessInfoProvider>(context, listen: false).stepsAverage;
    List<StepsData> data = Provider.of<FitnessInfoProvider>(context, listen: false).stepsData;

    return Scaffold(
      appBar: AppBar(),
      body: data == null
        ? Center(child: CircularProgressIndicator())
        : Column(
          children: [
            StepsChart(data: data),
            SizedBox(height: 10.0),
            Container(
              height: 50,
              child: Card(
                child: Center(child: Text("Your average steps done are $stepsAverage"))
              ),
            ),
          ],
        )
      );
  }

   @override
  void initState() {
    super.initState();
  }
}