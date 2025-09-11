import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/custom_textField.dart';
import 'package:ghlapp/widgets/progress_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentCompletePage extends StatelessWidget {
  final Map<String, dynamic> planDetail;
  const InvestmentCompletePage({super.key, required this.planDetail});

  @override
  Widget build(BuildContext context) {
    return Consumer<InvestmentProvider>(
      builder: (context, value, child) {
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
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ).toGesture(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
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
                                color: AppColors.black,
                              ),
                            ),
                            Column(
                              children: [
                                PrimaryText(
                                  text: "Investment Raised",
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
                          text: "Funding Process",
                          color: AppColors.black,
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
                          title: "PER TAX RETURN",
                          value: "${planDetail["return_of_investment"]}%",
                        ),
                        getRowSectionWithItem(
                          title: "MINIMUM INVESTMENT",
                          value: planDetail["min_investment_amt"],
                        ),
                        getRowSectionWithItem(
                          title: "CAPITAL INVESTED",
                          value:
                              value.amountInvestController.text.isEmpty
                                  ? ""
                                  : "\u20B9 ${value.amountInvestController.text}",
                        ),
                        getRowSectionWithItem(
                          title: "TDS APPLICABLE",
                          value: "${planDetail["tax_applicable"]}%",
                        ),
                        getRowSectionWithItem(
                          title: "MONTHLY RETURNS",
                          value:
                              "\u20B9 ${value.monthlyReturn.toStringAsFixed(2)}",
                        ),
                        getRowSectionWithItem(
                          title: "YEARLY RETURNS",
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
          color: AppColors.black,
        ),
        PrimaryText(
          text: value,
          size: AppDimen.textSize12,
          weight: AppFont.bold,
          color: AppColors.black,
        ),
      ],
    );
  }
}
