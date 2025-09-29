import 'package:flutter/material.dart';
import 'package:ghlapp/pages/profile/document/document_view_page.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> setOfData = [
      {
        "key": "aadhaar",
        "image": "assets/images/pan_detail.png",
        "title": "Aadhaar Card",
      },
      {
        "key": "pan",
        "image": "assets/images/pan_detail.png",
        "title": "Pan Card",
      },
      {
        "key": "bank",
        "image": "assets/images/bank.png",
        "title": "Bank Documents",
      },
      {
        "key": "nominee",
        "image": "assets/images/user-plus.png",
        "title": "Nominee Documents",
      },
      {
        "key": "cml",
        "image": "assets/images/pan_detail.png",
        "title": "CML Report",
      },
    ];
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
                getBackButton(context),
                SizedBox(width: 10),
                PrimaryText(
                  text: AppStrings.myDocument,
                  weight: AppFont.semiBold,
                  size: AppDimen.textSize16,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children:
            setOfData.map((item) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight,
                      ),
                      child: item["image"].toString().toImageAsset(),
                    ),
                    const SizedBox(width: 20),
                    PrimaryText(
                      text: item["title"],
                      size: AppDimen.textSize16,
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
                          (context) => DocumentViewPage(title: item["title"]),
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
