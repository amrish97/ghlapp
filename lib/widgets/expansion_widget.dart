import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.faqData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: provider.faqData.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: PrimaryText(
                    text: AppStrings.freqQuestion,
                    size: AppDimen.textSize16,
                    weight: AppFont.medium,
                    align: TextAlign.start,
                    color: AppColors.faqColor,
                  ),
                );
              }
              final faq = provider.faqData[index - 1];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.faqColor1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  dense: true,
                  expansionAnimationStyle: AnimationStyle(),
                  title: PrimaryText(
                    text: faq.title,
                    size: AppDimen.textSize14,
                    weight: AppFont.bold,
                    align: TextAlign.start,
                    color: Color.fromRGBO(91, 91, 91, 1),
                  ),
                  iconColor: AppColors.black,
                  collapsedIconColor: AppColors.black,
                  tilePadding: EdgeInsets.symmetric(horizontal: 10),
                  shape: Border.all(color: AppColors.faqColor1),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: HtmlWidget(
                        faq.content,
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
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
