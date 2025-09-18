import 'package:flutter/material.dart';
import 'package:ghlapp/pages/Investment/investment_detail_page.dart';
import 'package:ghlapp/providers/investment_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/video_player.dart';
import 'package:provider/provider.dart';

class InvestmentAboutPage extends StatelessWidget {
  final Map<String, dynamic> planDetail;

  const InvestmentAboutPage({super.key, required this.planDetail});

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
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: YoutubeVideoPlayer(
                              url:
                                  planDetail["y_link1"] ??
                                  "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: YoutubeVideoPlayer(
                              url:
                                  planDetail["y_link2"] ??
                                  "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      PrimaryText(
                        text: "About the Plan",
                        color: AppColors.primary,
                        weight: AppFont.semiBold,
                        size: AppDimen.textSize14,
                      ),
                      Spacer(),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: AppColors.greenCircleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      PrimaryText(
                        text: "Tenkasi Land",
                        weight: AppFont.medium,
                        size: AppDimen.textSize12,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  PrimaryText(
                    text: planDetail["short_description"],
                    align: TextAlign.start,
                    weight: AppFont.regular,
                    size: AppDimen.textSize12,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            InvestmentDetailPage(planDetail: planDetail),
                  ),
                );
              },
              text: "Invest Now",
              color: AppColors.greenCircleColor,
              iconWidget: "assets/images/inverstment.png".toImageAsset(),
            ),
          ),
        );
      },
    );
  }
}
