import 'package:ghlapp/pages/completed_plan_page.dart';
import 'package:ghlapp/pages/investment_about_page.dart';
import 'package:ghlapp/pages/investment_completed_page.dart';
import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/progress_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  State<InvestmentPage> createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  @override
  void initState() {
    context.read<InvestmentProvider>().getPlan(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: Consumer<InvestmentProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              getView(provider: provider),
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: provider.activePlan.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: PrimaryText(
                                text: provider.activePlan[index]["name"],
                                size: AppDimen.textSize14,
                                weight: AppFont.bold,
                                color: AppColors.black,
                              ),
                            ),
                            Column(
                              children: [
                                PrimaryText(
                                  text: "Minimum Investment",
                                  size: AppDimen.textSize12,
                                  weight: AppFont.regular,
                                  color: AppColors.lightGrey,
                                ),
                                PrimaryText(
                                  text:
                                      "\u20B9 ${provider.activePlan[index]["deposit_amount"]}",
                                  size: AppDimen.textSize20,
                                  weight: AppFont.semiBold,
                                  color: AppColors.primary,
                                ),
                              ],
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
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primaryLight,
                          ),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/cashback.png",
                                scale: 2.5,
                              ),
                              SizedBox(width: 10),
                              PrimaryText(
                                text: "Upto 20% Cashback Offer!!",
                                color: AppColors.black,
                                weight: AppFont.semiBold,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.greyContainerColor.withAlpha(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PrimaryText(
                                    text: "Per Tax return",
                                    size: AppDimen.textSize12,
                                    weight: AppFont.regular,
                                    color: AppColors.black,
                                  ),
                                  PrimaryText(
                                    text:
                                        "${provider.activePlan[index]["return_of_investment"]}% P.a",
                                    size: AppDimen.textSize12,
                                    weight: AppFont.semiBold,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PrimaryText(
                                    text: "Tenure",
                                    size: AppDimen.textSize12,
                                    weight: AppFont.regular,
                                    color: AppColors.black,
                                  ),
                                  PrimaryText(
                                    text:
                                        "${provider.activePlan[index]["tenure"]} Months",
                                    size: AppDimen.textSize12,
                                    weight: AppFont.semiBold,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PrimaryText(
                                    text: "Total fund Required",
                                    size: AppDimen.textSize12,
                                    weight: AppFont.regular,
                                    color: AppColors.black,
                                  ),
                                  PrimaryText(
                                    text:
                                        provider
                                            .activePlan[index]["max_investment_amt"],
                                    size: AppDimen.textSize12,
                                    weight: AppFont.semiBold,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PrimaryText(
                                    text: "Total fund Raised",
                                    size: AppDimen.textSize12,
                                    weight: AppFont.regular,
                                    color: AppColors.black,
                                  ),
                                  PrimaryText(
                                    text:
                                        provider
                                            .activePlan[index]["deposit_amount"],
                                    size: AppDimen.textSize12,
                                    weight: AppFont.semiBold,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              InvestmentProgress(
                                investAmount: double.parse(
                                  provider.activePlan[index]["deposit_amount"]
                                      .toString(),
                                ),
                                totalFund: double.parse(
                                  provider
                                      .activePlan[index]["max_investment_amt"]
                                      .toString(),
                                ),
                              ),
                              PrimaryText(
                                text: "Funding Process",
                                size: AppDimen.textSize12,
                                weight: AppFont.regular,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => InvestmentAboutPage(
                                      planDetail: provider.activePlan[index],
                                    ),
                              ),
                            );
                          },
                          text: "Invest",
                          color: AppColors.greenCircleColor,
                          width: MediaQuery.of(context).size.width - 200,
                          iconWidget: Image.asset(
                            "assets/images/inverstment.png",
                            scale: 3,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryText(
                      text: "Completed Project",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CompletedPlanPage(
                                  completedPlans: provider.completedPlan,
                                ),
                          ),
                        );
                      },
                      child: PrimaryText(
                        text: "See All",
                        weight: AppFont.regular,
                        color: Colors.blue,
                        size: AppDimen.textSize14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              horizondalView(completedPlan: provider.completedPlan),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget horizondalView({required List<Map<String, dynamic>> completedPlan}) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: completedPlan.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => InvestmentCompletePage(
                        planDetail: completedPlan[index],
                      ),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      completedPlan[index]["uploadfiles_url"],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: completedPlan[index]["name"],
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize14,
                          align: TextAlign.start,
                        ),
                        PrimaryText(
                          text:
                              "\u20B9 ${completedPlan[index]["total_investment_amt"]}",
                          weight: AppFont.regular,
                          size: AppDimen.textSize14,
                          color: AppColors.lightGrey,
                          align: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getView({required InvestmentProvider provider}) {
    return Stack(
      children: [
        ...provider.activePlan.map(
          (plan) => Container(
            height: 300,
            padding: EdgeInsets.only(top: 60),
            width: double.infinity,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(color: AppColors.primary),
            child: PrimaryText(
              text: plan["name"],
              color: AppColors.white,
              align: TextAlign.center,
              size: AppDimen.textSize16,
              weight: AppFont.semiBold,
            ),
          ),
        ),
        Positioned(
          top: 180,
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.screenBgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(130),
                topRight: Radius.circular(130),
              ),
            ),
          ),
        ),
        ...provider.activePlan.map(
          (plan) => Positioned(
            top: 130,
            left: 50,
            right: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                child: Image.network(
                  plan["uploadfiles_url"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
