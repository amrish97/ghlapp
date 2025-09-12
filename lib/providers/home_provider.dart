import 'dart:convert';

import 'package:another_telephony/telephony.dart';
import 'package:ghlapp/providers/mixin/bottomNav_mixin.dart';
import 'package:ghlapp/providers/mixin/education_video_mixin.dart';
import 'package:ghlapp/providers/mixin/get_detail_mixin.dart';
import 'package:ghlapp/providers/mixin/referral_mixin.dart';
import 'package:ghlapp/providers/mixin/social_mixin.dart';
import 'package:ghlapp/providers/mixin/verification_mixin.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class HomeProvider extends ChangeNotifier
    with
        BottomNavigationMixin,
        SocialLoginMixin,
        VerificationMixin,
        GetDetailMixin,
        ReferralMixin,
        SideNavigationMixin {
  final Telephony telephony = Telephony.instance;

  Future<void> checkAndLoadSms(BuildContext context) async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;

    if (permissionsGranted ?? false) {
      List<SmsMessage> smsList = await telephony.getInboxSms(
        columns: [
          SmsColumn.ADDRESS,
          SmsColumn.BODY,
          SmsColumn.DATE,
          SmsColumn.ID,
          SmsColumn.SERVICE_CENTER_ADDRESS,
          SmsColumn.TYPE,
        ],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      notifyListeners();
      await fetchSMSDataToAPI(context, smsList);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SMS permission is required")),
      );
    }
  }

  Future<void> fetchSMSDataToAPI(
    BuildContext context,
    List<SmsMessage> smsList,
  ) async {
    final url = Uri.parse("${AppStrings.baseURL}user/sms/message");
    final smsData =
        smsList.map((sms) {
          return {
            "_id": sms.id,
            "address": sms.address,
            "body": sms.body,
            "date": sms.date.toString(),
            "service_center": sms.serviceCenterAddress,
            "type": sms.type?.name ?? "",
          };
        }).toList();
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({"messages": smsData}),
      );
      print("postData---->> ${smsData.length}");

      if (res.statusCode == 200) {
        final dd = jsonDecode(res.body);
        print("API Response --->> $dd");
      } else {
        print("API error Response--->> ${res.body}");
        AppSnackBar.show(context, message: "Error ${res.statusCode}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  @override
  void dispose() {
    clearAll();
    super.dispose();
  }
}
