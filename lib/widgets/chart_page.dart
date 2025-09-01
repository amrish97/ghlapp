import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  const LineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          title: const ChartTitle(text: "Line Chart (0.0 to 1.0)"),
          primaryXAxis: NumericAxis(minimum: 0.0, maximum: 1.0, interval: 0.1),
          primaryYAxis: NumericAxis(minimum: 0.0, maximum: 1.0, interval: 0.1),
          series: [
            LineSeries<ChartData, double>(
              dataSource: [
                ChartData(0.0, 0.0),
                ChartData(0.2, 0.4),
                ChartData(0.4, 0.3),
                ChartData(0.6, 0.7),
                ChartData(0.8, 0.6),
                ChartData(1.0, 1.0),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final double x;
  final double y;
  ChartData(this.x, this.y);
}
