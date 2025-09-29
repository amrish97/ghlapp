import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class InvestmentCompletePage extends StatelessWidget {
  final Map<String, dynamic> planDetail;

  const InvestmentCompletePage({super.key, required this.planDetail});

  @override
  Widget build(BuildContext context) {
    return Consumer<InvestmentProvider>(
      builder: (context, value, child) {
        print("planDetail---->>> $planDetail");
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.screenBgColor,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
                child: Row(
                  children: [
                    getBackButton(context),
                    Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.download, color: AppColors.white),
                    ).toGesture(
                      onTap: () {
                        BaseFunction().openPdf(planDetail["documentfiles_url"]);
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 20,
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        planDetail["uploadfiles_url"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: PrimaryText(
                                text: planDetail["name"],
                                size: AppDimen.textSize14,
                                weight: AppFont.bold,
                              ),
                            ),
                            Column(
                              children: [
                                PrimaryText(
                                  text: AppStrings.investmentRaised,
                                  size: AppDimen.textSize12,
                                  weight: AppFont.bold,
                                  color: AppColors.hintTextColor,
                                ),
                                PrimaryText(
                                  text:
                                      "\u20B9 ${planDetail["deposit_amount"]}",
                                  size: AppDimen.textSize12,
                                  weight: AppFont.bold,
                                  color: AppColors.greenCircleColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        PrimaryText(
                          text: "Tenure ${planDetail["tenure"]} Months",
                          color: AppColors.lightGrey,
                          weight: AppFont.regular,
                          size: AppDimen.textSize12,
                        ),
                        SizedBox(height: 10),
                        PrimaryText(
                          text: AppStrings.fundingProcess,
                          weight: AppFont.regular,
                          size: AppDimen.textSize12,
                        ),
                        InvestmentProgress(
                          investAmount: double.parse(
                            planDetail["deposit_amount"].toString(),
                          ),
                          totalFund: double.parse(
                            planDetail["max_investment_amt"].toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getRowSectionWithItem(
                          title: AppStrings.preTax.toUpperCase(),
                          value: "${planDetail["return_of_investment"]}%",
                        ),
                        getRowSectionWithItem(
                          title: AppStrings.minInvestment.toUpperCase(),
                          value: planDetail["min_investment_amt"],
                        ),
                        getRowSectionWithItem(
                          title: AppStrings.capitalInvestment.toUpperCase(),
                          value: "",
                        ),
                        getRowSectionWithItem(
                          title: AppStrings.tdsApplicable.toUpperCase(),
                          value: "${planDetail["tax_applicable"]}%",
                        ),
                        getRowSectionWithItem(
                          title: AppStrings.monthlyReturn.toUpperCase(),
                          value:
                              "\u20B9 ${value.monthlyReturn.toStringAsFixed(2)}",
                        ),
                        getRowSectionWithItem(
                          title: AppStrings.yearlyReturns.toUpperCase(),
                          value: "\u20B9 ${value.monthlyReturn * 12}",
                        ),
                        getRowSectionWithItem(
                          title: "SUM OF CAPITAL & ROI",
                          value: "\u20B9 ${value.totalSum.toStringAsFixed(2)}",
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
          weight: AppFont.bold,
        ),
      ],
    );
  }
}
