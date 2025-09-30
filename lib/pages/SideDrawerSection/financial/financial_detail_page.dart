import 'package:flutter/material.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/readmore_widget.dart';

class FinancialDetailPage extends StatelessWidget {
  final Map<String, dynamic> financeDetail;
  final List<Map<String, dynamic>> latestUpdates;
  final int index;

  const FinancialDetailPage({
    super.key,
    required this.financeDetail,
    required this.index,
    required this.latestUpdates,
  });

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
            child: Row(children: [getBackButton(context)]),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                text: financeDetail["title"],
                weight: AppFont.semiBold,
                size: AppDimen.textSize16,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    financeDetail["upload_files"] ?? "",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ReadMoreWidget(
                text: financeDetail["description"].toString().replaceAll(
                  "\"",
                  "",
                ),
                trimLength:
                    (financeDetail["description"].toString().length / 2)
                        .toInt(),
                index: index,
              ),
              const SizedBox(height: 20),
              PrimaryText(
                text: AppStrings.latestUpdates,
                weight: AppFont.semiBold,
                size: AppDimen.textSize16,
              ),
              const SizedBox(height: 20),
              Container(
                color: AppColors.white,
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        latestUpdates[0]["upload_files"] ?? "",
                        fit: BoxFit.cover,
                        height: 160,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryText(
                      text: latestUpdates[0]["title"] ?? "",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize14,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
