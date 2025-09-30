import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/custom_textField.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class PersonalDetailPage extends StatelessWidget {
  const PersonalDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.screenBgColor,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: Row(
              children: [
                getBackButton(context),
                SizedBox(width: 10),
                PrimaryText(
                  text: AppStrings.personalDetail,
                  weight: AppFont.semiBold,
                  size: AppDimen.textSize18,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  documentUploadView(
                    label: "",
                    onUpload: () => value.pickProfile(),
                    filePath:
                        (value.filePathProfile == null ||
                                value.filePathProfile!.isEmpty)
                            ? null
                            : value.filePathProfile,
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  buildTextFieldWithContent(
                    label: "Name",
                    controller: value.personalDetailNameController,
                    keyboardType: TextInputType.text,
                    focusNode: value.personalDetailNameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmit: (v) {
                      fieldFocusChange(
                        context,
                        value.personalDetailNameFocus,
                        value.personalDetailEmailFocus,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextFieldWithContent(
                    label: "Email",
                    controller: value.personalDetailEmailController,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: value.personalDetailEmailFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmit: (v) {
                      fieldFocusChange(
                        context,
                        value.personalDetailEmailFocus,
                        value.personalDetailAddressFocus,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextFieldWithContent(
                    label: "Courier Address",
                    controller: value.personalDetailAddressController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: value.personalDetailAddressFocus,
                    onFieldSubmit: (v) {
                      fieldFocusChange(
                        context,
                        value.personalDetailAddressFocus,
                        value.personalDetailPinCodeFocus,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextFieldWithContent(
                    label: "Pincode",
                    controller: value.personalDetailPinCodeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: value.personalDetailPinCodeFocus,
                    onFieldSubmit: (v) {
                      fieldFocusChange(
                        context,
                        value.personalDetailPinCodeFocus,
                        value.personalDetailCityFocus,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextFieldWithContent(
                    label: "City",
                    controller: value.personalDetailCityController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: value.personalDetailCityFocus,
                    onFieldSubmit: (v) {
                      fieldFocusChange(
                        context,
                        value.personalDetailCityFocus,
                        value.personalDetailLandMarkFocus,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextFieldWithContent(
                    label: "LandMark",
                    controller: value.personalDetailLandMarkController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    focusNode: value.personalDetailLandMarkFocus,
                    onFieldSubmit: (v) {
                      value.personalDetailLandMarkFocus.unfocus();
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Save",
                    onTap: () {
                      final fields = [
                        value.personalDetailNameController,
                        value.personalDetailEmailController,
                        value.personalDetailAddressController,
                        value.personalDetailPinCodeController,
                        value.personalDetailCityController,
                        value.personalDetailLandMarkController,
                      ];
                      bool allFilled = fields.every(
                        (controller) => controller.text.isNotEmpty,
                      );
                      if (allFilled) {
                        value.sendPersonalDetail(
                          context,
                          value.filePathProfile ?? "",
                        );
                      } else {
                        AppSnackBar.show(
                          context,
                          message: "Please fill all the fields",
                        );
                      }
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget documentUploadView({
    required String label,
    required VoidCallback onUpload,
    required filePath,
    context,
  }) {
    return filePath == null
        ? Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(width: 5, color: AppColors.white),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundImage:
                    (profilePicture != null && profilePicture != "")
                        ? Image.network(profilePicture.toString()).image
                        : "assets/images/user.png".toAssetImageProvider(),
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
                child: Image.asset('assets/images/edit.png', scale: 3),
              ).toGesture(onTap: onUpload),
            ),
          ],
        )
        : Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(width: 5, color: AppColors.white),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundImage:
                    filePath != null ? FileImage(File(filePath!)) : null,
                child:
                    filePath == null
                        ? Icon(Icons.person, size: 80, color: Colors.grey)
                        : null,
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
                child: Image.asset('assets/images/edit.png', scale: 3),
              ).toGesture(onTap: onUpload),
            ),
          ],
        );
  }

  Widget buildTextFieldWithContent({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    required FocusNode focusNode,
    required ValueChanged<String>? onFieldSubmit,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: label,
          align: TextAlign.start,
          weight: AppFont.semiBold,
          size: AppDimen.textSize16,
        ),
        SizedBox(height: 10),
        CustomTextFormField(
          label: label,
          focusNode: focusNode,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmit,
        ),
      ],
    );
  }
}
