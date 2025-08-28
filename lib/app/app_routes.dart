import 'package:dhlapp/pages/bottom_navigation.dart';
import 'package:dhlapp/pages/home_page.dart';
import 'package:dhlapp/pages/login_page.dart';
import 'package:dhlapp/pages/otp_page.dart';
import 'package:dhlapp/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    AppRouteEnum.splash.name: (context) => const SplashPage(),
    AppRouteEnum.login.name: (context) => const LoginPage(),
    AppRouteEnum.verifyPhone.name: (context) => OtpPage(),
    AppRouteEnum.bottomPage.name: (context) => BottomNavigationPage(),
    AppRouteEnum.home.name: (context) => HomePage(),
  };
}

enum AppRouteEnum { splash, login, verifyPhone, bottomPage, home }
