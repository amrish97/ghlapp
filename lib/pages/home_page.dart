import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/pages/html_content_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../widgets/chart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //context.read<HomeProvider>().requestPermissionAndLoadSms(context);
      context.read<HomeProvider>().loadVerifiedSections(
        context,
        fetchApi: true,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        final allVerified = value.verifiedSection.values.every(
          (v) => v == true,
        );
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              App().closeApp();
            }
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                backgroundColor: AppColors.screenBgColor,
                automaticallyImplyLeading: false,
                forceMaterialTransparency: true,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: getProfile(
                    value,
                    scaffoldKey: scaffoldKey,
                    context: context,
                  ),
                ),
              ),
            ),
            backgroundColor: AppColors.screenBgColor,
            body: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kycCard(!allVerified, context),
                            SizedBox(height: 20),
                            PrimaryText(
                              text: "Total Investment",
                              size: 16,
                              weight: AppFont.regular,
                              color: AppColors.textColorLightBlack,
                            ),
                            Row(
                              children: [
                                SizedBox(height: 10),
                                Icon(Icons.currency_rupee, size: 30),
                                PrimaryText(
                                  text: "7,645.25",
                                  size: 36,
                                  weight: AppFont.semiBold,
                                  color: AppColors.black,
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    PrimaryText(
                                      text: " +25.52%",
                                      color: Color(0xFF628C5E),
                                      size: 16,
                                      weight: AppFont.medium,
                                    ),
                                    PrimaryText(
                                      text: " Last Month",
                                      color: Colors.black,
                                      size: 12,
                                      weight: AppFont.medium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                getCommonButton(
                                  context,
                                  imageData: "assets/images/inverstment.png",
                                  text: "Investment",
                                  onTap: () {
                                    value.setIndex(1, context);
                                  },
                                ),
                                SizedBox(width: 10),
                                getCommonButton(
                                  context,
                                  imageData: "assets/images/referal.png",
                                  text: "Referral",
                                  onTap: () async {
                                    await value.getReferralCode(context);
                                    Navigator.pushNamed(
                                      context,
                                      AppRouteEnum.referral.name,
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PrimaryText(
                                        text: "Operations",
                                        size: 16,
                                        weight: AppFont.semiBold,
                                      ),
                                      PrimaryText(
                                        text: "View All",
                                        size: 14,
                                        weight: AppFont.regular,
                                        color: AppColors.lightGrey,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.currency_rupee, size: 25),
                                      PrimaryText(
                                        text: "9,645.25",
                                        size: 32,
                                        weight: AppFont.semiBold,
                                        color: AppColors.black,
                                      ),
                                      SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: PrimaryText(
                                          text: "Spend this month",
                                          size: 14,
                                          weight: AppFont.medium,
                                          color: AppColors.lightGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    height: 10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.greenCircleColor,
                                          AppColors.greenCircleColor,
                                          Colors.blue,
                                          Colors.blue,
                                          Colors.red,
                                          Colors.red,
                                          AppColors.yellowShadeColor,
                                          AppColors.yellowShadeColor,
                                          AppColors.lightGrey,
                                          AppColors.lightGrey,
                                        ],
                                        stops: [
                                          0.0,
                                          0.3,
                                          0.3,
                                          0.4,
                                          0.4,
                                          0.5,
                                          0.5,
                                          0.7,
                                          0.7,
                                          1.0,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: "My Investment",
                                    size: AppDimen.textSize16,
                                    weight: AppFont.semiBold,
                                    color: AppColors.black,
                                  ),
                                  SizedBox(height: 10),
                                  LineChart(),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            drawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: ColoredBox(
                  color: AppColors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        color: AppColors.primary,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    Image.asset(
                                      value.photoUrl ??
                                          "assets/images/user.png",
                                    ).image,
                              ),
                              const SizedBox(height: 10),
                              PrimaryText(
                                text:
                                    aadhaarName.toString().isEmpty
                                        ? "User"
                                        : aadhaarName.toString(),
                                size: AppDimen.textSize16,
                                color: AppColors.white,
                                weight: AppFont.semiBold,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: getSideBarInfo(context, data: value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getCommonButton(
    context, {
    required String imageData,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageData.toImageAsset(),
            SizedBox(width: 10),
            PrimaryText(
              text: text,
              color: AppColors.white,
              weight: AppFont.semiBold,
              size: 16,
            ),
          ],
        ),
      ).toGesture(onTap: onTap),
    );
  }

  Widget getSideBarInfo(context, {required HomeProvider data}) {
    final List<Map<String, dynamic>> imageData = [
      {
        "image": "assets/images/profile.png",
        "onTap": () {
          Navigator.pushNamed(context, AppRouteEnum.profile.name);
        },
        "title": "profile",
      },
      {
        "image": "assets/images/calc.png",
        "onTap": () {},
        "title": "Investment Calculator",
      },
      {
        "image": "assets/images/blog.png",
        "onTap": () async {
          Navigator.pop(context);
          await data.getBlog(context);
          await Future.delayed(Duration(milliseconds: 130));
          Navigator.pushNamed(context, AppRouteEnum.blog.name);
        },
        "title": "Blogs",
      },
      {
        "image": "assets/images/video.png",
        "onTap": () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouteEnum.educationalVideo.name);
        },
        "title": "Educational Videos",
      },
      {
        "image": "assets/images/economy.png",
        "onTap": () async {
          Navigator.pop(context);
          await data.getEconomicInsights(context);
          await Future.delayed(Duration(milliseconds: 130));
          Navigator.pushNamed(context, AppRouteEnum.economyInsights.name);
        },
        "title": "Economy Insights",
      },
      {
        "image": "assets/images/finance.png",
        "onTap": () async {
          Navigator.pop(context);
          await data.getFinancialData(context);
          await Future.delayed(Duration(milliseconds: 130));
          Navigator.pushNamed(context, AppRouteEnum.financialIQ.name);
        },
        "title": "Financial IQ",
      },
      {
        "image": "assets/images/refer.png",
        "onTap": () async {
          Navigator.pop(context);
          await data.getReferralCode(context);
          await Future.delayed(Duration(milliseconds: 130));
          Navigator.pushNamed(context, AppRouteEnum.referral.name);
        },
        "title": "Refer & Earn",
      },
      {
        "image": "assets/images/terms.png",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HtmlContentView(
                    isFrom: AppStrings.termsCondition,
                    showTermsPrivacy: true,
                  ),
            ),
          );
        },
        "title": AppStrings.termsCondition,
      },
      {
        "image": "assets/images/privacy.png",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HtmlContentView(
                    isFrom: 'Privacy policy',
                    showTermsPrivacy: false,
                  ),
            ),
          );
        },
        "title": "Privacy Policy",
      },
      {
        "image": "assets/images/contact.png",
        "onTap": () async {
          Navigator.pop(context);
          await Future.delayed(Duration(milliseconds: 130));
          Navigator.pushNamed(context, AppRouteEnum.contactUs.name);
        },
        "title": "Contact Us",
      },
      {"image": "assets/images/about.png", "onTap": () {}, "title": "About Us"},
      {
        "image": "assets/images/milestone.png",
        "onTap": () {},
        "title": "Milestone",
      },
      {
        "image": "assets/images/disclimar.png",
        "onTap": () {},
        "title": "Disclaimer",
      },
      {"image": "assets/images/logout.png", "onTap": () {}, "title": "Logout"},
    ];
    return SingleChildScrollView(
      child: Column(
        children:
            imageData.asMap().entries.map((entry) {
              final data = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    data["image"].toString().toImageAsset(
                      color: AppColors.black,
                    ),
                    SizedBox(width: 10),
                    PrimaryText(
                      text: data["title"],
                      size: AppDimen.textSize14,
                      weight: AppFont.semiBold,
                    ),
                  ],
                ),
              ).toGesture(onTap: data["onTap"]);
            }).toList(),
      ),
    );
  }

  Widget kycCard(bool isVerified, context) {
    return Visibility(
      visible: isVerified,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryLight,
        ),
        child: Row(
          children: [
            "assets/images/timer.png".toImageAsset(),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryText(
                  text: "KYC is Pending",
                  size: 15,
                  weight: AppFont.semiBold,
                  color: AppColors.black,
                ),
                PrimaryText(
                  text: "Please Fill the KYC",
                  size: 12,
                  weight: AppFont.semiBold,
                  color: AppColors.black,
                ),
              ],
            ),
            Spacer(),
            "assets/images/circleArrow.png".toImageAsset(),
          ],
        ).toGesture(
          onTap: () {
            Navigator.pushNamed(context, AppRouteEnum.kyc.name);
          },
        ),
      ),
    );
  }

  Widget getProfile(
    HomeProvider value, {
    required scaffoldKey,
    required context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 10),
        CircleAvatar(
          backgroundImage:
              Image.asset(value.photoUrl ?? "assets/images/user.png").image,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text:
                  aadhaarName.toString().isEmpty
                      ? "User"
                      : aadhaarName.toString(),
              size: AppDimen.textSize14,
              weight: AppFont.semiBold,
              maxLines: 1,
              color: AppColors.black,
            ),
            PrimaryText(
              text: "Welcome Back!",
              size: AppDimen.textSize14,
              weight: AppFont.regular,
              maxLines: 1,
              color: AppColors.lightGrey,
            ),
          ],
        ),
        Spacer(),
        getRowIcon(
          selectedIndex: 0,
          scaffoldKey: scaffoldKey,
          context: context,
        ),
        SizedBox(width: 5),
      ],
    );
  }

  Widget getRowIcon({
    int selectedIndex = 0,
    required scaffoldKey,
    required context,
  }) {
    final List<Map<String, dynamic>> icons = [
      {
        "image": "assets/images/info.png",
        "onTap": () {
          Navigator.pushNamed(context, AppRouteEnum.kyc.name);
        },
      },
      {
        "image": "assets/images/Vector-notification.png",
        "onTap": () {
          scaffoldKey.currentState?.openDrawer();
        },
      },
      {
        "image": "assets/images/Vector3.png",
        "onTap": () {
          debugPrint("Notification tapped");
        },
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(icons.length, (index) {
        final entry = icons[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == selectedIndex ? AppColors.primary : AppColors.white,
          ),
          child: Image.asset(
            entry["image"],
            scale: 3.5,
            color: index == selectedIndex ? null : AppColors.black,
          ),
        ).toGesture(onTap: entry["onTap"]);
      }),
    );
  }
}
