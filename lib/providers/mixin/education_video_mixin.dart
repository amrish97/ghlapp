import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin EducationVideoMixin on ChangeNotifier {
  final List<Map<String, dynamic>> educationalVideo = [];

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
        print("res---> $educationalVideo");
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }
}
