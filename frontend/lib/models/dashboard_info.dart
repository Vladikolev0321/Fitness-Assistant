import 'package:flutter/material.dart';

class DashboardInfo {
  int stepsCount = 0;
  int caloriesBurned = 0;
  double runPercentage = 0;
  double ridePercentage = 0;
  double walkPercentage = 0;
  double hikePercentage = 0;
  int runDistance = 0;
  int rideDistance = 0;
  int walkDistance = 0;
  int hikeDistance = 0;
  double weight = 0;

  DashboardInfo(
      {@required this.stepsCount,
      @required this.caloriesBurned,
      @required this.runPercentage,
      @required this.ridePercentage,
      @required this.walkPercentage,
      @required this.hikePercentage,
      @required this.runDistance,
      @required this.rideDistance,
      @required this.walkDistance,
      @required this.hikeDistance,
      @required this.weight});

  factory DashboardInfo.fromJson(Map<String, dynamic> data) {
    final stepsCount = int.parse(data['steps']);
    final caloriesBurned = int.parse(data['burnt_calories']);
    final runPercentage = data['percentages']['run_distance_percentage'];
    final ridePercentage = data['percentages']['ride_distance_percentage'];
    final walkPercentage = data['percentages']['walk_distance_percentage'];
    final hikePercentage = data['percentages']['hike_distance_percentage'];
    final runDistance = data['distances']['run_distance'];
    final rideDistance = data['distances']['ride_distance'];
    final walkDistance = data['distances']['walk_distance'];
    final hikeDistance = data['distances']['hike_distance'];
    final weight = double.parse(data['weight'].toStringAsFixed(2));
    
    return DashboardInfo(
      stepsCount: stepsCount,
      caloriesBurned: caloriesBurned,
      runPercentage: runPercentage,
      ridePercentage: ridePercentage,
      walkPercentage: walkPercentage,
      hikePercentage: hikePercentage,
      runDistance: runDistance,
      rideDistance: rideDistance,
      walkDistance: walkDistance,
      hikeDistance: hikeDistance,
      weight: weight,
    );
  }
}
