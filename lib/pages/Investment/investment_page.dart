import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/pages/Investment/completed_plan_page.dart';
import 'package:ghlapp/pages/Investment/investment_calculator.dart';
import 'package:ghlapp/pages/Investment/investment_completed_page.dart';
import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/progress_view.dart';
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
    context.read<InvestmentProvider>().getKycStatus(context);
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: PrimaryText(
                                text: provider.activePlan[index]["name"],
                                size: AppDimen.textSize14,
                              ),
                            ),
                            Column(
                              children: [
                                PrimaryText(
                                  text: AppStrings.minInvestment,
                                  size: AppDimen.textSize12,
                                  weight: AppFont.regular,
                                  color: AppColors.lightGrey,
                                ),
                                PrimaryText(
                                  text:
                                      "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.activePlan[index]["deposit_amount"]).toInt())}",
                                  size: AppDimen.textSize20,
                                  weight: AppFont.semiBold,
                                  color: AppColors.primary,
                                ),
                              ],
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
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.calcCardColor,
                          ),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "assets/images/cashback.png".toImageAsset(
                                scale: 2.5,
                              ),
                              const SizedBox(width: 10),
                              PrimaryText(
                                text: "Upto 20% Cashback Offer!!",
                                weight: AppFont.semiBold,
                                size: AppDimen.textSize12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.invCard,
                          ),
                          child: Column(
                            children: [
                              getRowSectionWithItem(
                                title: AppStrings.preTax,
                                value:
                                    "${provider.activePlan[index]["return_of_investment"]}% P.a",
                              ),
                              const SizedBox(height: 10),
                              getRowSectionWithItem(
                                title: AppStrings.tenure,
                                value:
                                    "${provider.activePlan[index]["tenure"]} Months",
                              ),
                              const SizedBox(height: 10),
                              getRowSectionWithItem(
                                title: AppStrings.totalFundRequired,
                                value:
                                    "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.activePlan[index]["max_investment_amt"]).toInt())}",
                              ),
                              const SizedBox(height: 10),
                              getRowSectionWithItem(
                                title: AppStrings.totalFundRaised,
                                value:
                                    "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.activePlan[index]["deposit_amount"]).toInt())}",
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
                                text: AppStrings.fundingProcess,
                                size: AppDimen.textSize12,
                                weight: AppFont.regular,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => InvestmentCalculator(
                                      planDetail: provider.activePlan[index],
                                    ),
                              ),
                            );
                          },
                          text: AppStrings.invest,
                          color: AppColors.greenCircleColor,
                          width: MediaQuery.of(context).size.width - 200,
                          iconWidget:
                              "assets/images/inverstment.png".toImageAsset(),
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
                      text: AppStrings.completeProject,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                    PrimaryText(
                      text: AppStrings.seeAll,
                      weight: AppFont.regular,
                      color: Colors.blue,
                      size: AppDimen.textSize14,
                    ).toGesture(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              horizontalView(completedPlan: provider.completedPlan),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget horizontalView({required List<Map<String, dynamic>> completedPlan}) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: completedPlan.length,
        itemBuilder: (context, index) {
          return Container(
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
                        size: AppDimen.textSize12,
                        align: TextAlign.start,
                      ),
                      PrimaryText(
                        text:
                            "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(completedPlan[index]["total_investment_amt"]).toInt())}",
                        weight: AppFont.regular,
                        size: AppDimen.textSize12,
                        color: AppColors.lightGrey,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).toGesture(
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
          );
        },
      ),
    );
  }

  Widget getRowSectionWithItem({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryText(
          text: title,
          size: AppDimen.textSize12,
          weight: AppFont.regular,
        ),
        PrimaryText(
          text: value,
          size: AppDimen.textSize12,
          weight: AppFont.semiBold,
        ),
      ],
    );
  }

  Widget getView({required InvestmentProvider provider}) {
    return Stack(
      children: [
        ...provider.activePlan.map(
          (plan) => Container(
            height: 310,
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
            top: 105,
            left: 50,
            right: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(plan["uploadfiles_url"], fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
