import 'package:flutter/material.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/read_text.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: PrimaryText(
            text: AppStrings.aboutUs,
            weight: AppFont.semiBold,
            size: AppDimen.textSize20,
          ),
          centerTitle: true,
          backgroundColor: AppColors.screenBgColor,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: Row(children: [getBackButton(context)]),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  spacing: 14,
                  children: [
                    PrimaryText(
                      text:
                          "Want to invest with confidence? learn who we are and what we stand for!",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize22,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: "assets/images/group_people.jpg".toImageAsset(),
                    ),
                    buildCheckBox(
                      firstContent: "Our Journey from",
                      content: "2019 to 2024",
                    ),
                    PrimaryText(
                      text:
                          "As humans, beyond our basic needs, we search for something that brings happiness and peace to our souls, right? This search gives us a reason to understand who we are and why we are here. ",
                      weight: AppFont.regular,
                      size: AppDimen.textSize14,
                    ),
                    SizedBox(height: 10),
                    "assets/images/sampling.png".toImageAsset(scale: 3.5),
                    PrimaryText(
                      text:
                          "GHL India was born from the vision of passionate venture seekers determined to support young entrepreneurs and potential investors. Their mission was to offer funds and profits, ensuring a peaceful investment journey. On October 8, 2021, GHL India was launched, implementing their innovative concept of fractional investment and debt funding.",
                      weight: AppFont.regular,
                      size: AppDimen.textSize14,
                    ),
                    SizedBox(height: 20),
                    PrimaryText(
                      text:
                          "In our journey towards achieving our goals, we follow several key steps",
                      weight: AppFont.bold,
                      color: AppColors.primary,
                      size: AppDimen.textSize14,
                    ),
                    SizedBox(height: 6),
                    "assets/images/roadmap.png".toImageAsset(),
                    SizedBox(height: 10),
                    PrimaryText(
                      text: "Understanding Our Analytical Methods",
                      size: AppDimen.textSize14,
                      weight: AppFont.semiBold,
                    ),
                    getContainer(
                      image: "assets/images/Micro-analysis.png",
                      title: "Micro Analysis :",
                      content:
                          "We research individual markets, sectors, and enterprises to understand supply and demand, competition, and consumer behavior. This helps us identify viable investment opportunities and minimize risks by examining demographic trends",
                      index: 1,
                    ),
                    SizedBox(height: 10),
                    getContainer(
                      image: "assets/images/Macro-analysis.png",
                      title: "Macro Analysis :",
                      content:
                          "We research individual markets, sectors, and enterprises to understand supply and demand, competition, and consumer behavior. ",
                      index: 2,
                    ),
                    SizedBox(width: 10),
                    getContainer(
                      image: "assets/images/pestle.png",
                      title: "PESTLE Analysis :",
                      content:
                          "Our PESTLE analysis provides a comprehensive understanding of the external environment affecting our investments. Here’s what we evaluate:",
                      index: 3,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: AppColors.primary),
                padding: EdgeInsets.all(20),
                child: PrimaryText(
                  text:
                      "By evaluating these factors, we anticipate changes, adjust our strategy, and manage risks effectively. This thorough approach enables us to achieve a 99% efficiency in risk management.",
                  weight: AppFont.regular,
                  size: AppDimen.textSize12,
                  align: TextAlign.start,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: AppColors.white),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getColoredTextWithContent(
                      "Political: Government policies, trade rules, and tax laws",
                    ),
                    getColoredTextWithContent(
                      "Economic: Unemployment rates, economic growth, and inflation.",
                    ),
                    getColoredTextWithContent(
                      "Social: Demographic trends, public attitudes, and consumer buying habits.",
                    ),
                    getColoredTextWithContent(
                      "Technological: New technologies, research areas, and tech-related incentives.",
                    ),
                    getColoredTextWithContent(
                      "Legal: Health and safety regulations, employment laws, and product standards.",
                    ),
                    getColoredTextWithContent(
                      "Environmental: Climate conditions, environmental policies, and energy use regulations.",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    PrimaryText(
                      text: "Curious About Our Vision Mission?",
                      size: AppDimen.textSize16,
                      weight: AppFont.semiBold,
                    ),
                    SizedBox(height: 10),
                    getContainerView(
                      image: "assets/images/vision.png",
                      title: "Vision :",
                      content:
                          "Many people believe that achieving a goal is the ultimate dream and are constantly striving for it. However, we see success not just in reaching a goal but in beginning the journey towards it, achieving it, and then continually setting and pursuing new goals to embrace the process of exploration and growth.",
                    ),
                    SizedBox(height: 10),
                    getContainerView(
                      image: "assets/images/mission.png",
                      title: "Mission :",
                      content:
                          "Our mission is to launch viable business ideas reliably and foster the growth of our investors' wealth with trustworthiness. Your satisfaction and peace of mind are paramount to us, and we carry out our work with empathy and care.",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  getColoredTextWithContent(String coloredText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [getColoredText(displayText: coloredText)],
    );
  }

  Widget getColoredText({required String displayText}) {
    int colonIndex = displayText.indexOf(":");
    String firstLetter = displayText.isNotEmpty ? displayText[0] : "";
    String beforeColon = "";
    String afterColon = "";
    if (colonIndex != -1) {
      beforeColon = displayText.substring(1, colonIndex);
      afterColon = displayText.substring(colonIndex + 1);
    } else {
      beforeColon = displayText.substring(1);
    }

    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: firstLetter,
              style: AppTextStyles.aboutContentStyleRed,
            ),
            TextSpan(
              text: beforeColon,
              style: AppTextStyles.aboutContentStyleBold,
            ),
            if (colonIndex != -1)
              TextSpan(text: ":", style: AppTextStyles.aboutContentStyleBold),
            if (afterColon.isNotEmpty)
              TextSpan(
                text: afterColon,
                style: AppTextStyles.aboutContentStyle,
              ),
          ],
        ),
      ),
    );
  }

  Widget getContainerView({
    required String image,
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(image, scale: 2, height: 50),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '',
                children: <TextSpan>[
                  TextSpan(
                    text: title,
                    style: AppTextStyles.aboutContentStyleBold,
                  ),
                  TextSpan(text: ' '),
                  TextSpan(text: content, style: AppTextStyles.bodyStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getContainer({
    required String image,
    required String title,
    required String content,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          image.toString().toImageAsset(scale: 3, height: 120, width: 120),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: title,
                  weight: AppFont.bold,
                  size: AppDimen.textSize12,
                  align: TextAlign.start,
                ),
                ReadMore(text: content, index: index),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckBox({
    required String firstContent,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: '',
            children: <TextSpan>[
              TextSpan(text: firstContent, style: AppTextStyles.aboutStyle),
              TextSpan(text: ' '),
              TextSpan(text: content, style: AppTextStyles.resendCodeStyle),
            ],
          ),
        ),
      ],
    );
  }
}
