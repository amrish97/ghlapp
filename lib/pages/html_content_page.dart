import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_scaffold.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlContentView extends StatefulWidget {
  final String isFrom;
  final bool showTermsPrivacy;
  const HtmlContentView({
    super.key,
    required this.isFrom,
    required this.showTermsPrivacy,
  });

  @override
  State<HtmlContentView> createState() => _HtmlContentViewState();
}

class _HtmlContentViewState extends State<HtmlContentView> {
  @override
  void initState() {
    context.read<ProfileProvider>().getPrivacy(context);
    context.read<ProfileProvider>().getTermsCondition(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          App().closeApp();
        }
      },
      child: Scaffold(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
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
                    ),
                  ),
                  SizedBox(width: 10),
                  PrimaryText(
                    text: widget.isFrom,
                    color: AppColors.black,
                    weight: AppFont.semiBold,
                    size: AppDimen.textSize18,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    HtmlWidget(
                      widget.showTermsPrivacy
                          ? value.termsContent.replaceAll("\"", "")
                          : value.privacyContent.replaceAll("\"", ""),
                      onTapUrl: (url) async {
                        bool? result = await _onUrlLaunch(url);
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
                    if (!widget.showTermsPrivacy &&
                        widget.isFrom == "Privacy Policy" &&
                        value.isAgreePrivacyPolicy == 0) ...[
                      CustomButton(
                        text: "I Agree",
                        onTap: () async {
                          value.isAgreePrivacyPolicy = 1;
                          await value.postPrivacy(context);
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                    if (widget.showTermsPrivacy &&
                        widget.isFrom == "Terms & Conditions" &&
                        value.isAgreeTermsCondition == 0) ...[
                      CustomButton(
                        text: "I Agree",
                        onTap: () async {
                          value.isAgreeTermsCondition = 1;
                          await value.postTermsCondition(context);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _onUrlLaunch(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
