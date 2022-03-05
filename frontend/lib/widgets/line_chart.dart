import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartContent extends StatelessWidget {
  List<LineChartBarData> lineChartBarData;
  LineChartContent({@required this.lineChartBarData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(
          border: Border.all(
            color: Colors.white, 
            width: 0.5
          )
        ),
        gridData: FlGridData(
          drawHorizontalLine: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: Colors.white, 
                fontSize: 12, 
                fontWeight: FontWeight.bold
              ),
            getTitles: (value) {
              // if(value.toInt() == 0) return '';
              // else return value.toInt().toString();
              return '';
            },
          ),
          leftTitles: SideTitles(
            interval: 4,
            showTitles: true,
            textStyle: TextStyle(
                color: Colors.white, 
                fontSize: 14, 
                fontWeight: FontWeight.bold
              ),
            getTitles: (value) {
              if(value.toInt() == 0) return '';
              else return value.toInt().toString();
            },
          ),
        ),
        minX: 1,
        minY: 0,
        maxX: 10,
        maxY: 20,
        lineBarsData: lineChartBarData,
      ),
    );
  }
}