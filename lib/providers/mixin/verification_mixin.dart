import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/model/aadhaar_model.dart';
import 'package:ghlapp/pages/login/otp_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

mixin VerificationMixin on ChangeNotifier {
  final TextEditingController aadhaarController = TextEditingController();

  final TextEditingController panCardController = TextEditingController();

  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final FocusNode accountHolderNameFocusNode = FocusNode();
  final FocusNode accountNumberFocusNode = FocusNode();
  final FocusNode accountIfscCodeFocusNode = FocusNode();

  final TextEditingController nomineeNameController = TextEditingController();
  final TextEditingController nomineePhoneController = TextEditingController();
  final TextEditingController nomineeEmailController = TextEditingController();
  final TextEditingController nomineeAadhaarController =
      TextEditingController();
  final FocusNode nomineeNameFocusNode = FocusNode();
  final FocusNode nomineePhoneFocusNode = FocusNode();
  final FocusNode nomineeEmailFocusNode = FocusNode();
  final FocusNode nomineeAadhaarFocusNode = FocusNode();

  final List<Map<String, dynamic>> userPlans = [];

  int _seconds = 30;
  bool _canResend = false;
  Timer? _timer;

  int get seconds => _seconds;

  bool get canResend => _canResend;

  int referenceID = 0;
  int resendReferenceID = 0;
  bool isLoading = false;
  double thisMonth = 0;
  double totalInvestments = 0;
  bool isPersonalDetail = false;

  bool get getIsLoading => isLoading;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Map<String, bool> verifiedSection = {
    "aadhaar": false,
    "pan": false,
    "bank": false,
    "nominee": false,
  };

  double progress = 0.0;

  void updateVerified(String key, bool value) {
    verifiedSection[key] = value;
    _calculateProgress();
    notifyListeners();
    print("Updated Section -> $verifiedSection");
  }

  void loadVerifiedSections(BuildContext context) {
    userDashboardAPI(context);
    _calculateProgress();
    print("Verified Map---> $verifiedSection");
  }

  void _calculateProgress() {
    final total = verifiedSection.length;
    final done = verifiedSection.values.where((v) => v).length;
    progress = total == 0 ? 0.0 : done / total;
    print("Progress -> $progress");
  }

  Future<void> statusUpdateNavigate(context, String section) async {
    Provider.of<HomeProvider>(
      context,
      listen: false,
    ).updateVerified(section, true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (section == "aadhaar") {
        Navigator.pop(context);
        Navigator.pop(context);
        loadVerifiedSections(context);
      } else {
        Navigator.pop(context);
      }
    });
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
        print("userData------>>> $data");
        isAadhaarVerified = data["data"]["aadhar_detail"];
        isPanVerified = data["data"]["pan_detail"];
        isBankVerified = data["data"]["bank_detail"];
        isNomineeVerified = data["data"]["kyc_status"];
        verifiedSection["aadhaar"] = isAadhaarVerified;
        verifiedSection["pan"] = isPanVerified;
        verifiedSection["bank"] = isBankVerified;
        verifiedSection["nominee"] = isNomineeVerified;
        userName = data["data"]["userName"] ?? "";
        isPersonalDetail = data["data"]["cdsl_proof"] ?? false;
        profilePicture = data["data"]["profile_img"] ?? "";

        final List<dynamic> plans = data["data"]["userPlans"] ?? [];
        userPlans.clear();
        userPlans.addAll(plans.map((e) => Map<String, dynamic>.from(e)));
        print("userPlans------>>> $isPersonalDetail");
        thisMonth = double.tryParse(data["data"]["thisMonth"].toString()) ?? 0;
        totalInvestments =
            double.tryParse(data["data"]["totalInvestments"].toString()) ?? 0;
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
        print("userData------>>> $data");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
      print("userData1------>>> $e");
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
      print("API Response: $data");
      if (response.statusCode == 200 && data["code"] == 200) {
        final message = data["data"]["message"] ?? "";
        referenceID = data["data"]["reference_id"] ?? 0;
        print("referenceID------>>> $referenceID");
        await saveAadhaar(number.toString());
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: AppColors.greenCircleColor,
        );
        setLoading(false);
        if (message.contains("OTP")) {
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

  // Future<void> verifyAadhaarOTP(
  //   context,
  //   String otp,
  //   int referenceId,
  //   String aadhaarNumber,
  // ) async {
  //   setLoading(true);
  //   print("referenceId--->>> $referenceId---$otp---$aadhaarNumber");
  //   final url = Uri.parse("${AppStrings.baseURL}aadhaar/verify-otp");
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "Bearer $authToken",
  //       },
  //       body: jsonEncode({
  //         "reference_id": referenceId.toString(),
  //         "aadhaar_number": aadhaarNumber.toString(),
  //         "otp": otp,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> json = jsonDecode(response.body);
  //       print("API Response----->>> $json");
  //       final aadhaarResponse = AadhaarResponse.fromJson(json);
  //       final String aadhaarNumber = json['aadhaar_number'] ?? '';
  //       print("aadhaarNumber----->>> $aadhaarNumber");
  //       setAadhaarResponse(aadhaarResponse);
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("aadhaar_name", aadhaarResponse.data.name);
  //       await prefs.setString("aadhaar_photo", aadhaarResponse.data.photo);
  //       await prefs.setString("aadhaar_number", aadhaarNumber);
  //       userName = aadhaarResponse.data.name;
  //       await statusUpdateNavigate(context, "aadhaar");
  //       AppSnackBar.show(
  //         context,
  //         message: aadhaarResponse.data.message,
  //         backgroundColor: AppColors.greenCircleColor,
  //       );
  //       notifyListeners();
  //       setLoading(false);
  //     } else {
  //       print("API Responseerr----->>> ${response.body}");
  //       final Map<String, dynamic> error = jsonDecode(response.body);
  //       AppSnackBar.show(
  //         context,
  //         message: error["message"] ?? "Something went wrong",
  //       );
  //       setLoading(false);
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     AppSnackBar.show(context, message: "$e");
  //     print("API Responsecatch----->>> $e");
  //   }
  // }

  Future<void> verifyAadhaarOTP(
    context,
    String otp,
    int referenceId,
    String aadhaarNumber,
  ) async {
    setLoading(true);
    print("referenceId--->>> $referenceId---$otp---$aadhaarNumber");

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
        final decoded = jsonDecode(response.body);

        Map<String, dynamic> json;
        if (decoded is List && decoded.isNotEmpty) {
          json = decoded[0] as Map<String, dynamic>;
        } else if (decoded is Map<String, dynamic>) {
          json = decoded;
        } else {
          throw Exception("Unexpected API format");
        }

        final aadhaarResponse = AadhaarResponse.fromJson(json);

        print("aadhaarNumber----->>> $aadhaarNumber");

        setAadhaarResponse(aadhaarResponse);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("aadhaar_name", aadhaarResponse.data.name);
        await prefs.setString("aadhaar_photo", aadhaarResponse.data.photo);
        await prefs.setString("aadhaar_number", aadhaarNumber);

        userName = aadhaarResponse.data.name;

        await statusUpdateNavigate(context, "aadhaar");

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
      print("API Responsecatch----->>> $e");
    }
  }

  void startTimer({int duration = 30}) {
    _timer?.cancel();

    _seconds = duration;
    _canResend = false;
    notifyListeners();

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

  void stopTimer() {
    _timer?.cancel();
    _canResend = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> resendAadhaarOTP(context) async {
    final aadhaar = await getAadhaar();
    print("aadhaar---$aadhaar");
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

      if (response.statusCode == 200 && data["code"] == 200) {
        final message = data["data"]["message"] ?? "";
        resendReferenceID = data["data"]["reference_id"] ?? 0;
        if (message.toString().contains("successfully")) {
          startTimer(duration: 60);
          AppSnackBar.show(
            context,
            message: message,
            backgroundColor: AppColors.greenCircleColor,
          );
          setLoading(false);
        } else {
          setLoading(false);
          AppSnackBar.show(context, message: message);
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
          "pan": panNumber,
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
          await sendDeviceToken(context);
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

  Future<void> sendDeviceToken(context) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        AppSnackBar.show(context, message: "Unable to get device token");
        return;
      }
      setLoading(true);
      final url = Uri.parse("${AppStrings.baseURL}user/device/register");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({"device_token": token}),
      );

      final data = jsonDecode(response.body);
      print("API Response: $data");

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("device_token", token);
        print("Device-->> $token");
        setLoading(false);
      } else {
        setLoading(false);
        AppSnackBar.show(context, message: "Failed to send token");
      }
    } catch (e) {
      setLoading(false);
      AppSnackBar.show(context, message: e.toString());
      print("Error: $e");
    }
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
}
