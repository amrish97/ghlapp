import 'dart:convert';

import 'package:ghlapp/providers/mixin/investment_mixin.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class InvestmentProvider extends ChangeNotifier with InvestmentDetailMixin {
  final List<Map<String, dynamic>> activePlan = [];
  final List<Map<String, dynamic>> completedPlan = [];

  bool _isRememberClick = false;

  bool get isRememberClick => _isRememberClick;

  void setRememberClick() {
    _isRememberClick = !_isRememberClick;
    notifyListeners();
  }

  Future<void> getPlan(context) async {
    final url = Uri.parse("${AppStrings.baseURL}investment-plans");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final List<dynamic> plans = res["activePlans"] ?? [];
        final List<dynamic> completedPlans = res["completedPlans"] ?? [];
        activePlan.clear();
        activePlan.addAll(plans.map((e) => Map<String, dynamic>.from(e)));
        completedPlan.clear();
        completedPlan.addAll(
          completedPlans.map((e) => Map<String, dynamic>.from(e)),
        );
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: "Error ${response.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
