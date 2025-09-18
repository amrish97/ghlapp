import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin SideNavigationMixin on ChangeNotifier {
  final TextEditingController contactusNameController = TextEditingController();
  final TextEditingController contactusEmailController =
      TextEditingController();
  final TextEditingController contactusPhoneNumberController =
      TextEditingController();
  final TextEditingController contactusMessageController =
      TextEditingController();

  final FocusNode contactNameFocus = FocusNode();
  final FocusNode contactEmailFocus = FocusNode();
  final FocusNode contactPhoneFocus = FocusNode();
  final FocusNode contactMessageFocus = FocusNode();

  final List<Map<String, dynamic>> educationalVideo = [];
  final List<Map<String, dynamic>> blogData = [];
  final List<Map<String, dynamic>> financialIQ = [];
  final List<Map<String, dynamic>> economyInsights = [];

  final Map<int, bool> _expandedMap = {};

  bool isExpanded(int index) => _expandedMap[index] ?? false;

  void toggle(int index) {
    _expandedMap[index] = !(_expandedMap[index] ?? false);
    notifyListeners();
  }

  void reset() {
    _expandedMap.clear();
    notifyListeners();
  }

  final MapController mapController = MapController();
  final String _address =
      "2D, Queens Court, 6, Red Cross Rd, beside alsa mall complex, Egmore, Chennai, Tamil Nadu 600008";
  Position? _currentPosition;

  String get address => _address;

  Position? get currentPosition => _currentPosition;

  Future<void> getEducationVideo(context) async {
    final url = Uri.parse("${AppStrings.baseURL}educational/videos");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> video = res["VideoData"] ?? [];
        educationalVideo.clear();
        educationalVideo.addAll(video.map((e) => Map<String, dynamic>.from(e)));
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> getBlog(context) async {
    final url = Uri.parse("${AppStrings.baseURL}blogs");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> blogs = res["Blogs"] ?? [];
        blogData.clear();
        blogData.addAll(blogs.map((e) => Map<String, dynamic>.from(e)));
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> getFinancialData(context) async {
    final url = Uri.parse("${AppStrings.baseURL}financial/iq");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> finance = res["FinancialIQ"] ?? [];
        financialIQ.clear();
        financialIQ.addAll(finance.map((e) => Map<String, dynamic>.from(e)));
        print("financialIQ---->> $finance");

        // Sort
        financialIQ.sort((a, b) {
          DateTime dateA = DateTime.parse(a["create_date"]);
          DateTime dateB = DateTime.parse(b["create_date"]);
          return dateB.compareTo(dateA);
        });
        List<Map<String, dynamic>> latestNews = [financialIQ.first];

        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> getEconomicInsights(context) async {
    final url = Uri.parse("${AppStrings.baseURL}economic/insights");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> economy = res["EconomicInsight"] ?? [];
        economyInsights.clear();
        economyInsights.addAll(
          economy.map((e) => Map<String, dynamic>.from(e)),
        );
        print("economyInsights---->> $economyInsights");
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> contactUs(context) async {
    final url = Uri.parse("${AppStrings.baseURL}contact");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({
          "name": contactusNameController.text,
          "email": contactusEmailController.text,
          "phone": contactusPhoneNumberController.text,
          "message": contactusMessageController.text,
        }),
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(res["message"]);
        AppSnackBar.show(
          context,
          message: res["message"],
          backgroundColor: AppColors.greenCircleColor,
        );
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
