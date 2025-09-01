import 'dart:convert';

import 'package:another_telephony/telephony.dart';
import 'package:dhlapp/app/app_routes.dart';
import 'package:dhlapp/resources/AppString.dart';
import 'package:dhlapp/widgets/custom_snakebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

mixin OtpMixin on ChangeNotifier {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> messages = [];

  Future<void> checkAndLoadSms(context) async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted ?? false) {
      List<SmsMessage> smsList = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      messages = smsList;
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SMS permission is required")),
      );
    }
  }

  Future<void> verifyOtp(String phone, String otp, context) async {
    final url = Uri.parse("${AppStrings.baseURL}verify/user/otp");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"phone": phone, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == 200 && data["ok"] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token", data["token"]);

          AppSnackBar.show(
            context,
            message: data["message"] ?? "OTP Verified Successfully",
            backgroundColor: Colors.green,
          );
          Navigator.pushNamed(context, AppRouteEnum.bottomPage.name);
        } else {
          AppSnackBar.show(
            context,
            message: data["message"] ?? "OTP Verification Failed",
          );
        }
      } else {
        AppSnackBar.show(
          context,
          message: "Error: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }

    notifyListeners();
  }

  Future<void> resendOtp(context, phoneNumber) async {
    final url = Uri.parse("${AppStrings.baseURL}resend/otp");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumber}),
      );

      final data = jsonDecode(response.body);
      if (data["sms_response"]?["status"] == "success") {
        final message =
            data["sms_response"]?["message"] ?? "OTP Sent Successfully";
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: Colors.green,
        );
      } else {
        final errorMsg =
            data["sms_response"]?["message"] ?? "Something went wrong";
        AppSnackBar.show(context, message: errorMsg);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
