import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/activity_average_data.dart';
import 'package:frontend/widgets/chart_container.dart';
import 'package:provider/provider.dart';

import '../providers/fitness_api.dart';
import '../widgets/line_chart.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({ Key key }) : super(key: key);

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  @override
  Widget build(BuildContext context) {
    final weightLineChartBarData = Provider.of<FitnessInfoProvider>(context, listen: false).weightLineChartBarData;
    final weightAverage = Provider.of<FitnessInfoProvider>(context, listen: false).weightAverage;

    return Scaffold(
      appBar: AppBar(),
      body:Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          height: 400,
            child: Column(
              children: [
                ChartContainer(
                        title: 'Last logged weights', 
                        color: Color.fromRGBO(45, 108, 223, 1), 
                        chart: LineChartContent(lineChartBarData: weightLineChartBarData, minX: 1, minY: 0, maxX:10, maxY:200, displayY: true, intervalY: 20,)
                ),
                SizedBox(height: 10.0),
                        Container(
                          height: 50,
                          child: Card(
                            child: Center(child: Text("Average weight: $weightAverage"))
                          ),
                        ),
              ],
            ), 
        ),
      )
    );
  }
}