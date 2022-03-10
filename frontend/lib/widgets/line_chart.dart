import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartContent extends StatelessWidget {
  List<LineChartBarData> lineChartBarData;
  double minX;
  double maxX;
  double minY;
  double maxY;
  bool displayY;
  LineChartContent({
    @required this.lineChartBarData,
    @required this.minX,
    @required this.maxX,
    @required this.minY,
    @required this.maxY,
    @required this.displayY,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData:
            FlBorderData(border: Border.all(color: Colors.white, width: 0.5)),
        gridData: FlGridData(
          drawHorizontalLine: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            getTitles: (value) {
              if(displayY){
                if(value.toInt() == 0) return '';
                else return value.toInt().toString();
              }else{
                return '';
              }
             // return '';
            },
          ),
        ),
        minX: minX,
        minY: minY,
        maxX: maxX,
        maxY: maxY,
        lineBarsData: lineChartBarData,
      ),
    );
  }
}
