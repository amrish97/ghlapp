import 'package:ghlapp/pages/Detail_page.dart';
import 'package:ghlapp/pages/bottom_navigation.dart';
import 'package:ghlapp/pages/home_page.dart';
import 'package:ghlapp/pages/Investment/investment_page.dart';
import 'package:ghlapp/pages/kyc_page.dart';
import 'package:ghlapp/pages/login/login_page.dart';
import 'package:ghlapp/pages/login/onboard_page.dart';
import 'package:ghlapp/pages/login/otp_page.dart';
import 'package:ghlapp/pages/profile_page.dart';
import 'package:ghlapp/pages/login/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/pages/referral_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    AppRouteEnum.splash.name: (context) => const SplashPage(),
    AppRouteEnum.onboard.name: (context) => OnboardPage(),
    AppRouteEnum.login.name: (context) => const LoginPage(),
    AppRouteEnum.verifyPhone.name: (context) => OtpPage(),
    AppRouteEnum.bottomPage.name: (context) => BottomNavigationPage(),
    AppRouteEnum.home.name: (context) => HomePage(),
    AppRouteEnum.profile.name: (context) => ProfilePage(),
    AppRouteEnum.kyc.name: (context) => KycPage(),
    AppRouteEnum.detailPage.name: (context) => DetailPage(),
    AppRouteEnum.investment.name: (context) => InvestmentPage(),
    AppRouteEnum.referral.name: (context) => ReferralPage(),
  };
}

enum AppRouteEnum {
  splash,
  onboard,
  login,
  verifyPhone,
  bottomPage,
  home,
  profile,
  kyc,
  detailPage,
  investment,
  referral,
}
