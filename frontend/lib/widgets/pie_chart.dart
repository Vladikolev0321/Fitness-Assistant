import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/widgets/distance_widget.dart';

class ActivityPieChart extends StatefulWidget {
  double rideSection;
  double runSection;
  double walkSection;
  double hikeSection;
  int runDistance = 0;
  int rideDistance = 0;
  int walkDistance = 0;
  int hikeDistance = 0;

  ActivityPieChart(
      {Key key,
      this.rideSection,
      this.runSection,
      this.walkSection,
      this.hikeSection,
      this.runDistance,
      this.walkDistance,
      this.rideDistance,
      this.hikeDistance})
      : super(key: key);

  @override
  _ActivityPieChartState createState() => _ActivityPieChartState();
}

class _ActivityPieChartState extends State<ActivityPieChart> {
  int _touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            Container(
              width: 200,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 50.0,
                  sectionsSpace: 0.0,
                  startDegreeOffset: 30,
                  sections: showingSections(
                      widget.rideSection,
                      widget.runSection,
                      widget.walkSection,
                      widget.hikeSection),
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
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DistanceForActvity(
                      color: Color(0xffF3BBEC),
                      typeActivity: 'run',
                      title: 'RUNNING',
                      subtitle: '${widget.runDistance} KM',
                    ),
                    DistanceForActvity(
                      color: Color(0xff39439f),
                      typeActivity: 'ride',
                      title: 'CYCLING',
                      subtitle: '${widget.rideDistance} KM',
                    ),
                    DistanceForActvity(
                      color: Color(0xff0eaeb4),
                      typeActivity: 'walk',
                      title: 'WALKING',
                      subtitle: '${widget.walkDistance} KM',
                    ),
                    DistanceForActvity(
                      color: Color(0xff0eae21),
                      typeActivity: 'hike',
                      title: 'HIKING',
                      subtitle: '${widget.hikeDistance} KM',
                    )
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  List<PieChartSectionData> showingSections(
      rideSection, runSection, walkSection, hikeSection) {
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
