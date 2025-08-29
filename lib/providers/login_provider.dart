import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dhlapp/app/app_routes.dart';
import 'package:dhlapp/model/device_detail.dart';
import 'package:dhlapp/providers/mixin/otp_mixin.dart';
import 'package:dhlapp/providers/mixin/social_mixin.dart';
import 'package:dhlapp/resources/AppString.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/widgets/custom_snakebar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier with OtpMixin, SocialLoginMixin {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool get getIsLoading => isLoading;

  String? _deviceId;
  String? _deviceModel;
  String? _deviceName;

  String? get deviceId => _deviceId;
  String? get deviceModel => _deviceModel;
  String? get deviceName => _deviceName;

  int _seconds = 30;
  bool _canResend = false;
  Timer? _timer;

  int get seconds => _seconds;
  bool get canResend => _canResend;

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool _isLocationServiceEnabled = false;
  Position? _currentPosition;

  PermissionStatus get permissionStatus => _permissionStatus;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;
  Position? get currentPosition => _currentPosition;

  Future<void> initLocationCheck() async {
    await _checkAppPermission();
    if (_permissionStatus.isGranted) {
      await _checkDeviceLocation();
    }
  }

  Future<void> _checkAppPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    _permissionStatus = status;
    notifyListeners();
  }

  Future<void> _checkDeviceLocation() async {
    _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (_isLocationServiceEnabled) {
      await _getCurrentLocation();
    } else {
      await Geolocator.openLocationSettings();
    }
    notifyListeners();
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    );
    notifyListeners();
  }

  Future<void> sendOtp(context) async {
    await initDeviceInfo();
    final url = Uri.parse(
      "${AppStrings.baseURL}login?template_id=1407172830579892546",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phoneNumberController.text,
          "latitude": currentPosition?.latitude.toString(),
          "longitude": currentPosition?.longitude.toString(),
          "device_id": deviceId,
          "device_model": deviceModel,
          "device_name": deviceName,
        }),
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
        Navigator.pushNamed(context, AppRouteEnum.verifyPhone.name);
      } else {
        final errorMsg =
            data["sms_response"]?["message"] ?? "Something went wrong";
        AppSnackBar.show(context, message: errorMsg);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
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
            backgroundColor: AppColors.primary,
          );
        }
      } else {
        AppSnackBar.show(
          context,
          message: "Error: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("verifyOtp error: $e");
      AppSnackBar.show(context, message: e.toString());
    }

    notifyListeners();
  }

  Future<void> resendOtp(context) async {
    final url = Uri.parse("${AppStrings.baseURL}resend/otp");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumberController.text}),
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

  Future<DeviceDetail?> _getDeviceBasics() async {
    final info = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      final androidId = android.id;
      final model = android.model;
      final name = android.manufacturer;

      return DeviceDetail(
        deviceId: androidId,
        deviceModel: model,
        deviceName: name,
      );
    } else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return DeviceDetail(
        deviceId: ios.identifierForVendor ?? "",
        deviceModel: ios.utsname.machine ?? "",
        deviceName: ios.name,
      );
    }
    return null;
  }

  Future<void> initDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();

    _deviceId = prefs.getString('device_id');
    _deviceModel = prefs.getString('device_model');
    _deviceName = prefs.getString('device_name');

    if (_deviceId == null || _deviceModel == null || _deviceName == null) {
      final basics = await _getDeviceBasics();
      if (basics != null) {
        _deviceId = basics.deviceId;
        _deviceModel = basics.deviceModel;
        _deviceName = basics.deviceName;

        await prefs.setString('device_id', _deviceId!);
        await prefs.setString('device_model', _deviceModel!);
        await prefs.setString('device_name', _deviceName!);
      }
    }

    notifyListeners();
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
