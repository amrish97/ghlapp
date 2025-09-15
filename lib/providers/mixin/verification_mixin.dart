import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/model/aadhaar_model.dart';
import 'package:ghlapp/pages/login/otp_page.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

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

  final FocusNode accountHolderFocus = FocusNode();
  final FocusNode accountNumberFocus = FocusNode();
  final FocusNode ifscFocus = FocusNode();

  //nominee
  final TextEditingController nomineeNameController = TextEditingController();
  final TextEditingController nomineePhoneController = TextEditingController();
  final TextEditingController nomineeEmailController = TextEditingController();
  final TextEditingController nomineeAadhaarController =
      TextEditingController();

  final FocusNode nomineeNameFocus = FocusNode();
  final FocusNode nomineePhoneFocus = FocusNode();
  final FocusNode nomineeEmailFocus = FocusNode();
  final FocusNode nomineeAadhaarFocus = FocusNode();

  final List<Map<String, dynamic>> userPlans = [];

  int _seconds = 30;
  bool _canResend = false;
  Timer? _timer;

  int get seconds => _seconds;

  bool get canResend => _canResend;

  int referenceID = 0;
  String aadhaarNo = "";
  bool isLoading = false;

  bool get getIsLoading => isLoading;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Map<String, bool> verifiedSection = {
    "aadhaar": isAadhaarVerified,
    "pan": isPanVerified,
    "bank": isBankVerified,
    "nominee": isNomineeVerified,
  };

  Future<void> updateSection(String section, bool status) async {
    verifiedSection[section] = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("${section}_completed", status);
    notifyListeners();
  }

  double get progress {
    int completed = verifiedSection.values.where((value) => value).length;
    print("completed---->> $completed");
    return completed / verifiedSection.length;
  }

  Future<void> loadVerifiedSections(context, {bool fetchApi = true}) async {
    final prefs = await SharedPreferences.getInstance();
    if (fetchApi) {
      await userDashboardAPI(context);
    }
    verifiedSection["aadhaar"] =
        prefs.getBool("aadhaar_completed") ?? isAadhaarVerified;
    verifiedSection["pan"] = prefs.getBool("pan_completed") ?? isPanVerified;
    verifiedSection["bank"] = prefs.getBool("bank_completed") ?? isBankVerified;
    verifiedSection["nominee"] =
        prefs.getBool("nominee_completed") ?? isNomineeVerified;
    aadhaarNo = prefs.getString("aadhaar_number") ?? "";
    print("completed1---->> ${verifiedSection.values}---$aadhaarNo");
    notifyListeners();
  }

  Future<void> statusUpdateNavigate(context, String section) async {
    await updateSection(section, true);
    await loadVerifiedSections(context, fetchApi: true);
    Navigator.pop(context);
  }

  AadhaarResponse? _aadhaarResponse;

  AadhaarResponse? get aadhaarResponse => _aadhaarResponse;

  void setAadhaarResponse(AadhaarResponse response) {
    _aadhaarResponse = response;
    notifyListeners();
  }

  Future<void> userDashboardAPI(context) async {
    final url = Uri.parse("${AppStrings.baseURL}kyc/dashboard");
    try {
      final res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        print("userData------$data");
        isAadhaarVerified = data["aadhaar_status"] == "yes" ? true : false;
        isPanVerified = data["pan_status"] == "yes" ? true : false;
        isBankVerified = data["bank_status"] == "yes" ? true : false;
        isNomineeVerified = data["kyc_status"] == "yes" ? true : false;
        aadhaarName = data["userName"] ?? "";
        print("aadhaarName------$isAadhaarVerified---$isPanVerified");
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
    notifyListeners();
  }

  Future<void> sendToAadhaarOTP(context, String number) async {
    setLoading(true);
    final url = Uri.parse("${AppStrings.baseURL}aadhaar/generate-otp");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({"aadhaar_number": number.toString()}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["code"] == 200) {
          final message = data["data"]["message"] ?? "";
          referenceID = data["data"]["reference_id"] ?? 0;
          await saveAadhaar(number.toString());
          AppSnackBar.show(
            context,
            message: message,
            backgroundColor: AppColors.greenCircleColor,
          );
          setLoading(false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpPage(
                    isFromVerification: true,
                    aadhaarNumber: number.toString(),
                    referenceID: referenceID,
                  ),
            ),
          );
        } else {
          setLoading(false);
          AppSnackBar.show(context, message: data["data"]["message"]);
        }
      } else {
        setLoading(false);
        AppSnackBar.show(context, message: "${data["message"]}");
      }
    } catch (e) {
      setLoading(false);
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> saveAadhaar(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("aadhaar_number", number);
  }

  Future<String> getAadhaar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("aadhaar_number") ?? "";
  }

  Future<void> verifyAadhaarOTP(
    context,
    String otp,
    int referenceId,
    String aadhaarNumber,
  ) async {
    setLoading(true);
    final url = Uri.parse("${AppStrings.baseURL}aadhaar/verify-otp");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("aadhaar_name", aadhaarResponse.data.name);
        await prefs.setString("aadhaar_photo", aadhaarResponse.data.photo);
        await prefs.setString("aadhaar_number", aadhaarNumber.toString());
        aadhaarName = aadhaarResponse.data.name;
        aadhaarNo = aadhaarNumber.toString();
        await updateSection("aadhaar", true);
        await loadVerifiedSections(context, fetchApi: true);
        Navigator.pop(context);
        AppSnackBar.show(
          context,
          message: aadhaarResponse.data.message,
          backgroundColor: AppColors.greenCircleColor,
        );
        notifyListeners();
        setLoading(false);
      } else {
        final Map<String, dynamic> error = jsonDecode(response.body);
        AppSnackBar.show(
          context,
          message: error["message"] ?? "Something went wrong",
        );
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      AppSnackBar.show(context, message: "$e");
    }
  }

  void startTimer() {
    _seconds = 30;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        notifyListeners();
      } else {
        _canResend = true;
        notifyListeners();
        _timer?.cancel();
      }
    });
  }

  Future<void> resendAadhaarOTP(context) async {
    final aadhaar = await getAadhaar();
    setLoading(true);
    final url = Uri.parse("${AppStrings.baseURL}aadhaar/resend-otp");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({"aadhaar_number": aadhaar}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["code"] == 200) {
          final message = data["data"]["message"];
          startTimer();
          AppSnackBar.show(
            context,
            message: message,
            backgroundColor: AppColors.greenCircleColor,
          );
          setLoading(false);
        } else {
          setLoading(false);
          AppSnackBar.show(context, message: data["message"]);
        }
      } else {
        setLoading(false);
        AppSnackBar.show(context, message: "${data["message"]}");
      }
    } catch (e) {
      setLoading(false);
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> verifyPanNumber(context, String panNumber) async {
    setLoading(true);
    final aadhaar = await getAadhaar();
    print("aadhaar---$aadhaar");
    final url = Uri.parse(
      "${AppStrings.baseURL}aadhaar/pan_aadhaar/link_status",
    );
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({
          "pan": panNumber.toString().trim(),
          "aadhaar_number": aadhaar.toString(),
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final message = data["data"]["message"];
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: AppColors.greenCircleColor,
        );
        setLoading(false);
        await statusUpdateNavigate(context, "pan");
      } else {
        setLoading(false);
        AppSnackBar.show(context, message: "${data["message"]}");
      }
    } catch (e) {
      setLoading(false);
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> verifyOtp(String phone, String otp, context) async {
    setLoading(true);
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
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == 200 && data["ok"] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token", data["token"]);
          authToken = prefs.getString("auth_token") ?? "";
          AppSnackBar.show(
            context,
            message: data["message"] ?? "OTP Verified Successfully",
            backgroundColor: AppColors.greenCircleColor,
          );
          setLoading(false);
          Navigator.pushNamed(context, AppRouteEnum.bottomPage.name);
        } else {
          AppSnackBar.show(
            context,
            message: data["message"] ?? "OTP Verification Failed",
          );
          setLoading(false);
        }
      } else {
        setLoading(false);
        AppSnackBar.show(context, message: "${data["message"]}");
      }
    } catch (e) {
      setLoading(false);
      AppSnackBar.show(context, message: e.toString());
    }
    notifyListeners();
  }

  Future<void> resendOtp(context, phoneNumber) async {
    setLoading(true);
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
        startTimer();
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: AppColors.greenCircleColor,
        );
        setLoading(false);
      } else {
        setLoading(false);
        final errorMsg =
            data["sms_response"]?["message"] ?? "Something went wrong";
        AppSnackBar.show(context, message: errorMsg);
      }
    } catch (e) {
      setLoading(false);
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> sendToBankDetail(
    context,
    String holderName,
    String accountNumber,
    String ifscCode,
  ) async {
    setLoading(true);
    final url = Uri.parse("${AppStrings.baseURL}kyc/create/bank-details");
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({
          "account_holder_name": holderName,
          "account_number": accountNumber,
          "ifsc_code": ifscCode,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final message = data["message"];
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: AppColors.greenCircleColor,
        );
        setLoading(false);
        await statusUpdateNavigate(context, "bank");
      } else {
        setLoading(false);
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      setLoading(false);
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
    setLoading(true);
    final url = Uri.parse("${AppStrings.baseURL}kyc/create/nominee-details");
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({
          "nominee_name": nomineeName,
          "nominee_phone": nomineePhone,
          "nominee_email": nomineeEmail,
          "nominee_aadhaar_number": nomineeAadhaar,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final message = data["message"];
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: AppColors.greenCircleColor,
        );
        setLoading(false);
        await statusUpdateNavigate(context, "nominee");
      } else {
        setLoading(false);
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      setLoading(false);
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
