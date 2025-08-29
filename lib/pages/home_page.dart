import 'package:dhlapp/providers/home_provider.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screenBgColor,
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 16,
                          ),
                          getProfile(value, scaffoldKey: scaffoldKey),
                          SizedBox(height: 20),
                          kycCard(),
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
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/inverstment.png",
                                        scale: 3,
                                      ),
                                      SizedBox(width: 10),
                                      PrimaryText(
                                        text: "Investment",
                                        color: AppColors.white,
                                        weight: AppFont.semiBold,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/referal.png",
                                        scale: 3,
                                      ),
                                      SizedBox(width: 10),
                                      PrimaryText(
                                        text: "Referral",
                                        color: AppColors.white,
                                        weight: AppFont.semiBold,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: PrimaryText(
                                        text: "Spend this month",
                                        size: 14,
                                        weight: AppFont.medium,
                                        color: AppColors.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              color: AppColors.primary,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 40),
                  SizedBox(height: 10),
                  PrimaryText(
                    text: "Amrish Kumar",
                    size: 18,
                    color: AppColors.white,
                    weight: AppFont.semiBold,
                  ),
                ],
              ),
            ),
            getSideBarInfo(
              image: "assets/images/facebook.png",
              label: "Profile",
            ),
            getSideBarInfo(
              image: "assets/images/Vector3.png",
              label: "Investment Calculator",
            ),
            getSideBarInfo(
              image: "assets/images/Vector-notification.png",
              label: "Blogs",
            ),
            getSideBarInfo(
              image: "assets/images/facebook.png",
              label: "Education Videos",
            ),
            getSideBarInfo(
              image: "assets/images/Vector3.png",
              label: "Economy Insights",
            ),
            getSideBarInfo(
              image: "assets/images/Vector-notification.png",
              label: "Financial IQ",
            ),
            getSideBarInfo(
              image: "assets/images/facebook.png",
              label: "Refer & Earn",
            ),
            getSideBarInfo(
              image: "assets/images/Vector3.png",
              label: "Terms & Conditions",
            ),
            getSideBarInfo(
              image: "assets/images/Vector-notification.png",
              label: "Privacy Policy",
            ),
            getSideBarInfo(
              image: "assets/images/facebook.png",
              label: "Contact Us",
            ),
            getSideBarInfo(
              image: "assets/images/Vector3.png",
              label: "About Us",
            ),
            getSideBarInfo(
              image: "assets/images/Vector-notification.png",
              label: "Milestone",
            ),
            getSideBarInfo(
              image: "assets/images/Vector-notification.png",
              label: "Disclaimer",
            ),
            getSideBarInfo(
              image: "assets/images/Vector-notification.png",
              label: "Logout",
            ),
          ],
        ),
      ),
    );
  }

  Widget getSideBarInfo({required String image, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5,
        children: [
          Image.asset(image, scale: 3),
          SizedBox(width: 10),
          PrimaryText(text: label, size: 16),
        ],
      ),
    );
  }

  Widget kycCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryLight,
      ),
      child: Row(
        children: [
          Image.asset("assets/images/timer.png", scale: 3),
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
          GestureDetector(
            onTap: () {},
            child: Image.asset("assets/images/circleArrow.png", scale: 3),
          ),
        ],
      ),
    );
  }

  Widget getProfile(HomeProvider value, {required scaffoldKey}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              Image.asset(value.photoUrl ?? "assets/images/user.png").image,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: value.userName ?? "Amrish Kumar",
              size: 16,
              weight: AppFont.semiBold,
              color: AppColors.black,
            ),
            PrimaryText(
              text: "Welcome Back!",
              size: 14,
              weight: AppFont.regular,
              color: AppColors.lightGrey,
            ),
          ],
        ),
        Spacer(),
        getRowIcon(selectedIndex: 0, scaffoldKey: scaffoldKey),
      ],
    );
  }

  Widget getRowIcon({int selectedIndex = 0, required scaffoldKey}) {
    final List<MapEntry<String, GestureTapCallback>> icons = [
      MapEntry("assets/images/info.png", () {
        scaffoldKey.currentState?.openDrawer();
      }),
      MapEntry("assets/images/Vector3.png", () {
        debugPrint("Vector3 tapped");
      }),
      MapEntry("assets/images/Vector-notification.png", () {
        debugPrint("Notification tapped");
      }),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(icons.length, (index) {
        final entry = icons[index];
        return GestureDetector(
          onTap: entry.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  index == selectedIndex ? AppColors.primary : AppColors.white,
            ),
            child: Image.asset(
              entry.key, // 👈 image path
              scale: 3.5,
              color: index == selectedIndex ? null : AppColors.black,
            ),
          ),
        );
      }),
    );
  }
}
