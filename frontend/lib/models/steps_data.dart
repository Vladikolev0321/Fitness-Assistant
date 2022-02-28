import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepsData {
  final String date;
  final int steps;
  final charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.green);

  StepsData(
    {
      @required this.date,
      @required this.steps
    }
  );

  factory StepsData.fromJson(Map<String, dynamic> data) {
    final date = DateFormat('EEEE').format(DateTime.parse(data['dateTime'])).substring(0,2);
    final steps = int.parse(data['value']);
    return StepsData(date: date, steps: steps);
  }

}