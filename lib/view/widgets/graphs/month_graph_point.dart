import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartBarData monthGraphPoint({
  required List<double> monthRevenue,
  Color barColor = Colors.green,
}) {
  return LineChartBarData(
    barWidth: 3,
    color: barColor,
    spots: List.generate(6, (index) {
      return FlSpot(index.toDouble(), monthRevenue[index].toDouble());
    }),
  );
}
