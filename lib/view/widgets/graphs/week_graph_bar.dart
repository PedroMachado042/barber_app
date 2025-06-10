import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartGroupData weekGraphBar({
  required int x,
  required double y,
  required double maxWeekdayAppoints,
  double backgroundY = 10,
  Color barColor = Colors.green,
}) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        width: 30,
        color: barColor,
        borderRadius: BorderRadius.circular(3),
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          toY: maxWeekdayAppoints,
          color: Colors.black45,
        ),
      ),
    ],
  );
}
