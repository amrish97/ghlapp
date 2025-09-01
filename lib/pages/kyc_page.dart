import 'package:dhlapp/pages/verification_page.dart';
import 'package:dhlapp/providers/home_provider.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_dimention.dart';
import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/widgets/custom_button.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KycPage extends StatelessWidget {
  const KycPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTopSection(context, progress: value.progress),
                        const SizedBox(height: 20),
                        getBottomSection(context, provider: value),
                        const SizedBox(height: 20),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              PrimaryText(
                                text:
                                    "Lorem ipsum dolor sit amet consectetur. Arcu lacus netus enim tempus at. Ornare quis ipsum quis sodales orci turpis.",
                                size: AppDimen.textSize14,
                                align: TextAlign.start,
                                weight: AppFont.medium,
                                color: AppColors.black,
                              ),
                              const SizedBox(height: 20),
                              CustomButton(text: "Got it", onTap: () {}),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget getBottomSection(
    BuildContext context, {
    required HomeProvider provider,
  }) {
    List<Map<String, dynamic>> setOfData = [
      {
        "key": "aadhaar",
        "image": "assets/images/pan_detail.png",
        "title": "Aadhaar Details",
      },
      {
        "key": "pan",
        "image": "assets/images/pan_detail.png",
        "title": "Pan Details",
      },
      {
        "key": "bank",
        "image": "assets/images/bank.png",
        "title": "Bank Details",
      },
      {
        "key": "nominee",
        "image": "assets/images/user-plus.png",
        "title": "Nominee Details",
      },
    ];
    return Column(
      children:
          setOfData.map((item) {
            bool isVerified = provider.verifiedSection[item["key"]] ?? false;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VerificationPage(
                          routeName: item["title"],
                          isFrom: item["key"],
                        ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight,
                      ),
                      child: Image.asset(item["image"], scale: 3),
                    ),
                    const SizedBox(width: 20),
                    PrimaryText(
                      text: item["title"],
                      size: AppDimen.textSize16,
                      weight: AppFont.semiBold,
                      color: AppColors.black,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isVerified
                                ? AppColors.greenCircleColor
                                : AppColors.circleColor,
                      ),
                      child: Icon(
                        isVerified ? Icons.check : Icons.arrow_forward_ios,
                        color: isVerified ? Colors.white : AppColors.black,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget getTopSection(context, {required double progress}) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: AppColors.kycLightColor,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.09),
          child: Row(
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
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
                ),
              ),
              const SizedBox(width: 20),
              PrimaryText(
                text: "KYC Information",
                color: AppColors.black,
                weight: AppFont.semiBold,
                size: AppDimen.textSize20,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
              top: size.height * 0.185,
              right: 30,
              left: 30,
            ),
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.02,
              horizontal: size.width * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(80),
                bottomRight: Radius.circular(80),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: AppColors.primary,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      text: "Personal Detail",
                      size: AppDimen.textSize16,
                      color: AppColors.white,
                      weight: AppFont.semiBold,
                    ),
                    PrimaryText(
                      text: "Lorem ipsum dolor sit amet consectetur.",
                      size: AppDimen.textSize12,
                      color: AppColors.white,
                      weight: AppFont.regular,
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: progress,
                        color: AppColors.yellowShadeColor,
                        strokeWidth: 7,
                        backgroundColor: AppColors.primaryLight,
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
