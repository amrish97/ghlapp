import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin ReferralMixin on ChangeNotifier {
  String referralCode = "";

  void getReferralCode(context) async {
    final url = Uri.parse("${AppStrings.baseURL}refer-earn");
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
        referralCode = data["refferalId"];
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
