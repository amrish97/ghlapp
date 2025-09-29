import 'package:flutter/material.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final List<String> bankLabels = [
      "Account Holder Name",
      "Account Number",
      "IFSC Code",
    ];
    final List<String> kycLabels = ["Aadhaar Number", "PAN Number"];
    final List<String> nomineeLabels = [
      "Full Name",
      "Email Address",
      "Phone Number",
      "Aadhaar Number",
    ];
    final List<String> personalLabels = [
      "Name",
      "Email",
      "Phone Number",
      "Courier Address",
      "PinCode",
      "City",
      "LandMark",
    ];
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
                      text: "$title Details",
                      size: AppDimen.textSize16,
                      weight: AppFont.semiBold,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title == "KYC")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(kycLabels.length, (index) {
                        final label = kycLabels[index];
                        final kyc = value.kycInformation.values.toList();
                        final values =
                            index < kyc.length ? kyc[index].toString() : "";
                        return kycDetailCard(
                          title: label,
                          value:
                              values.toString().contains("null") ? "" : values,
                          context: context,
                        );
                      }),
                    ),
                  if (title == "Account")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(bankLabels.length, (index) {
                        final label = bankLabels[index];
                        final bankValues =
                            value.bankInformation.values.toList();
                        final values =
                            index < bankValues.length
                                ? bankValues[index].toString()
                                : "";
                        return kycDetailCard(
                          title: label,
                          value: values,
                          context: context,
                        );
                      }),
                    ),
                  if (title == "Nominee")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(nomineeLabels.length, (index) {
                        final label = nomineeLabels[index];
                        final nominee =
                            value.nomineeInformation.values.toList();
                        final values =
                            index < nominee.length
                                ? nominee[index].toString()
                                : "";
                        return kycDetailCard(
                          title: label,
                          value: values,
                          context: context,
                        );
                      }),
                    ),
                  if (title == "Personal")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(personalLabels.length, (index) {
                        final label = personalLabels[index];
                        final personalDetail =
                            value.personalDetails.values.toList();
                        final values =
                            index < personalDetail.length
                                ? personalDetail[index].toString()
                                : "";
                        return Column(
                          children: [
                            if (index == 0)
                              CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    profilePicture != null &&
                                            profilePicture != ""
                                        ? Image.network(
                                          profilePicture.toString(),
                                        ).image
                                        : "assets/images/user.png"
                                            .toAssetImageProvider(),
                              ),
                            kycDetailCard(
                              title: label,
                              value: values,
                              context: context,
                            ),
                          ],
                        );
                      }),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget kycDetailCard({
    required String title,
    required String value,
    context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: title,
          size: AppDimen.textSize16,
          weight: AppFont.semiBold,
        ),
        SizedBox(height: 20),
        if (value.contains("http"))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (value.endsWith(".pdf"))
                  Icon(
                    Icons.picture_as_pdf,
                    size: 100,
                    color: AppColors.primary,
                  )
                else if (value.startsWith("http"))
                  Image.network(
                    value,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 4,
                  ),
              ],
            ),
          )
        else
          Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PrimaryText(
                text: value,
                size: AppDimen.textSize14,
                weight: AppFont.regular,
              ),
            ),
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
