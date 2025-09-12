import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/pages/Investment/invest_now_page.dart';
import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/custom_textField.dart';
import 'package:ghlapp/widgets/progress_view.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../constants.dart';

class InvestmentDetailPage extends StatelessWidget {
  final Map<String, dynamic> planDetail;
  const InvestmentDetailPage({super.key, required this.planDetail});

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
                      value.clearData();
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
                                      "\u20B9 ${App().formatIndianNumber(double.parse(planDetail["deposit_amount"]).toInt())}",
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
                      children: [
                        getRowSectionWithItem(
                          title: "PER TAX RETURN",
                          value: "${planDetail["return_of_investment"]}%",
                        ),
                        getRowSectionWithItem(
                          title: "MINIMUM INVESTMENT",
                          value:
                              "\u20B9 ${App().formatIndianNumber(double.parse(planDetail["min_investment_amt"]).toInt())}",
                        ),
                        getRowSectionWithItem(
                          title: "CAPITAL INVESTED",
                          value:
                              value.amountInvestController.text.isEmpty
                                  ? ""
                                  : "\u20B9 ${App().formatIndianNumber(int.parse(value.amountInvestController.text))}",
                        ),
                        getRowSectionWithItem(
                          title: "TDS APPLICABLE",
                          value: "${planDetail["tax_applicable"]}%",
                        ),
                        getRowSectionWithItem(
                          title: "MONTHLY RETURNS",
                          value:
                              "\u20B9 ${App().formatIndianNumber(int.parse(value.monthlyReturn.toStringAsFixed(0)))}",
                        ),
                        getRowSectionWithItem(
                          title: "YEARLY RETURNS",
                          value:
                              "\u20B9 ${App().formatIndianNumber(int.parse((value.monthlyReturn * 12).toStringAsFixed(0)))}",
                        ),
                        getRowSectionWithItem(
                          title: "SUM OF CAPITAL & ROI",
                          value:
                              "\u20B9 ${App().formatIndianNumber(int.parse(value.totalSum.toStringAsFixed(0)))}",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: "Enter or choose an amount to invest below",
                        color: AppColors.black,
                        weight: AppFont.regular,
                        size: AppDimen.textSize12,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "",
                        controller: value.amountInvestController,
                        keyboardType: TextInputType.number,
                        showBorderColor: true,
                        errorText: value.errorMessage,
                        onChanged: (val) {
                          value.updateInvestment(
                            val,
                            double.tryParse(
                                  planDetail["return_of_investment"].toString(),
                                ) ??
                                0,
                            double.tryParse(
                                  planDetail["tax_applicable"].toString(),
                                ) ??
                                0,
                            int.tryParse(planDetail["tenure"].toString()) ?? 2,
                            double.tryParse(
                                  planDetail["min_investment_amt"].toString(),
                                ) ??
                                0,
                            double.tryParse(
                                  planDetail["max_investment_amt"].toString(),
                                ) ??
                                0,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PrimaryText(
                        text: value.amountInWords,
                        color: AppColors.lightGrey,
                        size: AppDimen.textSize10,
                      ),
                    ],
                  ),
                  CustomButton(
                    text: "Payment Schedule",
                    onTap: () async {
                      final enteredText =
                          value.amountInvestController.text.trim();
                      if (enteredText.isEmpty) {
                        AppSnackBar.show(
                          context,
                          message: "Please enter Investment amount!!",
                        );
                        return;
                      } else {
                        final res = await value.planSchedule(
                          context,
                          perTaxReturn:
                              planDetail["return_of_investment"].toString(),
                          capitalInvested:
                              value.amountInvestController.text.toString(),
                          minimumInvestment:
                              planDetail["min_investment_amt"].toString(),
                          tdsApplicable:
                              planDetail["tax_applicable"].toString(),
                          tenure: planDetail["tenure"].toString(),
                        );
                        if (res != null) {
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
                                        MediaQuery.of(context).size.width - 20,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.5,
                                    color: AppColors.white,
                                    child: Column(
                                      children: [
                                        ColoredBox(
                                          color: AppColors.primary,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 10),
                                              const PrimaryText(
                                                text: "Payment Schedule",
                                                size: AppDimen.textSize14,
                                                weight: AppFont.semiBold,
                                                color: AppColors.white,
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: AppColors.white,
                                                ),
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                PrimaryText(
                                                  text:
                                                      "Investment \u20B9${planDetail["min_investment_amt"]}",
                                                  size: AppDimen.textSize12,
                                                  weight: AppFont.semiBold,
                                                  color: AppColors.black,
                                                ),
                                                PrimaryText(
                                                  text:
                                                      "${planDetail["name"]}(${planDetail["plan_id"]})",
                                                  size: AppDimen.textSize12,
                                                  weight: AppFont.regular,
                                                  color: AppColors.lightGrey,
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await _exportPDF(
                                                      res,
                                                      planDetail["name"],
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      color:
                                                          AppColors
                                                              .greenCircleColor,
                                                    ),
                                                    child: const PrimaryText(
                                                      text: "Export PDF",
                                                      color: AppColors.white,
                                                      weight: AppFont.regular,
                                                      size: AppDimen.textSize12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await _exportCSV(res);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            AppColors
                                                                .greenCircleColor,
                                                      ),
                                                    ),
                                                    child: const PrimaryText(
                                                      text: "Export CSV",
                                                      color: AppColors.black,
                                                      weight: AppFont.regular,
                                                      size: AppDimen.textSize12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: const [
                                            Expanded(
                                              child: PrimaryText(
                                                text: "S.No",
                                                weight: AppFont.bold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: PrimaryText(
                                                text: "Tentative Date",
                                                weight: AppFont.bold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: PrimaryText(
                                                text: "Gross Interest",
                                                weight: AppFont.bold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: PrimaryText(
                                                text: "TDS",
                                                weight: AppFont.bold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: PrimaryText(
                                                text: "Net Interest",
                                                weight: AppFont.bold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount:
                                                res["paymentSchedule"].length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 5,
                                            ),
                                            itemBuilder: (context, index) {
                                              final item =
                                                  res["paymentSchedule"][index];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: PrimaryText(
                                                      text:
                                                          (index + 1)
                                                              .toString(),
                                                      size: AppDimen.textSize12,
                                                      color: AppColors.black,
                                                      weight: AppFont.regular,
                                                      align: TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: PrimaryText(
                                                      text:
                                                          item["payment_date"]
                                                              .toString(),
                                                      size: AppDimen.textSize12,
                                                      color: AppColors.black,
                                                      weight: AppFont.regular,
                                                      align: TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: PrimaryText(
                                                      text: item["gross_amount"]
                                                          .toStringAsFixed(0),
                                                      size: AppDimen.textSize12,
                                                      color: AppColors.black,
                                                      weight: AppFont.regular,
                                                      align: TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: PrimaryText(
                                                      text: item["tds"]
                                                          .toStringAsFixed(0),
                                                      size: AppDimen.textSize12,
                                                      color: AppColors.black,
                                                      weight: AppFont.regular,
                                                      align: TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: PrimaryText(
                                                      text: item["net_return"]
                                                          .toStringAsFixed(0),
                                                      size: AppDimen.textSize12,
                                                      color: AppColors.black,
                                                      weight: AppFont.regular,
                                                      align: TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: AppColors.lightGrey,
                                        ),

                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: PrimaryText(
                                                text: "Principal",
                                                weight: AppFont.regular,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: PrimaryText(
                                                text:
                                                    "\u20B9${res["capital_invested"].toString()}",
                                                weight: AppFont.semiBold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: PrimaryText(
                                                text: "Return",
                                                weight: AppFont.regular,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: PrimaryText(
                                                text:
                                                    "\u20B9${res["returns"].toString()}",
                                                weight: AppFont.semiBold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: PrimaryText(
                                                text: "Total",
                                                weight: AppFont.regular,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: PrimaryText(
                                                text:
                                                    "\u20B9${double.parse(res["sum_of_capital"].toString())}",
                                                weight: AppFont.semiBold,
                                                size: AppDimen.textSize12,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                          ],
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
                      }
                    },
                    color: AppColors.greenCircleColor,
                  ),
                  SizedBox(height: 10),
                  PrimaryText(
                    text: "Select Payment type",
                    weight: AppFont.regular,
                    color: AppColors.progressGreyColor,
                    size: AppDimen.textSize14,
                  ),
                  buildCheckBox(
                    onTap: value.setRememberClick,
                    firstContent: "Direct Bank Transfer ",
                    content: "(Grab upto 2% cashback on your investments)",
                    isCheck: value.isRememberClick,
                  ),
                  getBottomButton(value: value, context: context),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getBottomButton({
    required InvestmentProvider value,
    required BuildContext context,
  }) {
    switch (value.kycStatus) {
      case "No data":
        return CustomButton(
          onTap: () {
            Navigator.pushNamed(context, AppRouteEnum.kyc.name);
          },
          text: " Complete Your KYC",
          color: AppColors.primary.withAlpha(90),
        );
      case "Pending":
        return CustomButton(
          onTap: () {
            AppSnackBar.show(context, message: "Please Wait for KYC Approval");
            return;
          },
          text: "Your KYC Status pending Waiting For Approval",
          color: AppColors.brownColor.withAlpha(140),
        );
      case "Approved":
        return CustomButton(
          text: "Invest Now",
          onTap: () async {
            if (value.amountInvestController.text.isEmpty) {
              AppSnackBar.show(
                context,
                message: "Please enter Investment amount!!",
              );
              return;
            } else if (!value.isRememberClick) {
              AppSnackBar.show(
                context,
                message: "Please select a Checkbox in Payment type!!",
              );
            } else {
              await value.getBankDetails(context, id: planDetail["id"]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvestNowPage(planDetail: planDetail),
                ),
              );
            }
          },
        );
      case "rejected":
        return CustomButton(
          text: "KYC Rejected",
          onTap: () {
            AppSnackBar.show(
              context,
              message: "Your KYC is Rejected kindly contact Branch",
            );
            return;
          },
        );
    }
  }

  Future<void> _exportPDF(dynamic res, String planName) async {
    final poppinsRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Regular.ttf"),
    );

    final poppinsBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Bold.ttf"),
    );

    final pdf = pw.Document();
    final datetime = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(datetime);
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Transform.rotate(
                    angle: 0.5,
                    child: pw.Opacity(
                      opacity: 0.1,
                      child: pw.Text(
                        AppStrings.appName,
                        style: pw.TextStyle(
                          font: poppinsRegular,
                          fontSize: 80,
                          color: PdfColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text(
                        planName,
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: poppinsRegular,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        "(Download Date",
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: poppinsRegular,
                          color: PdfColor.fromInt(0xFFDA0000),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        ": $formattedDate)",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Investment Amount (\u20B9):",
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: poppinsRegular,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        res["capital_invested"],
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: poppinsBold,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Total Net Intrest (\u20B9):",
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: poppinsRegular,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        res["returns"].toString(),
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: poppinsBold,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.TableHelper.fromTextArray(
                    headers: [
                      "Tentative Date",
                      "Gross Interest (\u20B9)",
                      "TDS (\u20B9)",
                      "Net Interest (\u20B9)",
                    ],
                    data: List.generate(res["paymentSchedule"].length, (i) {
                      final item = res["paymentSchedule"][i];
                      String formattedDateInTable = DateFormat(
                        'dd-MM-yyyy',
                      ).format(DateTime.parse(item["payment_date"].toString()));
                      return [
                        formattedDateInTable,
                        item["gross_amount"].toString(),
                        item["tds"].toString(),
                        item["net_return"].toString(),
                      ];
                    }),

                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      font: poppinsBold, // text color
                    ),
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFDA0000),
                    ),
                    cellStyle: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.black,
                    ),
                    cellHeight: 25,
                    cellAlignments: {
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                    },
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Principal: \u20B9 ${res["capital_invested"]}",
                    style: pw.TextStyle(
                      fontSize: 16,
                      font: poppinsRegular,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                  pw.Text(
                    "Return: \u20B9 ${res["returns"]}",
                    style: pw.TextStyle(
                      fontSize: 16,
                      font: poppinsRegular,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                  pw.Text(
                    "Total: \u20B9 ${res["sum_of_capital"]}",
                    style: pw.TextStyle(
                      fontSize: 16,
                      font: poppinsRegular,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/payment_schedule.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
  }

  Future<void> _exportCSV(dynamic res) async {
    List<List<dynamic>> rows = [];
    String padRight(String value, int width) {
      return value.padRight(width);
    }

    rows.add([
      "S.No",
      "Tentative Date",
      "Gross Interest (\u20B9)",
      "TDS (\u20B9)",
      "Net Interest (\u20B9)",
    ]);
    for (int i = 0; i < res["paymentSchedule"].length; i++) {
      final item = res["paymentSchedule"][i];
      rows.add([
        padRight((i + 1).toString(), 5),
        padRight(item["payment_date"].toString(), 15),
        padRight(item["gross_amount"].toString(), 15),
        padRight(item["tds"].toString(), 10),
        padRight(item["net_return"].toString(), 15),
      ]);
    }
    rows.add([]);
    rows.add(["Principal: \u20B9${res["capital_invested"]}"]);
    rows.add(["Return: \u20B9${res["returns"]}"]);
    rows.add(["Total: \u20B9${res["sum_of_capital"]}"]);

    String csvData = const ListToCsvConverter().convert(rows);

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/payment_schedule.csv");
    await file.writeAsString(csvData);
    await OpenFilex.open(file.path);
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
          weight: AppFont.semiBold,
          color: AppColors.primary,
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
