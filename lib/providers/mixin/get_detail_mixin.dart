import 'dart:convert';

import 'package:ghlapp/constants.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

mixin GetDetailMixin on ChangeNotifier {
  String privacyContent = "";
  int isAgreePrivacyPolicy = 0;

  String termsContent = "";
  int isAgreeTermsCondition = 0;

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

      if (request.statusCode == 200) {
        final data = jsonDecode(request.body);
        privacyContent = data["data"]["privacy"];
        isAgreePrivacyPolicy = data["privacy_policy"];
        notifyListeners();
        print(
          "isAgreePrivacyPolicy--->> $isAgreePrivacyPolicy------$privacyContent",
        );
      } else {
        AppSnackBar.show(context, message: "Error ${request.statusCode}");
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

      if (request.statusCode == 200) {
        final data = jsonDecode(request.body);
        termsContent = data["data"]["terms"];
        isAgreeTermsCondition = data["terms_and_conditions"];
        notifyListeners();
        print(
          "isAgreeTermsCondition--->> $isAgreeTermsCondition------$termsContent",
        );
      } else {
        AppSnackBar.show(context, message: "Error ${request.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> postPrivacy(context) async {
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
        AppSnackBar.show(context, message: "Success");
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
        AppSnackBar.show(context, message: "Success");
      } else {
        AppSnackBar.show(context, message: "Error ${request.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
