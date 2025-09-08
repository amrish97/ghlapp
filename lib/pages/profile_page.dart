import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/pages/html_content_page.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getPrivacy(context);
      context.read<ProfileProvider>().getTermsCondition(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> imageData = [
      {
        "image": "assets/images/kyc-detail.png",
        "onTap": () {
          Navigator.pushNamed(context, AppRouteEnum.detailPage.name);
        },
        "title": "KYC Details",
      },
      {
        "image": "assets/images/account-detail.png",
        "onTap": () {},
        "title": "Account Detail",
      },
      {
        "image": "assets/images/my-document.png",
        "onTap": () {},
        "title": "My Documents",
      },
      {
        "image": "assets/images/support.png",
        "onTap": () {},
        "title": "Support",
      },
      {
        "image": "assets/images/preferrence.png",
        "onTap": () {},
        "title": "Prefference",
      },
      {
        "image": "assets/images/terms-privacy.png",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HtmlContentView(
                    isFrom: AppStrings.termsPrivacy,
                    showTermsPrivacy: false,
                  ),
            ),
          );
        },
        "title": AppStrings.termsPrivacy,
      },
      {"image": "assets/images/logout.png", "onTap": () {}, "title": "Logout"},
    ];
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return Stack(
            children: [
              Container(
                color: AppColors.primary,
                width: double.infinity,
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            border: Border.all(
                              width: 5,
                              color: AppColors.white,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                Image.asset(
                                  "assets/images/user.png",
                                  fit: BoxFit.cover,
                                ).image,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                            ),
                            child: Image.asset(
                              'assets/images/edit.png',
                              scale: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    PrimaryText(
                      text:
                          aadhaarName.toString().isEmpty
                              ? "User"
                              : aadhaarName.toString(),
                      size: AppDimen.textSize20,
                      weight: AppFont.semiBold,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 130),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        imageData.asMap().entries.map((entry) {
                          final data = entry.value;
                          final index = entry.key;
                          return GestureDetector(
                            onTap: data["onTap"],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 20),
                                  Image.asset(
                                    data["image"],
                                    scale: 3,
                                    color:
                                        index != imageData.length - 1
                                            ? AppColors.black
                                            : Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  PrimaryText(
                                    text: data["title"],
                                    size: AppDimen.textSize14,
                                    weight: AppFont.regular,
                                    color:
                                        index != imageData.length - 1
                                            ? AppColors.black
                                            : Colors.red,
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color:
                                        index != imageData.length - 1
                                            ? AppColors.lightGrey
                                            : Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
