import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/connectivity_listener.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      initialRoute: AppRouteEnum.splash.name,
      routes: AppRoutes.routes,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: const TextScaler.linear(1.0),
            devicePixelRatio: 1.0,
          ),
          child: ConnectivityListener(child: child!),
        );
      },
    );
  }
}

class BaseFunction {
  MethodChannel locationChannel = MethodChannel('close');

  void closeApp() {
    if (Platform.isAndroid) {
      locationChannel.invokeMethod('closeApp');
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  Future<bool> onUrlLaunch(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        print("Could not launch $url");
        return false;
      }
    } catch (e) {
      print("Error launching url: $e");
      return false;
    }
  }

  String formatIndianNumber(int number) {
    final formatter = NumberFormat.decimalPattern('en_IN');
    return formatter.format(number);
  }

  String getMonthFromTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[date.month - 1];
  }
}
