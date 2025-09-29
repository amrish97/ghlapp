import 'package:flutter/material.dart';
import 'package:ghlapp/pages/kyc/verification_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class KycPage extends StatefulWidget {
  const KycPage({super.key});

  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  @override
  void initState() {
    context.read<HomeProvider>().loadVerifiedSections(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        final allVerified = value.verifiedSection.values.every(
          (v) => v == true,
        );
        return Scaffold(
          backgroundColor: AppColors.screenBgColor,
          body: LayoutBuilder(
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryText(
                  text:
                      "As per regulatory guidelines, it is mandatory to update your KYC (Know Your Customer) details to continue using our services.",
                  size: AppDimen.textSize14,
                  align: TextAlign.start,
                  weight: AppFont.medium,
                ),
                const SizedBox(height: 5),
                CustomButton(
                  text: allVerified ? AppStrings.done : AppStrings.gotIt,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
            final isVerified = provider.verifiedSection[item["key"]] ?? false;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                    child: item["image"].toString().toImageAsset(),
                  ),
                  const SizedBox(width: 20),
                  PrimaryText(
                    text: item["title"],
                    size: AppDimen.textSize16,
                    weight: AppFont.semiBold,
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
            ).toGesture(
              onTap: () {
                if (!isVerified) {
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
                }
              },
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
              getBackButton(context),
              const SizedBox(width: 20),
              PrimaryText(
                text: AppStrings.kycInformation,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: AppStrings.personalDetail,
                        size: AppDimen.textSize16,
                        color: AppColors.white,
                        weight: AppFont.semiBold,
                      ),
                      PrimaryText(
                        text: "Please fill in your personal details to proceed",
                        size: AppDimen.textSize12,
                        color: AppColors.white,
                        weight: AppFont.regular,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
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
