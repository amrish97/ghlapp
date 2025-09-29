import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/tracking_status.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PortfolioExplorePage extends StatelessWidget {
  final Map<String, dynamic> exploreData;

  const PortfolioExplorePage({super.key, required this.exploreData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
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
                SizedBox(width: 10),
                PrimaryText(
                  text: "Explore",
                  weight: AppFont.semiBold,
                  size: AppDimen.textSize18,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.brownColor],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PrimaryText(
                              text: exploreData["plan_name"],
                              weight: AppFont.semiBold,
                              size: AppDimen.textSize12,
                              align: TextAlign.start,
                              color: AppColors.white,
                            ),
                            const SizedBox(height: 6),
                            PrimaryText(
                              text: AppStrings.paymentMode,
                              weight: AppFont.regular,
                              size: AppDimen.textSize12,
                              align: TextAlign.start,
                              color: Colors.amber,
                            ),
                            const SizedBox(height: 10),
                            investmentTable(value),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          exploreData["plan"]["uploadfiles_url"] ?? "",
                          fit: BoxFit.cover,
                          height: 200,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: value.chipData.length,
                  itemBuilder: (context, index) {
                    final isSelected = value.selectedIndexExplore == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: customChip(value.chipData[index], isSelected, () {
                        value.setIndexExploreData(index);
                      }),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: AppColors.screenBgColor,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (value.selectedIndexExplore == 0)
                          Column(
                            children: [
                              if (value.userInvestDocs.isEmpty)
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 100),
                                      Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 50),
                                            Image.asset(
                                              "assets/images/empty_view.png",
                                              scale: 6,
                                            ),
                                            const SizedBox(height: 10),
                                            PrimaryText(
                                              text:
                                                  "No More ${AppStrings.investDoc}",
                                              weight: AppFont.semiBold,
                                              size: AppDimen.textSize14,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              for (var ins in value.userInvestDocs) ...[
                                Container(
                                  padding: EdgeInsets.all(15),
                                  margin: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 15.0,
                                        ),
                                        child: Row(
                                          children: [
                                            PrimaryText(
                                              text: "Documents",
                                              weight: AppFont.semiBold,
                                              size: AppDimen.textSize14,
                                            ),
                                            Spacer(),
                                            PrimaryText(
                                              text: "Download",
                                              weight: AppFont.semiBold,
                                              size: AppDimen.textSize14,
                                              color: AppColors.primary,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      buildDocumentRow(
                                        "Acknowledgement Letter",
                                        ins["acknowledgement_url"] ?? "",
                                      ),
                                      SizedBox(height: 15),
                                      buildDocumentRow(
                                        "Allotment Letter",
                                        ins["allotment_url"] ?? "",
                                      ),
                                      SizedBox(height: 15),
                                      buildDocumentRow(
                                        "Debenture Certificate",
                                        ins["debenture_certificate_url"] ?? "",
                                      ),
                                      SizedBox(height: 15),
                                      buildDocumentRow(
                                        "Debenture Agreement",
                                        ins["debenture_agreement_url"] ?? "",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        if (value.selectedIndexExplore == 1)
                          Column(
                            children: [
                              if (value.userSchedule.isEmpty)
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 100),
                                      Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 50),
                                            Image.asset(
                                              "assets/images/empty_view.png",
                                              scale: 6,
                                            ),
                                            const SizedBox(height: 10),
                                            PrimaryText(
                                              text: "No More history Available",
                                              weight: AppFont.semiBold,
                                              size: AppDimen.textSize14,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ...value.userSchedule.asMap().entries.map((
                                toElement,
                              ) {
                                DateTime parsedDate = DateTime.parse(
                                  toElement.value["tentative_date"],
                                );
                                String formattedDate = DateFormat(
                                  "dd-MM-yy",
                                ).format(parsedDate);
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            AppColors.historyCardColor,
                                        child: PrimaryText(
                                          text: "${toElement.key + 1}",
                                          size: AppDimen.textSize14,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 7,
                                        children: [
                                          getRowWithItem(
                                            label: "Date : ",
                                            value: formattedDate,
                                          ),
                                          getRowWithItem(
                                            label: "TDS : ",
                                            value:
                                                "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(toElement.value["tds"]).toInt())}",
                                          ),
                                          getRowWithItem(
                                            label: "Net : ",
                                            value:
                                                "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(toElement.value["net_payout"]).toInt())}",
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          getRowWithItem(
                                            label: "Amount : ",
                                            value:
                                                "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(toElement.value["expected_amount"]).toInt())}",
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.greenCircleColor,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: PrimaryText(
                                              text:
                                                  toElement
                                                      .value["paid_status"],
                                              weight: AppFont.semiBold,
                                              color: AppColors.white,
                                              size: AppDimen.textSize14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        if (value.selectedIndexExplore == 2)
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TrackingStatus(status: value.trackingStatus),
                          ),
                        if (value.selectedIndexExplore == 3)
                          Column(
                            children: [
                              if (value.userInvestDocs.isEmpty)
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 100),
                                      Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 50),
                                            Image.asset(
                                              "assets/images/empty_view.png",
                                              scale: 6,
                                            ),
                                            const SizedBox(height: 10),
                                            PrimaryText(
                                              text: "No More TDS available",
                                              weight: AppFont.semiBold,
                                              size: AppDimen.textSize14,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              for (var ins in value.userInvestDocs) ...[
                                const SizedBox(height: 50),
                                Center(
                                  child: Image.asset(
                                    "assets/images/pdf.png",
                                    scale: 6,
                                  ).toGesture(
                                    onTap: () {
                                      BaseFunction().openPdf(ins["tds_url"]);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                PrimaryText(
                                  text:
                                      "kindly Check it your TDS Information! \n tap to See!!",
                                  weight: AppFont.semiBold,
                                  size: AppDimen.textSize14,
                                ),
                              ],
                            ],
                          ),
                        if (value.selectedIndexExplore == 4)
                          ...value.userPlanExploreData.asMap().entries.map((
                            toElement,
                          ) {
                            return Visibility(
                              visible:
                                  toElement.value["1_cashback"] != "0" ||
                                  toElement.value["dob_invest"] != "0" ||
                                  toElement.value["diwali_invest"] != "0",
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: buildCashbackCard(toElement.value),
                              ),
                            );
                          }),
                        if (value.selectedIndexExplore == 5)
                          Column(
                            children: [
                              for (var ins in value.userPlanExploreData) ...[
                                if (ins["plan"]?["charge_url"] == null) ...[
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 50),
                                        Image.asset(
                                          "assets/images/empty_view.png",
                                          scale: 6,
                                        ),
                                        const SizedBox(height: 10),
                                        PrimaryText(
                                          text:
                                              "No Charge Creation file available",
                                          weight: AppFont.semiBold,
                                          size: AppDimen.textSize14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ] else ...[
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Image.asset(
                                      "assets/images/pdf.png",
                                      scale: 6,
                                    ).toGesture(
                                      onTap: () {
                                        BaseFunction().openPdf(
                                          ins["plan"]["charge_url"],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  PrimaryText(
                                    text:
                                        "Kindly check your information! \nTap to see!!",
                                    weight: AppFont.semiBold,
                                    size: AppDimen.textSize14,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        if (value.selectedIndexExplore == 6)
                          Column(
                            children: [
                              for (var ins in value.userPlanExploreData) ...[
                                if (ins["plan"]?["deed_url"] == null) ...[
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 50),
                                        Image.asset(
                                          "assets/images/empty_view.png",
                                          scale: 6,
                                        ),
                                        const SizedBox(height: 10),
                                        PrimaryText(
                                          text: "No Mortgage file available",
                                          weight: AppFont.semiBold,
                                          size: AppDimen.textSize14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ] else ...[
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Image.asset(
                                      "assets/images/pdf.png",
                                      scale: 6,
                                    ).toGesture(
                                      onTap: () {
                                        BaseFunction().openPdf(
                                          ins["plan"]["deed_url"],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  PrimaryText(
                                    text:
                                        "Kindly check your information! \nTap to see!!",
                                    weight: AppFont.semiBold,
                                    size: AppDimen.textSize14,
                                  ),
                                ],
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCashbackCard(Map<String, dynamic> data) {
    if (data["1_cashback"] != "0") {
      return cashbackSection(
        amount: data["1_cashback_amount"] ?? "0",
        status: data["1_cashback_paid_status"] ?? "",
        date: data["cashback_statusupdated_date"] ?? "",
      );
    } else if (data["dob_invest"] != "0") {
      return cashbackSection(
        amount: data["dob_cashback_amount"] ?? "0",
        status: data["dob_cashback_paid_status"] ?? "",
        date: data["dob_cashback_status_updated_date"] ?? "",
      );
    } else if (data["diwali_invest"] != "0") {
      return cashbackSection(
        amount: data["diwali_cashback_amount"] ?? "0",
        status: data["diwali_cashback_paid_status"] ?? "",
        date: data["diwali_cashback_status_updated_date"] ?? "",
      );
    }
    return SizedBox.shrink();
  }

  Widget cashbackSection({
    required String amount,
    required String status,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PrimaryText(
                text: "Direct bank Transfer",
                weight: AppFont.semiBold,
                size: AppDimen.textSize14,
              ),
              PrimaryText(
                text: " (1 %) ",
                weight: AppFont.semiBold,
                size: AppDimen.textSize14,
                color: AppColors.greenCircleColor,
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: PrimaryText(
                  text: status,
                  weight: AppFont.semiBold,
                  size: AppDimen.textSize14,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          if (status != "Unpaid")
            getRowWithItem(label: "Paid Date : ", value: date),
          getRowWithItem(
            label: "Amount : ",
            value:
                " \u20B9 ${BaseFunction().formatIndianNumber(double.tryParse(amount)?.toInt() ?? 0)}",
          ),
        ],
      ),
    );
  }

  Widget getRowWithItem({required String label, required String value}) {
    return Row(
      children: [
        PrimaryText(
          text: label,
          weight: AppFont.semiBold,
          size: AppDimen.textSize14,
        ),
        PrimaryText(
          text: value,
          weight: AppFont.regular,
          size: AppDimen.textSize14,
        ),
      ],
    );
  }

  Widget customChip(String label, bool selected, VoidCallback onTap) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color:
            selected ? AppColors.primary : Color.fromRGBO(219, 219, 219, 0.68),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.transparent),
      ),
      child: PrimaryText(
        text: label,
        weight: AppFont.semiBold,
        align: TextAlign.center,
        size: AppDimen.textSize12,
        color: selected ? AppColors.white : AppColors.black,
      ),
    ).toGesture(onTap: onTap);
  }

  Widget buildDocumentRow(String title, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryText(
            text: title,
            weight: AppFont.regular,
            size: AppDimen.textSize14,
          ),
          Image.asset(
            url.isNotEmpty
                ? "assets/images/download.png"
                : "assets/images/process.png",
            height: 20,
            width: 20,
          ).toGesture(
            onTap: () {
              if (url.isNotEmpty) {
                BaseFunction().openPdf(url);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget investmentTable(HomeProvider provider) {
    DateTime parsedDate = DateTime.parse(exploreData["insert_date"]);
    String formattedDate = DateFormat("dd-MM-yy").format(parsedDate);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: AppColors.white, width: 1),
            verticalInside: BorderSide(color: AppColors.white, width: 1),
          ),
          columnWidths: const {0: FlexColumnWidth(5), 1: FlexColumnWidth(4)},
          children: [
            _buildRow(
              AppStrings.investAmount,
              "\u20B9 ${BaseFunction().formatIndianNumber(double.parse(exploreData["ins_amt"]).toInt())}",
            ),
            _buildRow(AppStrings.investsDate, formattedDate),
            _buildRow(
              "Tenure Period",
              "${provider.tenurePaid}/${exploreData["tenure"]} Months",
            ),
            _buildRow(
              "Payout Received",
              "\u20B9 ${BaseFunction().formatIndianNumber(int.parse(provider.totalPayout.toStringAsFixed(0)))}",
            ),
            _buildRow("No of Units", exploreData["units"].toString()),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: PrimaryText(
            text: label,
            weight: AppFont.medium,
            align: TextAlign.center,
            size: AppDimen.textSize12,
            color: AppColors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryText(
            text: value,
            weight: AppFont.medium,
            size: AppDimen.textSize12,
            color: AppColors.white,
            align: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
