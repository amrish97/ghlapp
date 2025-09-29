import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class PrivacyShowPage extends StatefulWidget {
  const PrivacyShowPage({super.key});

  @override
  State<PrivacyShowPage> createState() => _PrivacyShowPageState();
}

class _PrivacyShowPageState extends State<PrivacyShowPage> {
  @override
  void initState() {
    context.read<ProfileProvider>().getPrivacy(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, value, child) {
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
                    getBackButton(context),
                    SizedBox(width: 10),
                    PrimaryText(
                      text: AppStrings.termsPrivacy,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20.0),
            child: SingleChildScrollView(
              child: HtmlWidget(
                value.privacyContent.replaceAll("\"", ""),
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
          ),
          bottomNavigationBar: Visibility(
            visible: value.isAgreePrivacyPolicy == 0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
                bottom: 20.0,
              ),
              child: CustomButton(
                text: AppStrings.agree,
                onTap: () {
                  value.isAgreePrivacyPolicy = 1;
                  value.postPrivacy(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
