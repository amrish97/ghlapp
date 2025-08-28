import 'package:dhlapp/providers/home_provider.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          getProfile(),
                          SizedBox(height: 20),
                          kycCard(),
                          SizedBox(height: 20),
                          PrimaryText(
                            text: "Total Investment",
                            size: 20,
                            weight: AppFont.regular,
                          ),
                          Row(
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.currency_rupee, size: 30),
                              PrimaryText(
                                text: "7,645.25",
                                size: 40,
                                weight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  PrimaryText(
                                    text: " +25.52%",
                                    color: Colors.green,
                                    size: 23,
                                    weight: AppFont.regular,
                                  ),
                                  PrimaryText(
                                    text: " Last Month",
                                    color: Colors.black,
                                    size: 17,
                                    weight: AppFont.regular,
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
                                        weight: AppFont.bold,
                                        size: 19,
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
                                        weight: AppFont.bold,
                                        size: 19,
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
                                      size: 20,
                                      weight: AppFont.regular,
                                    ),
                                    PrimaryText(
                                      text: "View All",
                                      size: 20,
                                      weight: AppFont.regular,
                                      color: AppColors.lightGrey,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.currency_rupee, size: 30),
                                    PrimaryText(
                                      text: "9,645.25",
                                      size: 40,
                                      weight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                    SizedBox(width: 5),
                                    PrimaryText(
                                      text: "Spend this month",
                                      size: 13,
                                      weight: AppFont.regular,
                                      color: AppColors.lightGrey,
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
    );
  }

  Widget kycCard() {
    return Container(
      height: 90,
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
            children: [
              PrimaryText(
                text: "KYC is Pending",
                size: 20,
                weight: AppFont.semiBold,
                color: AppColors.black,
              ),
              PrimaryText(
                text: "Welcome Back!",
                size: 17,
                weight: AppFont.regular,
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

  Widget getProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.purple.shade50,
          child: Text("A"),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: "Amrish Kumar",
              size: 20,
              weight: AppFont.bold,
              color: AppColors.primary,
            ),
            PrimaryText(
              text: "Welcome Back!",
              size: 17,
              weight: AppFont.regular,
              color: AppColors.lightGrey,
            ),
          ],
        ),
        Spacer(),
        getRowIcon(selectedIndex: 0),
      ],
    );
  }

  Widget getRowIcon({int selectedIndex = 0}) {
    List<String> icons = [
      "assets/images/info.png",
      "assets/images/Vector3.png",
      "assets/images/Vector-notification.png",
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(icons.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == selectedIndex ? AppColors.primary : AppColors.white,
          ),
          child: Image.asset(
            icons[index],
            scale: 3.5,
            color: index == selectedIndex ? null : AppColors.black,
          ),
        );
      }),
    );
  }
}
