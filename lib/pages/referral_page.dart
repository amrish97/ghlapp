import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/dotted_border.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height / 1.8,
            ),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: AppColors.screenBgColor,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                height: MediaQuery.of(context).size.height / 1.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.brownColor],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.black,
                              size: 20,
                            ),
                          ).toGesture(
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: PrimaryText(
                              text: "help?",
                              color: AppColors.white,
                              weight: AppFont.semiBold,
                              size: AppDimen.textSize12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      PrimaryText(
                        text: "Refer your friends \n and earn",
                        color: AppColors.white,
                        weight: AppFont.semiBold,
                        size: AppDimen.textSize24,
                      ),
                      "assets/images/reward.png".toImageAsset(),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "assets/images/dollar.png".toImageAsset(),
                          SizedBox(width: 3),
                          PrimaryText(
                            text: "100",
                            color: AppColors.white,
                            weight: AppFont.semiBold,
                            size: AppDimen.textSize18,
                          ),
                        ],
                      ),
                      PrimaryText(
                        text: "Loyalty points",
                        color: AppColors.white,
                        weight: AppFont.regular,
                        size: AppDimen.textSize12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: PrimaryText(
                  text:
                      "Your friend gets 100 Timespoint on signup and,you get 100 Time Points too everytime!",
                  color: AppColors.black,
                  weight: AppFont.medium,
                  align: TextAlign.center,
                  size: AppDimen.textSize14,
                ),
              ),
              SizedBox(height: 20),
              DottedBorder(
                color: AppColors.brownColor,
                dash: 6,
                gap: 5,
                strokeWidth: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.7,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(248, 34, 34, 0.17),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryText(
                            text: "Your Referral Code",
                            color: AppColors.lightGrey,
                            weight: AppFont.medium,
                            align: TextAlign.center,
                            size: AppDimen.textSize12,
                          ),
                          const SizedBox(height: 5),
                          PrimaryText(
                            text: value.referralCode.toString().trim(),
                            weight: AppFont.medium,
                            align: TextAlign.center,
                            size: AppDimen.textSize20,
                          ),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.grey),
                      PrimaryText(
                        text: "Copy \nCode",
                        color: AppColors.black,
                        weight: AppFont.medium,
                        align: TextAlign.center,
                        size: AppDimen.textSize14,
                      ).toGesture(
                        onTap: () {
                          copyReferralCode(
                            value.referralCode.toString().trim(),
                            context,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              PrimaryText(
                text: "Share your referral Code Via",
                color: AppColors.black,
                weight: AppFont.medium,
                align: TextAlign.center,
                size: AppDimen.textSize14,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "Share Now",
                onTap: () async {
                  await shareReferralCode(
                    value.referralCode.toString().trim(),
                    context,
                  );
                },
                iconWidget: Icon(Icons.share, color: AppColors.white),
                width: MediaQuery.of(context).size.width / 1.7,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> shareReferralCode(String code, BuildContext context) async {
    final String message =
        "Hey! Use my referral code: $code to sign up and get rewards";
    final box = context.findRenderObject() as RenderBox?;
    final Rect? sharePositionOrigin =
        box != null ? box.localToGlobal(Offset.zero) & box.size : null;
    final result = await SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: "My Referral Code",
        sharePositionOrigin: sharePositionOrigin,
      ),
    );

    if (result.status == ShareResultStatus.success) {
      print("Shared successfully");
    } else if (result.status == ShareResultStatus.dismissed) {
      print("Share dismissed");
    } else {
      print("Share failed or unavailable");
    }
  }

  void copyReferralCode(String code, BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
  }
}
