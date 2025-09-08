import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin InvestmentDetailMixin on ChangeNotifier {
  final TextEditingController amountInvestController = TextEditingController();
  double investmentAmount = 0.0;
  double monthlyReturn = 0.0;
  double yearlyReturn = 0.0;
  double totalSum = 0.0;
  String errorMessage = "";

  void updateInvestment(
    String value,
    double roiPercent,
    double taxPercent,
    int tenureYears,
    double minInvestment,
    double maxInvestment,
  ) {
    if (value.isEmpty) {
      investmentAmount = 0;
      monthlyReturn = 0;
      yearlyReturn = 0;
      totalSum = 0;
      errorMessage = "";
      notifyListeners();
      return;
    }
    investmentAmount = double.tryParse(value) ?? 0;
    if (investmentAmount < minInvestment) {
      errorMessage =
          "Minimum investment is ₹ ${minInvestment.toStringAsFixed(0)}";
      notifyListeners();
      return;
    } else if (investmentAmount > maxInvestment) {
      errorMessage =
          "Maximum investment is ₹${maxInvestment.toStringAsFixed(0)}";
      notifyListeners();
      return;
    } else {
      errorMessage = "";
    }
    double monthlyRate = roiPercent / 12 / 100;
    double grossMonthly = investmentAmount * monthlyRate;
    double tds = grossMonthly * (taxPercent / 100);
    monthlyReturn = grossMonthly - tds;
    print("monthlyReturn-->> $monthlyReturn");
    yearlyReturn = monthlyReturn * 12;
    print("yearlyReturn-->> $yearlyReturn");
    totalSum = investmentAmount + (yearlyReturn * 2);
    notifyListeners();
  }

  // Future<void> planSchedule(
  //   context, {
  //   required String perTaxReturn,
  //   required String capitalInvested,
  //   required String minimumInvestment,
  //   required String tdsApplicable,
  //   required String tenure,
  // }) async {
  //   final url = Uri.parse("${AppStrings.baseURL}payment-schedule");
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "Bearer $authToken",
  //       },
  //       body: jsonEncode({
  //         "pre_return_tax": perTaxReturn,
  //         "capital_invested": capitalInvested,
  //         "minimum_investment": minimumInvestment,
  //         "tds_applicable": tdsApplicable,
  //         "monthly_returns": monthlyReturn.toString(),
  //         "yearly_returns": yearlyReturn.toString(),
  //         "sum_of_capital": totalSum.toString(),
  //         "tenure": tenure,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       final res = jsonDecode(response.body);
  //       print("response--->> $res");
  //       notifyListeners();
  //     } else {
  //       AppSnackBar.show(context, message: "Error ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     AppSnackBar.show(context, message: e.toString());
  //   }
  // }

  Future<Map<String, dynamic>?> planSchedule(
    BuildContext context, {
    required String perTaxReturn,
    required String capitalInvested,
    required String minimumInvestment,
    required String tdsApplicable,
    required String tenure,
  }) async {
    final url = Uri.parse("${AppStrings.baseURL}payment-schedule");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({
          "pre_return_tax": perTaxReturn,
          "capital_invested": capitalInvested,
          "minimum_investment": minimumInvestment,
          "tds_applicable": tdsApplicable,
          "monthly_returns": monthlyReturn.toString(),
          "yearly_returns": yearlyReturn.toString(),
          "sum_of_capital": totalSum.toString(),
          "tenure": tenure,
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        return res;
      } else {
        AppSnackBar.show(context, message: "Error ${response.statusCode}");
        return null;
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
      return null;
    }
  }
}
