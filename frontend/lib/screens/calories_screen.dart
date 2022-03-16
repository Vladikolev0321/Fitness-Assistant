import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/activity_average_data.dart';
import 'package:frontend/widgets/chart_container.dart';
import 'package:provider/provider.dart';

import '../providers/fitness_api.dart';
import '../widgets/line_chart.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({ Key key }) : super(key: key);

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  @override
  Widget build(BuildContext context) {
    final caloriesLineChartBarData = Provider.of<FitnessInfoProvider>(context, listen: false).caloriesLineChartBarData;
    final caloriesAverage = Provider.of<FitnessInfoProvider>(context, listen: false).caloriesAverage;

    return Scaffold(
      appBar: AppBar(),
      body:Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          height: 400,
            child: Column(
              children: [
                ChartContainer(
                        title: 'Calories burned for the last 10 days', 
                        color: Color.fromRGBO(45, 108, 223, 1), 
                        chart: LineChartContent(lineChartBarData: caloriesLineChartBarData, minX: 1, minY: 0, maxX:10, maxY:4000, displayY: true, intervalY: 1000,)
                ),
                SizedBox(height: 10.0),
                        Container(
                          height: 50,
                          child: Card(
                            child: Center(child: Text("Average calories burned: $caloriesAverage"))
                          ),
                        ),
              ],
            ), 
        ),
      )
    );
  }
}