import 'package:flutter/material.dart';
import 'package:ghlapp/pages/profile/portfolio/portfolio_explore_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  void initState() {
    context.read<HomeProvider>().getPortfolioData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.screenBgColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: AppBar(
                forceMaterialTransparency: true,
                automaticallyImplyLeading: false,
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                backgroundColor: AppColors.screenBgColor,
                bottom: TabBar(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  labelStyle: AppTextStyles.bodyStyle,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.primary,
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.black,
                  automaticIndicatorColorAdjustment: true,
                  padding: EdgeInsets.zero,
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Tab(text: AppStrings.activeInvest),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Tab(text: AppStrings.completedInvest),
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                activeInvestment(activePlanData: value.activePlanData),
                completedInvestment(completedPlanData: value.completedPlanData),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget activeInvestment({
    required List<Map<String, dynamic>> activePlanData,
  }) {
    return activePlanData.isEmpty
        ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/empty_view.png", scale: 6),
              SizedBox(height: 20),
              PrimaryText(
                text: AppStrings.noActiveInvest,
                weight: AppFont.semiBold,
                size: AppDimen.textSize14,
              ),
            ],
          ),
        )
        : ListView.builder(
          itemCount: activePlanData.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            DateTime parsedDate = DateTime.parse(
              activePlanData[index]["insert_date"],
            );
            String formattedDate = DateFormat("dd-MM-yy").format(parsedDate);
            DateTime maturityDate = DateTime.parse(
              activePlanData[index]["maturity"],
            );
            String maturityFormattedDate = DateFormat(
              "dd-MM-yy",
            ).format(maturityDate);
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: EdgeInsets.all(18),
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            activePlanData[index]["plan"]["uploadfiles_url"] ??
                                "",
                            fit: BoxFit.cover,
                            width: 148,
                            height: 128,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: PrimaryText(
                                    text: activePlanData[index]["plan_name"],
                                    align: TextAlign.start,
                                    weight: AppFont.semiBold,
                                    size: AppDimen.textSize12,
                                  ),
                                ),
                              ),
                              buildRowWidget(
                                firstContent: "${AppStrings.investsDate} :",
                                content: formattedDate,
                              ),
                              buildRowWidget(
                                firstContent: "${AppStrings.investAmount}: ",
                                content:
                                    "\u20B9 ${activePlanData[index]["ins_amt"]}",
                              ),
                              buildRowWidget(
                                firstContent: "Maturity Date:  ",
                                content: maturityFormattedDate,
                              ),
                              SizedBox(height: 10),
                              Consumer<HomeProvider>(
                                builder: (context, value, child) {
                                  return Align(
                                    alignment: AlignmentGeometry.bottomRight,
                                    child: Container(
                                      height: 40,
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: PrimaryText(
                                        text: AppStrings.explore,
                                        weight: AppFont.semiBold,
                                        size: AppDimen.textSize12,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ).toGesture(
                                    onTap: () {
                                      value.getUserInvestmentDocument(
                                        context,
                                        activePlanData[index]["id"],
                                      );
                                      value.resetIndexExploreData();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => PortfolioExplorePage(
                                                exploreData:
                                                    activePlanData[index],
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/images/cashback-ribbon.png",
                    scale: 4,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            );
          },
        );
  }

  Widget buildRowWidget({
    required String firstContent,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PrimaryText(
              text: firstContent,
              size: AppDimen.textSize12,
              weight: AppFont.regular,
              align: TextAlign.start,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: PrimaryText(
              text: content,
              size: AppDimen.textSize12,
              weight: AppFont.semiBold,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget completedInvestment({
    required List<Map<String, dynamic>> completedPlanData,
  }) {
    return completedPlanData.isEmpty
        ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/empty_view.png", scale: 6),
              SizedBox(height: 20),
              PrimaryText(
                text: AppStrings.noCompletedInvest,
                weight: AppFont.semiBold,
                size: AppDimen.textSize14,
              ),
            ],
          ),
        )
        : ListView.builder(
          itemCount: completedPlanData.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: EdgeInsets.all(18),
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            completedPlanData[index]["plan"]["uploadfiles_url"] ??
                                "",
                            fit: BoxFit.cover,
                            height: 150,
                            width: 140,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PrimaryText(
                                text: completedPlanData[index]["plan_name"],
                                weight: AppFont.semiBold,
                                size: AppDimen.textSize12,
                                align: TextAlign.start,
                              ),
                              const SizedBox(height: 6),
                              buildRowWidget(
                                firstContent: "${AppStrings.investsDate} :",
                                content: completedPlanData[index]["insert_date"]
                                    .toString()
                                    .substring(0, 10),
                              ),
                              buildRowWidget(
                                firstContent: "${AppStrings.investAmount}: ",
                                content:
                                    "\u20B9 ${completedPlanData[index]["ins_amt"]}",
                              ),
                              buildRowWidget(
                                firstContent: "Maturity Date:  ",
                                content: completedPlanData[index][""]
                                    .toString()
                                    .substring(0, 10),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: AlignmentGeometry.bottomRight,
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width / 3.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: PrimaryText(
                                    text: AppStrings.explore,
                                    weight: AppFont.semiBold,
                                    size: AppDimen.textSize12,
                                    color: AppColors.white,
                                  ),
                                ),
                              ).toGesture(onTap: () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/images/cashback-ribbon.png",
                    scale: 4,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            );
          },
        );
  }
}
