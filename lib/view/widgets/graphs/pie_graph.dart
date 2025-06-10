import 'package:barber_app/view/widgets/graphs/pie_graph_section.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieGraph extends StatelessWidget {
  const PieGraph({super.key, required this.servicesCount});
  final Map<int, Map<String, int>> servicesCount;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(),
        sections: List.generate(servicesCount.length, (index) {
          return pieGraphSection(
            servicesCount: servicesCount,
            id: index,
          );
        }),
      ),
    );
  }
}
