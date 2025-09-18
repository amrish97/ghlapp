import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  final List<InvestmentData> investmentData;

  const LineChart({super.key, required this.investmentData});

  @override
  Widget build(BuildContext context) {
    if (investmentData.isEmpty) {
      return const Center(child: Text("No investment data"));
    }
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(interval: 1.0),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum:
            investmentData
                .map((e) => e.amount)
                .reduce((a, b) => a > b ? a : b) *
            1.2,
        interval: 100000,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
      ),
      series: <CartesianSeries>[
        LineSeries<InvestmentData, String>(
          dataSource: investmentData,
          xValueMapper: (InvestmentData d, _) => d.month,
          yValueMapper: (InvestmentData d, _) => d.amount,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          color: AppColors.primary,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}

class InvestmentData {
  final String month;
  final double amount;

  InvestmentData(this.month, this.amount);

  factory InvestmentData.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['ins_date']);
    String month = DateFormat.MMM().format(date);

    double amount;
    if (json['ins_amt'] is String) {
      amount = double.tryParse(json['ins_amt']) ?? 0.0;
    } else {
      amount = (json['ins_amt'] as num).toDouble();
    }

    return InvestmentData(month, amount);
  }
}
