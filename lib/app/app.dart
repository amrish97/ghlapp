import 'package:flutter/material.dart';
import 'package:dhlapp/app/app_routes.dart';
import 'package:dhlapp/resources/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GHL INDIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      initialRoute: AppRouteEnum.splash.name,
      routes: AppRoutes.routes,
    );
  }
}
