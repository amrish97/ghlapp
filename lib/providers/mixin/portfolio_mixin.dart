import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart' show authToken;

mixin PortfolioMixin on ChangeNotifier {
  double _progress = 0.0;

  double get progressPortFolio => _progress;

  final List<Map<String, dynamic>> portfolioData = [];
  double todayInvestment = 0;

  void calculateProgress(List<dynamic> userPlans, {double target = 1000000}) {
    double total = 0.0;
    for (var plan in userPlans) {
      total += double.tryParse(plan['ins_amt'].toString()) ?? 0.0;
    }
    _progress = (total / target).clamp(0.0, 1.0);

    notifyListeners();
  }

  void getPortfolioData(context) async {
    final url = Uri.parse("${AppStrings.baseURL}protfolio");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> portfolio = res["userProtfolio"] ?? [];
        portfolioData.clear();
        portfolioData.addAll(
          portfolio.map((e) => Map<String, dynamic>.from(e)),
        );
        print(portfolioData);
        calculateProgress(portfolio, target: 2000000);
        todayInvestment =
            double.tryParse(res["todayInvestment"].toString()) ?? 0;
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
