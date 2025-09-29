import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

mixin KycMixin on ChangeNotifier {
  List<Map<String, dynamic>> bankDetail = [];
  String kycStatus = "";

  Future<void> getKycStatus(context) async {
    final url = Uri.parse("${AppStrings.baseURL}kyc/status");
    try {
      final res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        kycStatus = data["kyc_status"].toString();
        print("userStatus--->> $kycStatus");
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: "Error ${res.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
    notifyListeners();
  }

  Future<void> getBankDetails(context, {required int id}) async {
    print("id---> $id");
    final url = Uri.parse("${AppStrings.baseURL}account/details/$id");
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
        bankDetail.clear();
        bankDetail.add(data);
        print("getDetail--->> $data");
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
    notifyListeners();
  }
}
