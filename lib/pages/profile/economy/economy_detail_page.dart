import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/readmore_widget.dart';

class EconomyDetailPage extends StatelessWidget {
  final Map<String, dynamic> economyDetail;
  final List<Map<String, dynamic>> latestUpdates;
  final int index;

  const EconomyDetailPage({
    super.key,
    required this.economyDetail,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                text: economyDetail["title"],
                weight: AppFont.semiBold,
                size: AppDimen.textSize16,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    economyDetail["uploadfiles_url"] ?? "",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ReadMoreWidget(
                text: economyDetail["description"].toString().replaceAll(
                  "\"",
                  "",
                ),
                trimLength:
                    (economyDetail["description"].toString().length / 2)
                        .toInt(),
                index: index,
              ),
              SizedBox(height: 20),
              PrimaryText(
                text: "Latest Updates",
                weight: AppFont.semiBold,
                size: AppDimen.textSize16,
              ),
              SizedBox(height: 20),
              Container(
                color: AppColors.white,
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        latestUpdates[0]["uploadfiles_url"] ?? "",
                        fit: BoxFit.cover,
                        height: 160,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 20),
                    PrimaryText(
                      text: latestUpdates[0]["title"] ?? "",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize14,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
