import 'package:flutter/material.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: 2.0),
            duration: Duration(seconds: 3),
            curve: Curves.bounceOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            onEnd: () async {
              final prefs = await SharedPreferences.getInstance();
              authToken = prefs.getString("auth_token") ?? "";
              if (authToken.isNotEmpty) {
                print("token--->> $authToken");
                if (context.mounted) {
                  Navigator.pushNamed(context, AppRouteEnum.bottomPage.name);
                }
              } else {
                if (context.mounted) {
                  Navigator.pushNamed(context, AppRouteEnum.onboard.name);
                }
              }
            },
            child: 'assets/images/ghl-logo.png'.toString().toImageAsset(
              scale: 2,
            ),
          ),
        ),
      ),
    );
  }
}
