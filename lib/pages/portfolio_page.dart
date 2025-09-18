import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../constants.dart' show aadhaarName;

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  void initState() {
    context.read<HomeProvider>().getPortfolioData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.screenBgColor,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: Row(
              children: [
                SizedBox(width: 10),
                PrimaryText(
                  text: "${getGreetingMessage()} \n$aadhaarName",
                  weight: AppFont.semiBold,
                  size: AppDimen.textSize16,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 170,
                        width: 170,
                        child: CircularProgressIndicator(
                          value: value.progressPortFolio,
                          strokeWidth: 26,
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.greenCircleColor,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryText(
                            text: "Total Investment",
                            weight: AppFont.regular,
                            size: AppDimen.textSize10,
                          ),
                          PrimaryText(
                            text:
                                "${(value.progressPortFolio * 100).toStringAsFixed(1)}%",
                            weight: AppFont.bold,
                            size: AppDimen.textSize18,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(128, 128, 128, 0.09),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PrimaryText(
                              text: "Total Investment",
                              weight: AppFont.regular,
                              size: AppDimen.textSize10,
                            ),
                            const SizedBox(height: 8),
                            PrimaryText(
                              text:
                                  "\u20B9 ${BaseFunction().formatIndianNumber(value.totalInvestments.toInt())}",
                              weight: AppFont.semiBold,
                              size: AppDimen.textSize22,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(128, 128, 128, 0.09),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PrimaryText(
                              text: "Today Investment",
                              weight: AppFont.regular,
                              size: 10,
                            ),
                            const SizedBox(height: 8),
                            PrimaryText(
                              text:
                                  "\u20B9 ${BaseFunction().formatIndianNumber(value.todayInvestment.toInt())}",
                              weight: AppFont.semiBold,
                              size: AppDimen.textSize22,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              buildPlanGrid(),
            ],
          );
        },
      ),
    );
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  Widget buildPlanGrid() {
    final List<Map<String, dynamic>> activePlanCard = [
      {
        "image": "assets/images/return.png",
        "title": "Total Referal",
        "amount": "0",
      },
      {
        "image": "assets/images/tenure.png",
        "title": "Today Referral",
        "amount": "0",
      },
      {
        "image": "assets/images/fund_req.png",
        "title": "Total Payout",
        "amount": "\u20B9 ${BaseFunction().formatIndianNumber(0.toInt())}",
      },
      {
        "image": "assets/images/fund_raise.png",
        "title": "Total Tickets",
        "amount": "0",
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2.0,
      ),
      itemCount: activePlanCard.length,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      itemBuilder: (context, index) {
        final item = activePlanCard[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(128, 128, 128, 0.09),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryText(
                text: item["title"],
                weight: AppFont.regular,
                size: AppDimen.textSize12,
              ),
              const SizedBox(height: 8),
              PrimaryText(
                text: item["amount"],
                weight: AppFont.semiBold,
                size: AppDimen.textSize22,
              ),
            ],
          ),
        );
      },
    );
  }
}
