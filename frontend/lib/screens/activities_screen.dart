import 'package:flutter/material.dart';
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
    final runAverage = Provider.of<FitnessInfoProvider>(context, listen: false).runAverage;
    final rideAverage = Provider.of<FitnessInfoProvider>(context, listen: false).rideAverage;
    final walkAverage = Provider.of<FitnessInfoProvider>(context, listen: false).walkAverage;
    final hikeAverage = Provider.of<FitnessInfoProvider>(context, listen: false).hikeAverage;


    print(runLineChartBarData);
    return Scaffold(
      appBar: AppBar(),
      body:Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          height: 400,
            child: PageView(
              children: [
                  Column(
                    children: [
                      ChartContainer(
                        title: 'Running average speed change', 
                        color: Color.fromRGBO(45, 108, 223, 1), 
                        chart: LineChartContent(lineChartBarData: runLineChartBarData, minX: 1, minY: 0, maxX:10, maxY:30, displayY:true, intervalY: 10)
                      ),
                      SizedBox(height: 10.0),
                         Container(
                          height: 50,
                          child: Card(
                            child: Center(child: Text("Your average speed for running activity is $runAverage"))
                          ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      ChartContainer(
                        title: 'Riding average speed change', 
                        color: Color.fromRGBO(45, 108, 223, 1), 
                        chart: LineChartContent(lineChartBarData: rideLineChartBarData, minX: 1, minY: 0, maxX:10, maxY:30, displayY:true, intervalY: 10)
                      ),
                      SizedBox(height: 10.0),
                         Container(
                          height: 50,
                          child: Card(
                            child: Center(child: Text("Your average speed for cycling activity is $rideAverage"))
                          ),
                        ),
                    ],
                  ), 
                  Column(
                    children: [
                      ChartContainer(
                        title: 'Walking average speed change', 
                        color: Color.fromRGBO(45, 108, 223, 1), 
                        chart: LineChartContent(lineChartBarData: walkLineChartBarData, minX: 1, minY: 0, maxX:10, maxY:30, displayY:true, intervalY: 10)
                      ),
                      SizedBox(height: 10.0),
                         Container(
                          height: 50,
                          child: Card(
                            child: Center(child: Text("Your average speed for walking activity is $walkAverage"))
                          ),
                        ),
                    ],
                  ), 
                  Column(
                    children: [
                      ChartContainer(
                        title: 'Hiking average speed change', 
                        color: Color.fromRGBO(45, 108, 223, 1), 
                        chart: LineChartContent(lineChartBarData: hikeLineChartBarData, minX: 1, minY: 0, maxX:10, maxY:30, displayY:true, intervalY: 10)
                      ),
                      SizedBox(height: 10.0),
                         Container(
                          height: 50,
                          child: Card(
                            child: Center(child: Text("Your average speed for hiking activity is $hikeAverage"))
                          ),
                        ),
                    ],
                  ), 
              ],
            ),
        ),
      )
    );
  }
}