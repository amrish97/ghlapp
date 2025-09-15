import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/model/device_detail.dart';
import 'package:ghlapp/providers/mixin/social_mixin.dart';
import 'package:ghlapp/providers/mixin/verification_mixin.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier
    with SocialLoginMixin, VerificationMixin {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController aadhaarVerifyOTPController = TextEditingController();

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
    print("isLocationServiceEnabled--->>> $_isLocationServiceEnabled");
    if (_isLocationServiceEnabled) {
      await _getCurrentLocation();
    } else {
      await Geolocator.openLocationSettings();
    }
    notifyListeners();
  }

  Future<void> _getCurrentLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = pos;
    print("pos--->>> $pos");
    notifyListeners();
  }

  Future<void> sendOtp(context) async {
    setLoading(true);
    if (currentPosition == null) {
      initLocationCheck();
    } else if (currentPosition!.latitude.toString().isEmpty ||
        currentPosition!.longitude.toString().isEmpty) {
      initLocationCheck();
    }
    await initDeviceInfo();
    final url = Uri.parse(
      "${AppStrings.baseURL}login?template_id=1407172830579892546",
    );
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "phone": phoneNumberController.text.trim(),
          "latitude": currentPosition?.latitude.toString(),
          "longitude": currentPosition?.longitude.toString(),
          "device_id": deviceId,
          "device_model": deviceModel,
          "device_name": deviceName,
        }),
      );
      final data = jsonDecode(response.body);
      print("res--->> $data");
      if (data["sms_response"]?["status"] == "success") {
        final message =
            data["sms_response"]?["message"] ?? "OTP Sent Successfully";
        AppSnackBar.show(
          context,
          message: message,
          backgroundColor: AppColors.greenCircleColor,
        );
        setLoading(false);
        Navigator.pushNamed(context, AppRouteEnum.verifyPhone.name);
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
        deviceModel: ios.utsname.machine,
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

  void startTimerLogin() {
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
    otpController.clear();
    super.dispose();
  }
}
