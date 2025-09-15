import 'package:flutter/material.dart';
import 'package:ghlapp/pages/SideDrawerSection/financial_detail_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class FinancialPage extends StatelessWidget {
  const FinancialPage({super.key});

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
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    PrimaryText(
                      text: "Financial IQ",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body: ListView.builder(
            itemCount: value.financialIQ.length,
            itemBuilder: (context, index) {
              final financialData = value.financialIQ[index];
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
                          financialData["uploadfiles_url"] ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    PrimaryText(
                      text: financialData["title"],
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
                          (context) =>
                              FinancialDetailPage(financeDetail: financialData),
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
}
