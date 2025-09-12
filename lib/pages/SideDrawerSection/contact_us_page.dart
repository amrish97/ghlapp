import 'package:flutter/material.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/custom_textField.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
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
                    SizedBox(width: 10),
                    PrimaryText(
                      text: "Contact Us",
                      color: AppColors.black,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: "Need assistance? please fill the form",
                  color: AppColors.black,
                  weight: AppFont.semiBold,
                  size: AppDimen.textSize14,
                  align: TextAlign.start,
                ),
                SizedBox(height: 20,),
                CustomTextFormField(label: "Name"),
                SizedBox(height: 20,),
                CustomTextFormField(label: "Email Address"),
                SizedBox(height: 20,),
                CustomTextFormField(label: "Phone Number"),
                SizedBox(height: 20,),
                CustomTextFormField(label: "Write a Message"),
                SizedBox(height: 20,),
                CustomButton(text: "Send Message", onTap: (){
                  value.contactUs(context);
                }),

              ],
            ),
          ),
        );
      },
    );

  }
}
