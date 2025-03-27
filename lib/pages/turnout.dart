import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sst/datapro.dart';

class Turnout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turnout Chart'),
      ),
      body: Center(
        child: Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            return BarChart(
              BarChartData(
                barGroups: _buildBarChartData(dataProvider.voteCounts),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarChartData(Map<String, String> voteCounts) {
    return voteCounts.entries.map((entry) {
      int index = voteCounts.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: double.parse(entry.value),
            color: Colors.primaries[index % Colors.primaries.length],
          ),
        ],
      );
    }).toList();
  }
}
