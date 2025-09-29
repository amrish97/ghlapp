import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin PortfolioMixin on ChangeNotifier {
  final List<Map<String, dynamic>> activePlanData = [];
  final List<Map<String, dynamic>> completedPlanData = [];
  final List<Map<String, dynamic>> userInvestDocs = [];
  final List<Map<String, dynamic>> userSchedule = [];
  final List<Map<String, dynamic>> userPlanExploreData = [];
  dynamic totalPayout = 0;
  int tenurePaid = 0;
  int trackingStatus = 0;

  final List<String> chipData = [
    "Invest Document",
    "History",
    "Document Tracking",
    "TDS",
    "Cashback",
    "Charge Creation",
    "Mortgage deed",
  ];

  int _selectedIndexExplore = 0;

  int get selectedIndexExplore => _selectedIndexExplore;

  void setIndexExploreData(int index) {
    _selectedIndexExplore = index;
    notifyListeners();
  }

  void resetIndexExploreData() {
    _selectedIndexExplore = 0;
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
        final List<dynamic> activePlan = res["userActivePlans"] ?? [];
        final List<dynamic> completePlan = res["userCompletedPlans"] ?? [];
        activePlanData.clear();
        activePlanData.addAll(
          activePlan.map((e) => Map<String, dynamic>.from(e)),
        );
        completedPlanData.clear();
        completedPlanData.addAll(
          completePlan.map((e) => Map<String, dynamic>.from(e)),
        );
        print("activePlanData---->> $activePlanData");
        print("completedPlanData---->> $completedPlanData");
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> getUserInvestmentDocument(context, int id) async {
    print("id---->> $id");
    final url = Uri.parse("${AppStrings.baseURL}investment/doc?invest_id=$id");
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
        final List<dynamic> userInvest = res["UserInvestDocs"] ?? [];
        userInvestDocs.clear();
        userInvestDocs.addAll(
          userInvest.map((e) => Map<String, dynamic>.from(e)),
        );
        print("userInvestDocs---->> $userInvestDocs");
        final List<dynamic> userScheduleData = res["userSchedule"] ?? [];
        userSchedule.clear();
        userSchedule.addAll(
          userScheduleData.map((e) => Map<String, dynamic>.from(e)),
        );
        print("userSchedule---->> $userSchedule");
        userPlanExploreData.clear();
        final data = res["userPlan"];
        if (data is List) {
          userPlanExploreData.addAll(List<Map<String, dynamic>>.from(data));
          print("userInvestDocs1---->> $userPlanExploreData");
        } else if (data is Map) {
          userPlanExploreData.add(Map<String, dynamic>.from(data));
          print("userInvestDocs2---->> $userPlanExploreData");
        }
        totalPayout = res["totalPayout"];
        tenurePaid = res["tenurePaid"];
        trackingStatus = res["trackingStatus"];
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      print("e---->> $e");
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
