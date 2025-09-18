import 'package:flutter/material.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> bankLabels = {
      "b_holdername": "Account Holder Name",
      "b_ac": "Account Number",
      "b_ifsc": "IFSC Code",
    };
    final Map<String, String> kycLabels = {
      "aadhar": "Aadhaar Number",
      "pan": "PAN Number",
    };
    final Map<String, String> nomineeLabels = {
      "nname": "Full Name",
      "nemail": "Email Address",
      "nphone": "Phone Number",
      "aadhaar_number": "Aadhaar Number",
    };
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
                      text: "$title Details",
                      color: AppColors.black,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title == "KYC") ...[
                  Column(
                    children:
                        value.kycInformation.entries.map((entry) {
                          final label = kycLabels[entry.key] ?? entry.key;
                          final val = entry.value?.toString() ?? "";
                          return kycDetailCard(title: label, value: val);
                        }).toList(),
                  ),
                ],
                if (title == "Account") ...[
                  Column(
                    children:
                        value.bankInformation.entries.map((entry) {
                          final label = bankLabels[entry.key] ?? entry.key;
                          final val = entry.value?.toString() ?? "";
                          return kycDetailCard(title: label, value: val);
                        }).toList(),
                  ),
                ],
                if (title == "Nominee") ...[
                  Column(
                    children:
                        value.nomineeInformation.entries.map((entry) {
                          final label = nomineeLabels[entry.key] ?? entry.key;
                          final val = entry.value?.toString() ?? "";
                          return kycDetailCard(title: label, value: val);
                        }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget kycDetailCard({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: title,
          color: AppColors.black,
          size: AppDimen.textSize16,
          weight: AppFont.semiBold,
        ),
        SizedBox(height: 20),
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
              color: AppColors.black,
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
