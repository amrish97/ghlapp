import 'package:flutter/material.dart';
import 'package:ghlapp/pages/Investment/investment_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/aboutus/aboutus_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/blog/blog.dart';
import 'package:ghlapp/pages/SideDrawerSection/contactus/contact_us_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/economy/economyInsght_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/educational_video/education_video_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/financial/financial_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/htmlcontent/privacy_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/htmlcontent/terms_page.dart';
import 'package:ghlapp/pages/SideDrawerSection/referral/referral_page.dart';
import 'package:ghlapp/pages/bottom_navigation.dart';
import 'package:ghlapp/pages/faq/faq_page.dart';
import 'package:ghlapp/pages/home_page.dart';
import 'package:ghlapp/pages/kyc/kyc_page.dart';
import 'package:ghlapp/pages/login/login_page.dart';
import 'package:ghlapp/pages/login/onboard_page.dart';
import 'package:ghlapp/pages/login/otp_page.dart';
import 'package:ghlapp/pages/login/splash_page.dart';
import 'package:ghlapp/pages/notification_page.dart';
import 'package:ghlapp/pages/profile/chat_page.dart';
import 'package:ghlapp/pages/profile/document/document_page.dart';
import 'package:ghlapp/pages/profile/personal_detail.dart';
import 'package:ghlapp/pages/profile/portfolio/portfolio_page.dart';
import 'package:ghlapp/pages/profile/profile_page.dart';

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
    AppRouteEnum.investment.name: (context) => InvestmentPage(),
    AppRouteEnum.referral.name: (context) => ReferralPage(),
    AppRouteEnum.educationalVideo.name: (context) => EducationalVideoPage(),
    AppRouteEnum.contactUs.name: (context) => ContactUsPage(),
    AppRouteEnum.blog.name: (context) => Blog(),
    AppRouteEnum.financialIQ.name: (context) => FinancialPage(),
    AppRouteEnum.economyInsights.name: (context) => EconomyInsightPage(),
    AppRouteEnum.chat.name: (context) => ChatPage(),
    AppRouteEnum.faq.name: (context) => FaqPage(),
    AppRouteEnum.portfolio.name: (context) => PortfolioPage(),
    AppRouteEnum.privacy.name: (context) => PrivacyShowPage(),
    AppRouteEnum.terms.name: (context) => TermsShowPage(),
    AppRouteEnum.about.name: (context) => AboutPage(),
    AppRouteEnum.notification.name: (context) => NotificationPage(),
    AppRouteEnum.personalDetail.name: (context) => PersonalDetailPage(),
    AppRouteEnum.documentView.name: (context) => DocumentPage(),
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
  investment,
  referral,
  educationalVideo,
  contactUs,
  blog,
  financialIQ,
  economyInsights,
  chat,
  faq,
  portfolio,
  privacy,
  terms,
  about,
  notification,
  personalDetail,
  documentView,
}
