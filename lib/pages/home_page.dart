import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/chart_page.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // context.read<HomeProvider>().requestPermissionAndLoadSms(context);
      context.read<HomeProvider>().loadVerifiedSections(context);
      context.read<HomeProvider>().getFAQData(context);
      requestFirebaseNotificationPermission();
      final prefs = await SharedPreferences.getInstance();
      final device = prefs.getString("device_token") ?? "";
      print("authToken---->> $device");
    });
    super.initState();
  }

  Future<void> requestFirebaseNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        final investments = buildMonthlyInvestments(value.userPlans);
        final List<Color> baseColors = [
          Colors.green,
          Colors.blue,
          Colors.red,
          Colors.yellow,
          Colors.grey,
        ];
        final allVerified = value.verifiedSection.values.every(
          (v) => v == true,
        );
        final count =
            (allVerified && value.isPersonalDetail) == true
                ? 0
                : allVerified == true
                ? 1
                : 2;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              BaseFunction().closeApp();
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
                    count: count,
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
                            const SizedBox(height: 20),
                            PrimaryText(
                              text: AppStrings.totalInvest,
                              size: 16,
                              weight: AppFont.regular,
                              color: AppColors.textColorLightBlack,
                            ),
                            PrimaryText(
                              text:
                                  "\u20B9 ${value.totalInvestments.toString()}",
                              size: 36,
                              weight: AppFont.semiBold,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                getCommonButton(
                                  context,
                                  imageData: "assets/images/inverstment.png",
                                  text: AppStrings.invest,
                                  onTap: () {
                                    value.setIndex(1, context);
                                  },
                                ),
                                const SizedBox(width: 10),
                                getCommonButton(
                                  context,
                                  imageData: "assets/images/referal.png",
                                  text: AppStrings.referral,
                                  onTap: () {
                                    value.getReferralCode(context);
                                    Navigator.pushNamed(
                                      context,
                                      AppRouteEnum.referral.name,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
                                        text: AppStrings.thisMonth,
                                        size: AppDimen.textSize16,
                                        weight: AppFont.semiBold,
                                      ),
                                      PrimaryText(
                                        text: AppStrings.viewAll,
                                        size: AppDimen.textSize14,
                                        weight: AppFont.regular,
                                        color: AppColors.lightGrey,
                                      ).toGesture(
                                        onTap: () {
                                          value.setIndex(3, context);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      PrimaryText(
                                        text:
                                            "\u20B9 ${value.thisMonth.toString()}",
                                        size: 32,
                                        weight: AppFont.semiBold,
                                      ),
                                      const SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: PrimaryText(
                                          text: AppStrings.spendThisMonth,
                                          size: AppDimen.textSize14,
                                          weight: AppFont.medium,
                                          color: AppColors.lightGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    height: 10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.lightGrey.withAlpha(90),
                                    ),
                                    child: Row(
                                      children: List.generate(baseColors.length, (
                                        index,
                                      ) {
                                        final bool isThisMonth =
                                            value.thisMonth > 0 && index == 0;
                                        return Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color:
                                                  isThisMonth
                                                      ? baseColors[index]
                                                          .withAlpha(100)
                                                      : baseColors[index],
                                              borderRadius: BorderRadius.horizontal(
                                                left:
                                                    index == 0
                                                        ? const Radius.circular(
                                                          10,
                                                        )
                                                        : Radius.zero,
                                                right:
                                                    index ==
                                                            baseColors.length -
                                                                1
                                                        ? const Radius.circular(
                                                          10,
                                                        )
                                                        : Radius.zero,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                    text: "My ${AppStrings.invest}",
                                    size: AppDimen.textSize16,
                                    weight: AppFont.semiBold,
                                  ),
                                  const SizedBox(height: 10),
                                  LineChart(investmentData: investments),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                    (profilePicture != null &&
                                            profilePicture != "")
                                        ? Image.network(
                                          profilePicture.toString(),
                                        ).image
                                        : "assets/images/user.png"
                                            .toAssetImageProvider(),
                              ),
                              const SizedBox(height: 10),
                              PrimaryText(
                                text:
                                    userName.toString().isEmpty
                                        ? "User"
                                        : userName.toString(),
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

  List<InvestmentData> buildMonthlyInvestments(List<dynamic> userPlans) {
    Map<String, double> monthlyTotals = {};
    for (var plan in userPlans) {
      DateTime date = DateTime.parse(plan['insert_date']);
      String month = DateFormat.MMM().format(date);
      double amount = double.tryParse(plan['ins_amt'].toString()) ?? 0.0;
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + amount;
    }
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months.map((m) => InvestmentData(m, monthlyTotals[m] ?? 0)).toList();
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
            const SizedBox(width: 10),
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
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouteEnum.profile.name);
        },
        "title": AppStrings.profile,
      },
      {
        "image": "assets/images/blog.png",
        "onTap": () {
          Navigator.pop(context);
          data.getBlog(context);
          Navigator.pushNamed(context, AppRouteEnum.blog.name);
        },
        "title": "${AppStrings.blog}s",
      },
      {
        "image": "assets/images/video.png",
        "onTap": () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouteEnum.educationalVideo.name);
        },
        "title": AppStrings.educationVideo,
      },
      {
        "image": "assets/images/economy.png",
        "onTap": () {
          Navigator.pop(context);
          data.getEconomicInsights(context);
          Navigator.pushNamed(context, AppRouteEnum.economyInsights.name);
        },
        "title": AppStrings.economyInsight,
      },
      {
        "image": "assets/images/finance.png",
        "onTap": () {
          Navigator.pop(context);
          data.getFinancialData(context);
          Navigator.pushNamed(context, AppRouteEnum.financialIQ.name);
        },
        "title": AppStrings.financial,
      },
      {
        "image": "assets/images/refer.png",
        "onTap": () {
          Navigator.pop(context);
          data.getReferralCode(context);
          Navigator.pushNamed(context, AppRouteEnum.referral.name);
        },
        "title": "Refer & Earn",
      },
      {
        "image": "assets/images/terms.png",
        "onTap": () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouteEnum.terms.name);
        },
        "title": AppStrings.termsCondition,
      },
      {
        "image": "assets/images/privacy.png",
        "onTap": () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouteEnum.privacy.name);
        },
        "title": "Privacy Policy",
      },
      {
        "image": "assets/images/contact.png",
        "onTap": () async {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouteEnum.contactUs.name);
        },
        "title": AppStrings.contactUs,
      },
      {
        "image": "assets/images/about.png",
        "onTap": () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouteEnum.about.name);
        },
        "title": AppStrings.aboutUs,
      },
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
      {
        "image": "assets/images/logout.png",
        "onTap": () {
          Provider.of<ProfileProvider>(context, listen: false).logOut(context);
        },
        "title": AppStrings.logout,
      },
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
                    const SizedBox(width: 10),
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
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryText(
                  text: AppStrings.kycPending,
                  size: AppDimen.textSize14,
                  weight: AppFont.semiBold,
                ),
                PrimaryText(
                  text: AppStrings.fillKyc,
                  size: AppDimen.textSize12,
                  weight: AppFont.semiBold,
                ),
              ],
            ),
            const Spacer(),
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
    required int count,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundImage:
              (profilePicture != null && profilePicture != "")
                  ? Image.network(profilePicture.toString()).image
                  : Image.asset("assets/images/user.png").image,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: userName.toString().isEmpty ? "User" : userName.toString(),
              size: AppDimen.textSize14,
              weight: AppFont.semiBold,
              maxLines: 1,
            ),
            PrimaryText(
              text: AppStrings.welcomeBack,
              size: AppDimen.textSize14,
              weight: AppFont.regular,
              maxLines: 1,
              color: AppColors.lightGrey,
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: getRowIcon(
            selectedIndex: 0,
            scaffoldKey: scaffoldKey,
            context: context,
            pendingCount: count,
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget getRowIcon({
    int selectedIndex = 0,
    required scaffoldKey,
    required context,
    int pendingCount = 0,
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
          if (pendingCount > 0) {
            Navigator.pushNamed(context, AppRouteEnum.notification.name);
          }
        },
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(icons.length, (index) {
        final entry = icons[index];
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    index == selectedIndex
                        ? AppColors.primary
                        : AppColors.white,
              ),
              child: Image.asset(
                entry["image"],
                scale: 3.5,
                color: index == selectedIndex ? null : AppColors.black,
              ),
            ).toGesture(onTap: entry["onTap"]),
            if (index == 2 && pendingCount > 0)
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: PrimaryText(
                      text: "$pendingCount",
                      size: AppDimen.textSize12,
                      weight: AppFont.semiBold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
