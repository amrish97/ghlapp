import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dhlapp/providers/mixin/otp_mixin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier with OtpMixin {
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  bool get getIsLoading => isLoading;

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool _isLocationServiceEnabled = false;
  Position? _currentPosition;
  String? _deviceId;
  String? get deviceId => _deviceId;

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
      await Geolocator.openLocationSettings(); // ask user to enable GPS
    }

    notifyListeners();
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    );
    notifyListeners();
  }

  Future<void> initDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('device_id');

    if (_deviceId == null) {
      _deviceId = await getSystemDeviceId();
      await prefs.setString('device_id', _deviceId!);
    }

    notifyListeners();
  }

  Future<String?> getSystemDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS unique ID
    }
    return null;
  }
}
