import 'package:flutter/material.dart';
import 'package:ghlapp/pages/profile/economy/economy_detail_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class EconomyInsightPage extends StatelessWidget {
  const EconomyInsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
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
                        Provider.of<HomeProvider>(
                          context,
                          listen: false,
                        ).reset();
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    PrimaryText(
                      text: "Economy Insights",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                    Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      child: "assets/images/calender.png"
                          .toImageAsset(height: 20, width: 20)
                          .toGesture(
                            onTap: () {
                              _pickDate(context, value.economyInsights);
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body: ListView.builder(
            itemCount: value.economyInsights.length,
            itemBuilder: (context, index) {
              final economyData = value.economyInsights[index];
              value.economyInsights.sort((a, b) {
                DateTime dateA = DateTime.parse(a["create_date"]);
                DateTime dateB = DateTime.parse(b["create_date"]);
                return dateB.compareTo(dateA);
              });
              List<Map<String, dynamic>> latestUpdates = [
                value.economyInsights.first,
              ];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(color: AppColors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          economyData["uploadfiles_url"] ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    PrimaryText(
                      text: economyData["title"],
                      align: TextAlign.start,
                      size: AppDimen.textSize14,
                      weight: AppFont.semiBold,
                    ),
                  ],
                ),
              ).toGesture(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EconomyDetailPage(
                            economyDetail: economyData,
                            index: index,
                            latestUpdates: latestUpdates,
                          ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _pickDate(context, List<Map<String, dynamic>> newsList) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      String selectedDateStr =
          "${picked.year.toString().padLeft(4, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";
      List<Map<String, dynamic>> filtered =
          newsList.where((item) {
            return item["create_date"].toString().startsWith(selectedDateStr);
          }).toList();

      if (filtered.isEmpty) {
        AppSnackBar.show(context, message: "No news available for this date");
      } else {
        print("filtered---->> $filtered");
      }
    }
  }
}
