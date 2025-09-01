import 'package:dhlapp/providers/mixin/bottomNav_mixin.dart';
import 'package:dhlapp/providers/mixin/social_mixin.dart';
import 'package:dhlapp/providers/mixin/verification_mixin.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier
    with BottomNavigationMixin, SocialLoginMixin, VerificationMixin {
  HomeProvider() {
    loadVerifiedSections();
  }

  Future<void> userDashboardAPI() async {
    final url = Uri.parse("");
    notifyListeners();
  }
}
