import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivityPieChart extends StatefulWidget {
  double rideSection;
  double runSection;
  double walkSection;
  double hikeSection;

  ActivityPieChart({ Key key, this.rideSection, this.runSection, this.walkSection, this.hikeSection }) : super(key: key);


  @override
  _ActivityPieChartState createState() => _ActivityPieChartState();
}

class _ActivityPieChartState extends State<ActivityPieChart> {
  int _touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Container(
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 50.0,
                  sectionsSpace: 0.0,
                  startDegreeOffset: 30,
                  sections: showingSections(widget.rideSection, widget.runSection, widget.walkSection, widget.hikeSection),
                  pieTouchData: PieTouchData(
                    touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          _touchedIndex = -1;
                        } else {
                          _touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ]
      ),
    )
    );
  }

  List<PieChartSectionData> showingSections(rideSection, runSection, walkSection, hikeSection) {
    return List.generate(4, (i) {
      final isTouched = i == _touchedIndex;
      final double radius = isTouched ? 30 : 20;

      switch (i) {
        case 0:
          return PieChartSectionData(
              color: Color(0xff39439f),
              value: rideSection,
              title: 'Ride',
              radius: radius);
        case 1:
          return PieChartSectionData(
              color: Color(0xffF3BBEC),
              value: runSection,
              title: 'Run', 
              radius: radius);
        case 2:
          return PieChartSectionData(
              color: Color(0xff0eaeb4),
              value: walkSection,
              title: 'Walk', 
              radius: radius);
        case 3:
          return PieChartSectionData(
              color: Color(0xff0eae21),
              value: hikeSection,
              title: 'Hike', 
              radius: radius);
        default:
          return null;
      }
    });
  }
}