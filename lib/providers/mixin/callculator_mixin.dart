import 'package:flutter/cupertino.dart';

mixin CalculatorMixin on ChangeNotifier {
  double _initialInvestmentAmount = 0;
  double _withoutTDS = 0;
  double _totalAmount = 0;
  double _monthly = 0;

  double get initialInvestmentAmount => _initialInvestmentAmount;

  double get withoutTDS => _withoutTDS;

  double get totalAmount => _totalAmount;

  double get monthly => _monthly;

  void setAmount(double value, String tenure, dynamic roi) {
    _initialInvestmentAmount = value;
    double tenurePercent = double.parse(tenure);
    double rate = tenurePercent * 2 / 100;
    _withoutTDS = _initialInvestmentAmount * rate;
    _totalAmount = _initialInvestmentAmount + _withoutTDS;
    double roiPercent = double.tryParse(roi.toString()) ?? 0;
    double monthlyRate = roiPercent / 12 / 100;
    double grossMonthly = _initialInvestmentAmount * monthlyRate;
    _monthly = grossMonthly;
    notifyListeners();
  }
}
