import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';

class FinancialDetailPage extends StatelessWidget {
  final Map<String, dynamic> financeDetail;

  const FinancialDetailPage({super.key, required this.financeDetail});

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
            children: [
              PrimaryText(
                text: financeDetail["title"],
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
                    financeDetail["uploadfiles_url"] ?? "",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: 20),
              HtmlWidget(
                financeDetail["description"].toString().replaceAll("\"", ""),
                customStylesBuilder: (element) {
                  if (element.localName == "p" ||
                      element.localName == "body" ||
                      element.localName == "h1" ||
                      element.localName == "h2") {
                    return {'padding': '0', 'margin': '0'};
                  } else if (element.localName == "a") {
                    return {"color": "blue"};
                  }
                  return null;
                },
                textStyle: AppTextStyles.bodyStyle,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
