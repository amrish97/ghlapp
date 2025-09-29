import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/pages/Investment/investment_about_page.dart';
import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class InvestmentCalculator extends StatelessWidget {
  final Map<String, dynamic> planDetail;

  const InvestmentCalculator({super.key, required this.planDetail});

  @override
  Widget build(BuildContext context) {
    int tenureMonths = int.parse(planDetail["tenure"]);
    double tenureYears = tenureMonths / 12;
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<InvestmentProvider>(
        builder: (context, provider, child) {
          final minAmt = double.parse(planDetail["min_investment_amt"]);
          final maxAmt = double.parse(planDetail["max_investment_amt"]);
          final diff = maxAmt - minAmt;
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: AppStrings.minInvestment,
                    align: TextAlign.start,
                    size: AppDimen.textSize14,
                    weight: AppFont.semiBold,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      PrimaryText(
                        text:
                            "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(planDetail["min_investment_amt"]).toInt())}",
                        align: TextAlign.start,
                        size: AppDimen.textSize26,
                        weight: AppFont.semiBold,
                      ),
                      Spacer(),
                      CustomButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => InvestmentAboutPage(
                                    planDetail: planDetail,
                                  ),
                            ),
                          );
                        },
                        text: AppStrings.invest,
                        color: AppColors.primary,
                        width: MediaQuery.of(context).size.width - 250,
                        iconWidget:
                            "assets/images/inverstment.png".toImageAsset(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 10),
              buildPlanGrid(planDetail),
              PrimaryText(
                text: AppStrings.calculateROI,
                align: TextAlign.start,
                size: AppDimen.textSize14,
                weight: AppFont.semiBold,
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  children: [
                    getRowView(
                      title: AppStrings.capitalInvestment,
                      value:
                          "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.initialInvestmentAmount.toStringAsFixed(0)).toInt())}",
                    ),
                    Slider(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      value: provider.initialInvestmentAmount.clamp(
                        minAmt,
                        maxAmt,
                      ),
                      min: minAmt,
                      max: maxAmt,
                      divisions:
                          diff > 0
                              ? (diff / 10000).round().clamp(1, 1000)
                              : null,
                      // ✅ safe
                      label:
                          '₹${provider.initialInvestmentAmount.toStringAsFixed(0)}',
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.grey[300],
                      onChanged: (value) {
                        provider.setAmount(
                          value,
                          planDetail["tenure"],
                          planDetail["return_of_investment"],
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          text:
                              "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(planDetail["min_investment_amt"]).toInt())}",
                          align: TextAlign.start,
                          weight: AppFont.medium,
                          size: AppDimen.textSize10,
                        ),
                        PrimaryText(
                          text:
                              "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(planDetail["max_investment_amt"]).toInt())}",
                          align: TextAlign.start,
                          weight: AppFont.medium,
                          size: AppDimen.textSize10,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    getRowView(
                      title: AppStrings.annualInt,
                      value:
                          "${(double.parse(planDetail["tenure"]) * 2).toStringAsFixed(0)}%",
                    ),
                    SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                        inactiveTrackColor: AppColors.primary,
                        disabledActiveTrackColor: AppColors.investCalcSlider,
                        disabledInactiveTrackColor: AppColors.primary,
                        disabledThumbColor: AppColors.investCalcSlider,
                      ),
                      child: Slider(
                        value: 100,
                        min: 0,
                        max: 100,
                        onChanged: null,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          text: "${planDetail["tenure"]}%",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize10,
                        ),
                        PrimaryText(
                          text:
                              "${(double.parse(planDetail["tenure"]) * 2).toStringAsFixed(0)}%",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize10,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    getRowView(
                      title: AppStrings.noOfYears,
                      value: "${tenureYears.toStringAsFixed(0)} Years",
                    ),
                    SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                        inactiveTrackColor: AppColors.primary,
                        disabledActiveTrackColor: AppColors.investCalcSlider,
                        disabledInactiveTrackColor: AppColors.primary,
                        disabledThumbColor: AppColors.investCalcSlider,
                      ),
                      child: Slider(
                        value: 100,
                        min: 0,
                        max: 100,
                        onChanged: null,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          text: "1 Year",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize10,
                        ),
                        PrimaryText(
                          text: "${tenureYears.toStringAsFixed(0)} Years",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize10,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          text: AppStrings.capitalInvestment,
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                          color: AppColors.white,
                        ),
                        PrimaryText(
                          text:
                              "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.initialInvestmentAmount.toString()).toInt())}",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          text: "Total ROI Earned \n (24 Months)",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                          color: AppColors.white,
                        ),
                        PrimaryText(
                          text:
                              "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.withoutTDS.toString()).toInt())}",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          text: "Total Amount \n Sum of Capital & ROI",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                          color: AppColors.white,
                        ),
                        PrimaryText(
                          text:
                              "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.totalAmount.toString()).toInt())}",
                          align: TextAlign.start,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(height: 10),
                    PrimaryText(
                      text: AppStrings.monthlyReturn,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize12,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 10),
                    PrimaryText(
                      text:
                          "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(provider.monthly.toString()).toInt())}",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize14,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Widget getRowView({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryText(
          text: title,
          weight: AppFont.regular,
          size: AppDimen.textSize12,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(224, 223, 225, 1),
          ),
          child: PrimaryText(
            text: value,
            align: TextAlign.start,
            size: AppDimen.textSize12,
            weight: AppFont.semiBold,
          ),
        ),
      ],
    );
  }

  Widget buildPlanGrid(Map<String, dynamic> planDetail) {
    final List<Map<String, dynamic>> activePlanCard = [
      {
        "image": "assets/images/return.png",
        "title": AppStrings.preTax,
        "amount": "${planDetail["tenure"]}% (P.A)",
        "color": AppColors.calcGridColor,
      },
      {
        "image": "assets/images/tenure.png",
        "title": AppStrings.tenure,
        "amount": "${planDetail["tenure"]} Months",
        "color": AppColors.calcGridColor1,
      },
      {
        "image": "assets/images/fund_req.png",
        "title": AppStrings.fundRequired,
        "amount":
            "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(planDetail["max_investment_amt"]).toInt())}",
        "color": AppColors.calcGridColor2,
      },
      {
        "image": "assets/images/fund_raise.png",
        "title": AppStrings.fundRaise,
        "amount":
            "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(planDetail["deposit_amount"]).toInt())}",
        "color": AppColors.calcGridColor3,
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: activePlanCard.length,
      itemBuilder: (context, index) {
        final item = activePlanCard[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: item["color"],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PrimaryText(
                    text: item["title"],
                    weight: AppFont.semiBold,
                    size: AppDimen.textSize12,
                  ),
                  Spacer(),
                  item["image"].toString().toImageAsset(
                    scale: 3,
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PrimaryText(
                text: item["amount"],
                weight: AppFont.semiBold,
                size: AppDimen.textSize18,
              ),
            ],
          ),
        );
      },
    );
  }
}
