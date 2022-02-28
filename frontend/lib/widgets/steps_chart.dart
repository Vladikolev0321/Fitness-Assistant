import 'package:flutter/material.dart';
import 'package:frontend/models/steps_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StepsChart extends StatelessWidget {

  final List<StepsData> data;
  StepsChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<StepsData, String>> series = [
      charts.Series(
        id: "steps",
        data: data,
        domainFn: (StepsData series, _) => series.date,
        measureFn: (StepsData series, _) => series.steps,
        colorFn: (StepsData series, _) => series.barColor
      )
    ];

    return Center(
      child: Container(
        height: 400,
        width: 700,
        padding: EdgeInsets.all(25),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Steps done for the last 7 days",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Expanded(
                  child: charts.BarChart(series, animate: true),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}