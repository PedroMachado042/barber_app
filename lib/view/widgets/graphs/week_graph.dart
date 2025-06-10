import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/view/widgets/graphs/week_graph_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekGraph extends StatelessWidget {
  const WeekGraph({
    super.key,
    required this.maxWeekdayAppoints, //to passando por bonito só
    required this.weeklyAppoints,
  });

  final double maxWeekdayAppoints;
  final List<int> weeklyAppoints;
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt() == 0
                      ? '${DummyData.weekdays[6]}'
                      : '${DummyData.weekdays[value.toInt() - 1]}',
                );
              },
            ),
          ),
        ),
        maxY: maxWeekdayAppoints,
        barGroups: List.generate(7, (index) {
          return weekGraphBar(
            x: index,
            y: weeklyAppoints[index].toDouble(),
            maxWeekdayAppoints: maxWeekdayAppoints,
          );
        }),
      ),
    );
  }
}
