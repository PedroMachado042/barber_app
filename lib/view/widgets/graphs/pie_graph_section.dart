import 'package:barber_app/data/dummy_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/painting.dart';

PieChartSectionData pieGraphSection({
  required Map<int, Map<String, int>> servicesCount,
  required int id,
}) {
  print(servicesCount[id]!.values.first);
  return PieChartSectionData(
    color: DummyData.barColor[id],
    value: servicesCount[id]!.values.first.toDouble(),
    title: '${servicesCount[id]!.values.first}',
    titleStyle: TextStyle(fontWeight: FontWeight.bold),
    titlePositionPercentageOffset: 1.4,
  );
}
