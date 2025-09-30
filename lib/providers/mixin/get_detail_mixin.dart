import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

mixin GetDetailMixin on ChangeNotifier {
  String privacyContent = "";
  int isAgreePrivacyPolicy = 0;

  String termsContent = "";
  int isAgreeTermsCondition = 0;

  final Map<String, dynamic> kycInformation = {};
  final Map<String, dynamic> bankInformation = {};
  final Map<String, dynamic> nomineeInformation = {};
  final Map<String, dynamic> personalDetails = {};

  Future getPrivacy(context) async {
    final url = Uri.parse("${AppStrings.baseURL}privacy");
    try {
      final request = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      final data = jsonDecode(request.body);
      if (request.statusCode == 200) {
        privacyContent = data["data"]["terms"]["privacy"];
        isAgreePrivacyPolicy = data["data"]["user_agreed"];
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future getTermsCondition(context) async {
    final url = Uri.parse("${AppStrings.baseURL}terms/conditions");
    try {
      final request = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      final data = jsonDecode(request.body);
      if (request.statusCode == 200) {
        termsContent = data["data"]["terms"]["terms"];
        isAgreeTermsCondition = data["data"]["user_agreed"];
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  void postPrivacy(context) async {
    final url = Uri.parse("${AppStrings.baseURL}privacy");
    try {
      final request = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({"privacy_policy": isAgreePrivacyPolicy}),
      );
      if (request.statusCode == 200) {
        AppSnackBar.show(
          context,
          message: "Success",
          backgroundColor: AppColors.greenCircleColor,
        );
        isAgreePrivacyPolicy = 1;
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: "Error ${request.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> postTermsCondition(context) async {
    final url = Uri.parse("${AppStrings.baseURL}terms/conditions");
    try {
      final request = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({"terms_and_conditions": isAgreeTermsCondition}),
      );
      if (request.statusCode == 200) {
        AppSnackBar.show(
          context,
          message: "Success",
          backgroundColor: AppColors.greenCircleColor,
        );
        isAgreeTermsCondition = 1;
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: "Error ${request.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future getKYCDetail(context) async {
    final url = Uri.parse("${AppStrings.baseURL}kyc-details");
    try {
      final request = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      final data = jsonDecode(request.body);
      if (request.statusCode == 200) {
        kycInformation.clear();
        kycInformation.addAll(data["data"] ?? {});
        nomineeInformation.clear();
        nomineeInformation.addAll(data["nomineeDetail"] ?? {});
        bankInformation.clear();
        bankInformation.addAll(data["bankDetail"] ?? {});
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future getPersonalDetail(context) async {
    final url = Uri.parse("${AppStrings.baseURL}personal/details");
    try {
      final request = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      final data = jsonDecode(request.body);
      if (request.statusCode == 200) {
        personalDetails.clear();
        personalDetails.addAll(data["data"] ?? {});
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
