import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/pages/Investment/investment_completed_page.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CompletedPlanPage extends StatelessWidget {
  final List<Map<String, dynamic>> completedPlans;
  const CompletedPlanPage({super.key, required this.completedPlans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.screenBgColor,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Center(
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
                  SizedBox(width: 10),
                  PrimaryText(
                    text: "Completed Project",
                    size: AppDimen.textSize16,
                    weight: AppFont.semiBold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.screenBgColor,
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: completedPlans.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    completedPlans[index]["uploadfiles_url"],
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: completedPlans[index]["name"],
                        weight: AppFont.semiBold,
                        size: AppDimen.textSize12,
                        align: TextAlign.start,
                      ),
                      PrimaryText(
                        text:
                            "\u20B9 ${App().formatIndianNumber(double.parse(completedPlans[index]["total_investment_amt"]).toInt())}",
                        weight: AppFont.regular,
                        size: AppDimen.textSize14,
                        color: AppColors.lightGrey,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
                    size: 15,
                  ),
                ),
              ],
            ).toGesture(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => InvestmentCompletePage(
                          planDetail: completedPlans[index],
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
