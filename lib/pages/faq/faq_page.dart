import 'package:flutter/material.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/expansion_widget.dart';
import 'package:provider/provider.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(color: AppColors.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Image.asset("assets/images/hand.png", scale: 3),
                        SizedBox(width: 10),
                        PrimaryText(
                          text:
                              "Hi ${aadhaarName.toString().isEmpty ? "User" : aadhaarName.toString()}",
                          size: AppDimen.textSize20,
                          weight: AppFont.semiBold,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    PrimaryText(
                      text:
                          "Lorem ipsum dolor sit amet consectetur. Fermentum ullamcorper placerat ultricies feugiat turpis risus lacus nibh in. Vulputate hac adipiscing integer mattis varius. ",
                      size: AppDimen.textSize12,
                      weight: AppFont.semiBold,
                      color: AppColors.white,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -40),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.screenBgColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: "Start consultation",
                        size: AppDimen.textSize12,
                        weight: AppFont.medium,
                        color: Color.fromRGBO(159, 152, 152, 1),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/group_image.png",
                            scale: 3,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                text: "Start consultation",
                                size: AppDimen.textSize14,
                                weight: AppFont.semiBold,
                              ),
                              PrimaryText(
                                text: "Get a reply in a minute",
                                size: AppDimen.textSize12,
                                weight: AppFont.regular,
                                color: AppColors.lightGrey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: "Start consultation",
                        onTap: () {
                          Navigator.pushNamed(context, AppRouteEnum.chat.name);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FAQSection(),
            ],
          );
        },
      ),
    );
  }
}
