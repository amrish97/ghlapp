import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin InvestmentDetailMixin on ChangeNotifier {
  final TextEditingController amountInvestController = TextEditingController();
  final TextEditingController transactionIDController = TextEditingController();
  double investmentAmount = 0.0;
  double monthlyReturn = 0.0;
  double yearlyReturn = 0.0;
  double withoutTDS = 0.0;
  double totalSum = 0.0;
  String errorMessage = "";
  String amountInWords = "";

  double monthlyReturnComplete = 0.0;
  double yearlyReturnComplete = 0.0;
  double totalSumComplete = 0.0;

  void completeInvestmentDetail(
    double investmentAmount,
    double roiPercent,
    double taxPercent,
  ) {
    print("investmentAmount---->>> $investmentAmount");
    print("roiPercent---->>> $roiPercent");
    print("taxPercent---->>> $taxPercent");
    double monthlyRate = roiPercent / 12 / 100;
    print("monthlyRate---->>> $monthlyRate");
    double grossMonthly = investmentAmount * monthlyRate;
    print("grossMonthly---->>> $grossMonthly");
    double tds = grossMonthly * (taxPercent / 100);
    print("tds---->>> $tds");
    monthlyReturnComplete = grossMonthly - tds;
    print("monthlyReturnComplete---->>> $monthlyReturnComplete");
    yearlyReturnComplete = monthlyReturnComplete * 12;
    print("yearlyReturnComplete---->>> $yearlyReturnComplete");
    totalSumComplete = investmentAmount + (yearlyReturnComplete * 2);
    print("totalSumComplete---->>> $totalSumComplete");
  }

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
          "Maximum investment is  ${maxInvestment.toStringAsFixed(0)}";
      notifyListeners();
      return;
    } else {
      errorMessage = "";
    }
    double monthlyRate = roiPercent / 12 / 100;
    double grossMonthly = investmentAmount * monthlyRate;
    double tds = grossMonthly * (taxPercent / 100);
    monthlyReturn = grossMonthly - tds;
    yearlyReturn = monthlyReturn * 12;
    totalSum = investmentAmount + (yearlyReturn * 2);
    withoutTDS = investmentAmount + (grossMonthly * tenureYears);
    final amount = int.tryParse(value) ?? 0;
    if (amount > 0) {
      amountInWords = convertToIndianWords(amount);
    } else {
      amountInWords = "";
    }
    notifyListeners();
  }

  String convertToIndianWords(int number) {
    if (number == 0) return "Zero";

    final units = [
      "",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen",
    ];

    final tens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety",
    ];

    String twoDigits(int n) {
      if (n < 20) return units[n];
      return "${tens[n ~/ 10]} ${units[n % 10]}".trim();
    }

    String convertChunk(int n) {
      String str = "";
      if (n >= 100) {
        str += "${units[n ~/ 100]} Hundred ";
        n %= 100;
      }
      if (n > 0) {
        str += twoDigits(n);
      }
      return str.trim();
    }

    String result = "";
    if (number >= 10000000) {
      result += "${convertChunk(number ~/ 10000000)} Crore ";
      number %= 10000000;
    }
    if (number >= 100000) {
      result += "${convertChunk(number ~/ 100000)} Lakhs ";
      number %= 100000;
    }
    if (number >= 1000) {
      result += "${convertChunk(number ~/ 1000)} Thousand ";
      number %= 1000;
    }
    if (number > 0) {
      result += convertChunk(number);
    }

    return result.trim();
  }

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
