import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:ghlapp/providers/mixin/education_video_mixin.dart';
import 'package:ghlapp/providers/mixin/investment_mixin.dart';
import 'package:ghlapp/providers/mixin/kyc_mixin.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class InvestmentProvider extends ChangeNotifier
    with InvestmentDetailMixin, KycMixin, SideNavigationMixin {
  final List<Map<String, dynamic>> activePlan = [];
  final List<Map<String, dynamic>> completedPlan = [];

  bool _isRememberClick = false;
  bool get isRememberClick => _isRememberClick;

  String? _fileName;
  String? get fileName => _fileName;

  String? _filePath;
  String get filePath => _filePath ?? "";

  void setRememberClick() {
    _isRememberClick = !_isRememberClick;
    notifyListeners();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        _filePath = filePath;
        _fileName = result.files.single.name;
        notifyListeners();
      }
    }
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

  Future<void> userInvestmentPlan({
    required context,
    required String id,
    required String planID,
    required String name,
    required String cName,
    required String category,
    required String tenure,
    required String investDate,
    required String filePath,
  }) async {
    final url = Uri.parse("${AppStrings.baseURL}invest-plan");
    try {
      var request = http.MultipartRequest("POST", url);
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });

      request.fields.addAll({
        "id": id,
        "plan_id": planID,
        "name": name,
        "c_name": cName,
        "category": category,
        "tenure": tenure,
        "ins_amt": investmentAmount.toString(),
        "monthly_return": monthlyReturn.toString(),
        "ins_date": investDate,
        "t_id": transactionIDController.text,
      });

      if (filePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath("puimage", filePath),
        );
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        // final res = await response.stream.bytesToString();
        AppSnackBar.show(
          context,
          message: "Investment Successfully Done",
          backgroundColor: AppColors.greenCircleColor,
        );
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: "Error ${response.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> uploadFile(String authToken) async {
    var url = Uri.parse("https://example.com/api/upload");

    var request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        "document",
        "/storage/emulated/0/Download/sample.pdf",
      ),
    );
    var response = await request.send();

    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      print("res--->> $respStr");
    } else {
      print("error --${response.statusCode}");
    }
  }

  void clearData() {
    amountInvestController.clear();
    investmentAmount = 0.0;
    monthlyReturn = 0.0;
    yearlyReturn = 0.0;
    totalSum = 0.0;
    _isRememberClick = false;
    amountInWords = "";
    notifyListeners();
  }
}
