import 'package:flutter/material.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.screenBgColor,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
            child: Row(
              children: [
                getBackButton(context),
                SizedBox(width: 10),
                PrimaryText(
                  text: "Notification",
                  weight: AppFont.semiBold,
                  size: AppDimen.textSize16,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.screenBgColor,
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          final allVerified = value.verifiedSection.values.every(
            (v) => v == true,
          );
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              spacing: 20,
              children: [
                getContainerView(
                  title: AppStrings.completeKyc,
                  content:
                      "As per regulatory guidelines, it is mandatory to update your KYC ",
                  image: "assets/images/timer.png",
                  verified: !allVerified,
                ).toGesture(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouteEnum.kyc.name);
                  },
                ),
                getContainerView(
                  title: AppStrings.completeProfile,
                  content:
                      "As per regulatory guidelines, it is mandatory to update your KYC ",
                  image: "assets/images/timer.png",
                  verified: true,
                ).toGesture(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouteEnum.personalDetail.name,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getContainerView({
    required String image,
    required String title,
    required String content,
    required bool verified,
  }) {
    return Visibility(
      visible: verified,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, scale: 2, height: 50),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: title,
                    weight: AppFont.medium,
                    size: AppDimen.textSize12,
                    align: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                  PrimaryText(
                    text: content,
                    weight: AppFont.regular,
                    size: AppDimen.textSize12,
                    align: TextAlign.start,
                    color: AppColors.notificationCardColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
