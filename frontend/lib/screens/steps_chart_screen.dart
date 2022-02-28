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
  List<StepsData> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: data == null
        ? Center(child: CircularProgressIndicator()) : StepsChart(data: data)
      );
  }

   @override
  void initState() {
    super.initState();
    _getStepsChartInfo();
  }

  Future<void> _getStepsChartInfo() async{
    final response = await Provider.of<FitnessInfoProvider>(context, listen: false).getStepsInfo();
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    setState(() {
      data = List<StepsData>.from(responseBody['steps'].map((i) => StepsData.fromJson(i)));
    });
  }
}