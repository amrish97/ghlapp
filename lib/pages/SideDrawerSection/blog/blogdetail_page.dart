import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class BlogDetailPage extends StatelessWidget {
  final Map<String, dynamic> blogDetail;

  const BlogDetailPage({super.key, required this.blogDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: getTopSection(context),
    );
  }

  Widget getTopSection(context) {
    String formattedDate = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.parse(blogDetail["created_at"]));
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: Image.network(
            blogDetail["upload_files"] ?? "",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 1.5,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 60,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height / 2 + 60,
            decoration: BoxDecoration(
              color: AppColors.screenBgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 28.0,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        PrimaryText(
                          text: blogDetail["author"].toString().trim(),
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize20,
                          color: AppColors.primary,
                          align: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    HtmlWidget(
                      blogDetail["description"].replaceAll("\"", ""),
                      onTapUrl: (url) async {
                        bool? result = await BaseFunction().onUrlLaunch(url);
                        result ??= false;
                        return result;
                      },
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
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 120,
          left: 20,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: PrimaryText(
              text: blogDetail["category"],
              weight: AppFont.regular,
              size: AppDimen.textSize10,
              color: AppColors.white,
              align: TextAlign.start,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 100,
          left: 20,
          right: 20,
          child: PrimaryText(
            text: "Post Date: $formattedDate",
            weight: AppFont.regular,
            size: AppDimen.textSize20,
            color: AppColors.white,
            align: TextAlign.start,
          ),
        ),
        Positioned(top: 50, left: 20, child: getBackButton(context)),
      ],
    );
  }
}
