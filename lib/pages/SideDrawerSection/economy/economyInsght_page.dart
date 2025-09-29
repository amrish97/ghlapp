import 'package:flutter/material.dart';
import 'package:ghlapp/pages/SideDrawerSection/economy/economy_detail_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
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
        List<Map<String, dynamic>> displayList =
            value.filteredEconomyInsights.isNotEmpty
                ? value.filteredEconomyInsights
                : value.economyInsights;
        print("displayList---->> ${displayList.length}");
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
                    getBackButton(
                      context,
                      onTap: () {
                        Provider.of<HomeProvider>(
                          context,
                          listen: false,
                        ).reset();
                        Provider.of<HomeProvider>(
                          context,
                          listen: false,
                        ).resetFilter();
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    PrimaryText(
                      text: AppStrings.economyInsight,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                    Spacer(),
                    if (value.selectedDateTime != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryText(
                            text: "Selected Date",
                            size: AppDimen.textSize12,
                          ),
                          PrimaryText(
                            text: value.selectedDateTime!,
                            weight: AppFont.semiBold,
                            size: AppDimen.textSize14,
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
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
                              _pickDate(
                                context,
                                Provider.of<HomeProvider>(
                                  context,
                                  listen: false,
                                ),
                              );
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
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final economyData = displayList[index];
              value.economyInsights.sort((a, b) {
                DateTime dateA = DateTime.parse(a["created_at"]);
                DateTime dateB = DateTime.parse(b["created_at"]);
                return dateB.compareTo(dateA);
              });
              List<Map<String, dynamic>> latestUpdates = [
                value.economyInsights.first,
              ];
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                          economyData["upload_files"] ?? "",
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

  Future<void> _pickDate(context, HomeProvider provider) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      provider.filterEconomyByDate(picked);

      if (provider.filteredEconomyInsights.isEmpty) {
        AppSnackBar.show(context, message: "No news available for this date");
      }
    } else {
      provider.resetFilter();
    }
  }
}
