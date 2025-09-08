import 'package:ghlapp/pages/Detail_page.dart';
import 'package:ghlapp/pages/bottom_navigation.dart';
import 'package:ghlapp/pages/home_page.dart';
import 'package:ghlapp/pages/investment_page.dart';
import 'package:ghlapp/pages/kyc_page.dart';
import 'package:ghlapp/pages/login_page.dart';
import 'package:ghlapp/pages/onboard_page.dart';
import 'package:ghlapp/pages/otp_page.dart';
import 'package:ghlapp/pages/profile_page.dart';
import 'package:ghlapp/pages/splash_page.dart';
import 'package:flutter/material.dart';

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
}
