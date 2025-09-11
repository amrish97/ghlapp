import 'dart:io';

import 'package:ghlapp/resources/AppString.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
          child: child!,
        );
      },
    );
  }

  MethodChannel locationChannel = MethodChannel('close');

  void closeApp() {
    if (Platform.isAndroid) {
      locationChannel.invokeMethod('closeApp');
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  String formatIndianNumber(int number) {
    final formatter = NumberFormat.decimalPattern('en_IN');
    return formatter.format(number);
  }
}
