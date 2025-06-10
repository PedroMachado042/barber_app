import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/view/widgets/graphs/month_graph_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthGraph extends StatelessWidget {
  const MonthGraph({
    super.key,
    required this.monthRevenue,
    required this.maxMonthRevenue,
  }); //to passando por bonito só});

  final double maxMonthRevenue;
  final List<double> monthRevenue;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        maxX: 5,
        maxY: maxMonthRevenue,
        minY: 0,
        minX: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              //interval: 5,
              minIncluded: false,
              reservedSize: 25,
              showTitles: true,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int mes = DateTime.now().month - 6 + value.toInt();
                return mes < 0
                    ? Text('${DummyData.months[mes + 12]}')
                    : Text('${DummyData.months[mes]}');
              },
            ),
          ),
        ),
        lineBarsData: [monthGraphPoint(monthRevenue: monthRevenue)]
      ),
    );
  }
}
