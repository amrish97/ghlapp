import 'dart:convert';

import 'package:dhlapp/model/aadhaar_model.dart';
import 'package:dhlapp/pages/otp_page.dart';
import 'package:dhlapp/resources/AppString.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/widgets/custom_snakebar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

mixin VerificationMixin on ChangeNotifier {
  //aadhaar
  final TextEditingController aadhaarController = TextEditingController();
  //pan
  final TextEditingController panCardController = TextEditingController();

  //bank
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();

  //nominee
  final TextEditingController nomineeNameController = TextEditingController();
  final TextEditingController nomineePhoneController = TextEditingController();
  final TextEditingController nomineeEmailController = TextEditingController();
  final TextEditingController nomineeAadhaarController =
      TextEditingController();

  String transactionId = "";
  String aadhaarNumber = "";

  Map<String, bool> verifiedSection = {
    "aadhaar": false,
    "pan": false,
    "bank": false,
    "nominee": false,
  };

  double get progress {
    int completed = verifiedSection.values.where((value) => value).length;
    return completed / verifiedSection.length;
  }

  AadhaarResponse? _aadhaarResponse;

  AadhaarResponse? get aadhaarResponse => _aadhaarResponse;

  void setAadhaarResponse(AadhaarResponse response) {
    _aadhaarResponse = response;
    notifyListeners();
  }

  Future<void> updateSection(String section, bool status) async {
    print("sts--->> $status");
    verifiedSection[section] = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("${section}_completed", status);
    print("verifiedSectionset--->> $verifiedSection---$section---$status");
    notifyListeners();
  }

  Future<void> loadVerifiedSections() async {
    final prefs = await SharedPreferences.getInstance();

    verifiedSection["aadhaar"] = prefs.getBool("aadhaar_completed") ?? false;
    verifiedSection["pan"] = prefs.getBool("pan_completed") ?? false;
    verifiedSection["bank"] = prefs.getBool("bank_completed") ?? false;
    verifiedSection["nominee"] = prefs.getBool("nominee_completed") ?? false;

    notifyListeners();
  }

  Future<void> statusUpdateNavigate(context, String section) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (section == "aadhaar") {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> sendToAadhaarOTP(context, String number) async {
    final url = Uri.parse("${AppStrings.baseURL}aadhaar/generate-otp");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer bsjjS3N60B8FXkBGvQyPsWowulJcQ3IfZuzc2NsDddfa2c55",
        },
        body: jsonEncode({"aadhaar_number": number.toString()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["code"] == 200) {
          final message = data["data"]["message"] ?? "";
          transactionId = data["transaction_id"] ?? "";
          aadhaarNumber = number.toString();
          AppSnackBar.show(
            context,
            message: message,
            backgroundColor: Colors.green,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpPage(
                    isFromVerification: true,
                    aadhaarNumber: number.toString(),
                    referenceID: data["data"]["reference_id"] ?? 0,
                  ),
            ),
          );
        } else {
          AppSnackBar.show(context, message: data["data"]["message"]);
        }
      } else {
        AppSnackBar.show(context, message: "Error ${response.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> verifyAadhaarOTP(
    context,
    String otp,
    int referenceId,
    String aadhaarNumber,
  ) async {
    final url = Uri.parse("${AppStrings.baseURL}aadhaar/verify-otp");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer 5DpWI5h1VDSq0WR7owXgwpJmBzl40tGZXHaCwVNAb248b80c",
        },
        body: jsonEncode({
          "reference_id": referenceId.toString(),
          "aadhaar_number": aadhaarNumber.toString(),
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final aadhaarResponse = AadhaarResponse.fromJson(json);
        setAadhaarResponse(aadhaarResponse);
        await updateSection("aadhaar", true);
        await statusUpdateNavigate(context, "aadhaar");
        AppSnackBar.show(
          context,
          message: aadhaarResponse.data.message,
          backgroundColor: Colors.green,
        );
      } else {
        final Map<String, dynamic> error = jsonDecode(response.body);
        AppSnackBar.show(
          context,
          message: error["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      AppSnackBar.show(context, message: "$e");
    }
  }

  Future<void> resendAadhaarOTP(context, String aadhaarNumber) async {
    final url = Uri.parse("${AppStrings.baseURL}aadhaar/resend-otp");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"aadhaar_number": aadhaarNumber}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["code"] == 200) {
          final message = data["data"]["message"];
          AppSnackBar.show(
            context,
            message: message,
            backgroundColor: Colors.green,
          );
        } else {
          AppSnackBar.show(context, message: data["message"]);
        }
      } else {
        AppSnackBar.show(context, message: "Error ${response.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> verifyPanNumber(context, String panNumber) async {
    print("p--->> ${panNumber}--${aadhaarNumber}");
    final url = Uri.parse(
      "${AppStrings.baseURL}aadhaar/pan_aadhaar/link_status",
    );
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer B9mcTAMUl2CSTEDfPD9aM8XNX8BfMGvIKQhdlbVyc25daa11",
        },
        body: jsonEncode({
          "pan": panNumber,
          "aadhaar_number": aadhaarNumber.toString(),
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final message = data["data"]["message"];
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: AppColors.primary,
        );
        await updateSection("pan", true);
        await statusUpdateNavigate(context, "pan");
      } else {
        AppSnackBar.show(context, message: "Error ${res.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> sendToBankDetail(
    context,
    String holderName,
    String accountNumber,
    String ifscCode,
  ) async {
    final url = Uri.parse("${AppStrings.baseURL}kyc/create/bank-details");
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer B9mcTAMUl2CSTEDfPD9aM8XNX8BfMGvIKQhdlbVyc25daa11",
        },
        body: jsonEncode({
          "account_holder_name": holderName,
          "account_number": accountNumber,
          "ifsc_code": ifscCode,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final message = data["message"];
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: Colors.green,
        );
        await updateSection("bank", true);
        await statusUpdateNavigate(context, "bank");
      } else {
        AppSnackBar.show(context, message: "Error ${res.body}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> sendToNomineeDetail(
    context,
    String nomineeName,
    String nomineePhone,
    String nomineeEmail,
    String nomineeAadhaar,
  ) async {
    final url = Uri.parse("${AppStrings.baseURL}kyc/create/nominee-details");
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer 78|B9mcTAMUl2CSTEDfPD9aM8XNX8BfMGvIKQhdlbVyc25daa11",
        },
        body: jsonEncode({
          "nominee_name": nomineeName,
          "nominee_phone": nomineePhone,
          "nominee_email": nomineeEmail,
          "nominee_aadhaar_number": nomineeAadhaar,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final message = data["message"];
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: Colors.green,
        );
        await updateSection("nominee", true);
        await statusUpdateNavigate(context, "nominee");
      } else {
        AppSnackBar.show(context, message: "Error ${res.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  clearAll() {
    aadhaarController.clear();
    panCardController.clear();
    accountHolderNameController.clear();
    accountNumberController.clear();
    ifscCodeController.clear();
    nomineeNameController.clear();
    nomineePhoneController.clear();
    nomineeEmailController.clear();
    nomineeAadhaarController.clear();
  }

  @override
  dispose() {
    clearAll();
    super.dispose();
  }
}
