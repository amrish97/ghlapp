import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';

mixin OtpMixin on ChangeNotifier {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> messages = [];

  Future<void> checkAndLoadSms(BuildContext context) async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted ?? false) {
      List<SmsMessage> smsList = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      messages = smsList;
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SMS permission is required")),
      );
    }
  }
}
