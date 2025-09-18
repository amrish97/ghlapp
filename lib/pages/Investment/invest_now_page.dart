import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class InvestNowPage extends StatelessWidget {
  final Map<String, dynamic> planDetail;

  const InvestNowPage({super.key, required this.planDetail});

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
                padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
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
                spacing: 10,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(
                            text: "Amount Payable",
                            weight: AppFont.semiBold,
                            size: AppDimen.textSize12,
                          ),
                          PrimaryText(
                            text:
                                "\u20B9${BaseFunction().formatIndianNumber(int.parse(value.investmentAmount.toStringAsFixed(0)))}",
                            weight: AppFont.semiBold,
                            color: AppColors.greenCircleColor,
                            size: AppDimen.textSize16,
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: PrimaryText(
                          text: "Learn about the Terms",
                          color: AppColors.white,
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                        ),
                      ).toGesture(
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: '',
                            barrierColor: Colors.black54,
                            pageBuilder: (context, anim1, anim2) {
                              return Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    color: AppColors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          color: AppColors.brownColor,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20,
                                            ),
                                            child: const PrimaryText(
                                              text:
                                                  "Grab upto 2% cashback on your Investments",
                                              size: AppDimen.textSize14,
                                              weight: AppFont.semiBold,
                                              color: AppColors.white,
                                              align: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PrimaryText(
                                                text:
                                                    "A) From 1 Lakh to 0.99Lakh - 1% cashback ",
                                                align: TextAlign.start,
                                                weight: AppFont.semiBold,
                                                size: AppDimen.textSize12,
                                              ),
                                              PrimaryText(
                                                text:
                                                    "B) From 10 Lakh and above - 2% cashback ",
                                                align: TextAlign.start,
                                                weight: AppFont.semiBold,
                                                size: AppDimen.textSize12,
                                              ),
                                              SizedBox(height: 20),
                                              PrimaryText(
                                                text: "Regards,",
                                                align: TextAlign.start,
                                                weight: AppFont.regular,
                                                size: AppDimen.textSize12,
                                              ),
                                              PrimaryText(
                                                text: "TEAM GHL INDIA",
                                                align: TextAlign.start,
                                                weight: AppFont.bold,
                                                size: AppDimen.textSize12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .closeButtonColor
                                                          .withAlpha(90),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            7,
                                                          ),
                                                    ),
                                                    child: PrimaryText(
                                                      text: "Close",
                                                      color: AppColors.white,
                                                      size: AppDimen.textSize12,
                                                      weight: AppFont.regular,
                                                    ),
                                                  ).toGesture(
                                                    onTap:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    child: PrimaryText(
                                                      text: "Invest Now",
                                                      size: AppDimen.textSize12,
                                                      weight: AppFont.regular,
                                                      color: AppColors.white,
                                                    ),
                                                  ).toGesture(onTap: () {}),
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
                          );
                        },
                      ),
                    ],
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
                          title: "Investment Amount",
                          value:
                              "\u20B9 ${BaseFunction().formatIndianNumber(int.parse(value.amountInvestController.text.isEmpty ? "" : value.amountInvestController.text))}",
                        ),
                        getRowSectionWithItem(
                          title: "Tenure",
                          value: "${planDetail["tenure"]} Months",
                        ),
                        getRowSectionWithItem(
                          title: "Pre Tax Return (%)",
                          value: "${planDetail["return_of_investment"]}%",
                        ),
                        getRowSectionWithItem(
                          title: "Pre Tax Return",
                          value:
                              "\u20B9 ${BaseFunction().formatIndianNumber(int.parse(value.withoutTDS.toStringAsFixed(0)))}",
                        ),
                        getRowSectionWithItem(
                          title: "TDS Applicable",
                          value: "${planDetail["tax_applicable"]}%",
                        ),
                        getRowSectionWithItem(
                          title: "Post TDS Return",
                          value:
                              "\u20B9 ${BaseFunction().formatIndianNumber(int.parse(value.totalSum.toStringAsFixed(0)))}",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryText(
                          text: "Bank Details",
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                        ),
                        ...value.bankDetail.asMap().entries.map((e) {
                          return Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getRowSectionWithItem(
                                title: "Name : ",
                                value: " ${e.value["note"]}".toString().trim(),
                                isBoldText: true,
                              ),
                              getRowSectionWithItem(
                                title: "AC.No : ",
                                value: " ${e.value["ac"]}",
                                isBoldText: true,
                              ),
                              getRowSectionWithItem(
                                title: "IFSC : ",
                                isBoldText: true,
                                value: " ${e.value["ifsc"]}",
                              ),
                              getRowSectionWithItem(
                                title: "Bank Name :",
                                value: " ${e.value["bankname"]}",
                                isBoldText: true,
                              ),
                              getRowSectionWithItem(
                                title: "Branch Name :",
                                isBoldText: true,
                                value: " ${e.value["branch"]}",
                              ),
                              getRowSectionWithItem(
                                title: "Account Type : ",
                                isBoldText: true,
                                value: " ${e.value["b_type"] ?? ""}",
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 10),
                        PrimaryText(
                          text: "Transaction ID",
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                        ),
                        SizedBox(
                          height: 45,
                          child: TextFormField(
                            controller: value.transactionIDController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: "",
                              labelStyle: AppTextStyles.hintStyle,
                              hintStyle: AppTextStyles.hintStyle,
                              errorStyle: AppTextStyles.errorStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: AppColors.lightGrey.withAlpha(80),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: AppColors.lightGrey.withAlpha(80),
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: AppColors.lightGrey.withAlpha(20),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        PrimaryText(
                          text: "Transaction Proof",
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: value.pickFile,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      const PrimaryText(
                                        text: "Choose File",
                                        weight: AppFont.regular,
                                        size: AppDimen.textSize12,
                                      ),
                                      const VerticalDivider(width: 20),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: PrimaryText(
                                          text:
                                              value.fileName ??
                                              "No file chosen",
                                          weight: AppFont.bold,
                                          align: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          size: AppDimen.textSize10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text: "Submit",
                          onTap: () {
                            if (value.fileName == null) {
                              AppSnackBar.show(
                                context,
                                message: "kindly upload a transaction proof!!",
                              );
                            } else if (value
                                .transactionIDController
                                .text
                                .isEmpty) {
                              AppSnackBar.show(
                                context,
                                message: "kindly enter transaction id!!",
                              );
                            } else {
                              value.userInvestmentPlan(
                                context: context,
                                id: planDetail["id"].toString(),
                                cName: planDetail["c_name"],
                                category: planDetail["category"].toString(),
                                name: planDetail["name"],
                                planID: planDetail["plan_id"],
                                tenure: planDetail["tenure"],
                                investDate: planDetail["ins_date"],
                                filePath: value.filePath,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getRowSectionWithItem({
    required String title,
    required String value,
    bool? isBoldText = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0,
      children: [
        PrimaryText(
          text: title,
          size: AppDimen.textSize12,
          weight: isBoldText == true ? AppFont.bold : AppFont.regular,
          color: AppColors.black,
        ),
        PrimaryText(
          text: value,
          size: AppDimen.textSize12,
          weight: AppFont.semiBold,
          color: isBoldText != true ? AppColors.primary : AppColors.black,
        ),
      ],
    );
  }

  Widget buildCheckBox({
    required GestureTapCallback onTap,
    required String firstContent,
    required String content,
    required bool isCheck,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCheck ? AppColors.greenCircleColor : AppColors.white,
              border: Border.all(
                color:
                    isCheck
                        ? AppColors.greenCircleColor
                        : AppColors.progressGreyColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                isCheck
                    ? const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: AppDimen.textSize16,
                    )
                    : null,
          ).toGesture(onTap: onTap),
        ),
        SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '',
              children: <TextSpan>[
                TextSpan(text: firstContent, style: AppTextStyles.bodyStyle),
                TextSpan(text: content, style: AppTextStyles.errorStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
