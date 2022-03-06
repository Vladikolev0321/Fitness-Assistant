import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/activity_average_data.dart';
import 'package:frontend/widgets/chart_container.dart';
import 'package:provider/provider.dart';

import '../providers/fitness_api.dart';
import '../widgets/line_chart.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({ Key key }) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final runLineChartBarData = Provider.of<FitnessInfoProvider>(context, listen: false).runLineChartBarData;
    final rideLineChartBarData = Provider.of<FitnessInfoProvider>(context, listen: false).rideLineChartBarData;
    final walkLineChartBarData = Provider.of<FitnessInfoProvider>(context, listen: false).walkLineChartBarData;
    final hikeLineChartBarData = Provider.of<FitnessInfoProvider>(context, listen: false).hikeLineChartBarData;


    print(runLineChartBarData);
    return Scaffold(
      appBar: AppBar(),
      body:Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          height: 300,
            child: PageView(
              children: [
                  ChartContainer(
                    title: 'Running average speed change', 
                    color: Color.fromRGBO(45, 108, 223, 1), 
                    chart: LineChartContent(lineChartBarData: runLineChartBarData)
                  ), 
                  ChartContainer(
                    title: 'Riding average speed change', 
                    color: Color.fromRGBO(45, 108, 223, 1), 
                    chart: LineChartContent(lineChartBarData: rideLineChartBarData)
                  ), 
                  ChartContainer(
                    title: 'Walking average speed change', 
                    color: Color.fromRGBO(45, 108, 223, 1), 
                    chart: LineChartContent(lineChartBarData: walkLineChartBarData)
                  ), 
                  ChartContainer(
                    title: 'Hiking average speed change', 
                    color: Color.fromRGBO(45, 108, 223, 1), 
                    chart: LineChartContent(lineChartBarData: hikeLineChartBarData)
                  ), 
              ],
            ),
        ),
      )
    );
  }
}