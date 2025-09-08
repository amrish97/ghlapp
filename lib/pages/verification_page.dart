import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/providers/kyc_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatelessWidget {
  final String routeName;
  final String isFrom;
  const VerificationPage({
    super.key,
    required this.routeName,
    required this.isFrom,
  });

  @override
  Widget build(BuildContext context) {
    final buttonTitle =
        isFrom == "aadhaar"
            ? "Send OTP"
            : (isFrom == "bank" || isFrom == "nominee")
            ? "Save"
            : "Verify PAN";
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.screenBgColor,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
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
                        size: 20, // scale icon too
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  PrimaryText(
                    text: "$routeName Details",
                    color: AppColors.black,
                    weight: AppFont.semiBold,
                    size: AppDimen.textSize18,
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isFrom == "aadhaar" || isFrom == "pan") ...[
                      PrimaryText(
                        text: "$routeName Number",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Enter $routeName Number",
                        keyboardType:
                            isFrom == "aadhaar"
                                ? TextInputType.number
                                : TextInputType.text,
                        showBorderColor: true,
                        controller:
                            isFrom == "aadhaar"
                                ? value.aadhaarController
                                : value.panCardController,
                        textCapitalization:
                            isFrom == "aadhaar"
                                ? TextCapitalization.none
                                : TextCapitalization.characters,
                      ),
                    ],
                    if (isFrom == "bank") ...[
                      PrimaryText(
                        text: "Account Holder Name",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Enter Account Holder Name",
                        keyboardType: TextInputType.text,
                        showBorderColor: true,
                        controller: value.accountHolderNameController,
                      ),
                      SizedBox(height: 20),
                      PrimaryText(
                        text: "Account Number",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Enter Account Number",
                        keyboardType: TextInputType.number,
                        showBorderColor: true,
                        controller: value.accountNumberController,
                      ),
                      SizedBox(height: 20),
                      PrimaryText(
                        text: "IFSC Code",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Enter IFSC Code",
                        keyboardType: TextInputType.text,
                        showBorderColor: true,
                        textCapitalization: TextCapitalization.characters,
                        controller: value.ifscCodeController,
                      ),
                    ],
                    if (isFrom == "nominee") ...[
                      PrimaryText(
                        text: "Full Name",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Enter Full Name",
                        keyboardType: TextInputType.text,
                        showBorderColor: true,
                        controller: value.nomineeNameController,
                      ),
                      SizedBox(height: 20),
                      PrimaryText(
                        text: "Phone Number",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Enter Phone Number",
                        keyboardType: TextInputType.number,
                        showBorderColor: true,
                        controller: value.nomineePhoneController,
                      ),
                      SizedBox(height: 20),
                      PrimaryText(
                        text: "Email Address",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                        showBorderColor: true,
                        controller: value.nomineeEmailController,
                      ),
                      SizedBox(height: 20),
                      PrimaryText(
                        text: "Aadhaar Number",
                        color: AppColors.black,
                        size: AppDimen.textSize16,
                        weight: AppFont.semiBold,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        label: "Enter Aadhaar Number",
                        keyboardType: TextInputType.number,
                        showBorderColor: true,
                        controller: value.nomineeAadhaarController,
                      ),
                    ],
                    SizedBox(height: 30),
                    CustomButton(
                      text: buttonTitle,
                      onTap: () {
                        final validators = {
                          "aadhaar": () {
                            final text = value.aadhaarController.text;
                            if (FieldValidator.validateField(
                              context: context,
                              value: text,
                              emptyMessage: "please enter your aadhaar number",
                              exactLength: 12,
                              lengthMessage:
                                  "please enter your valid aadhaar number with digits!",
                            )) {
                              value.sendToAadhaarOTP(context, text);
                            }
                          },
                          "pan": () {
                            final text = value.panCardController.text;
                            if (FieldValidator.validateField(
                              context: context,
                              value: text,
                              emptyMessage: "please enter your pan number",
                              exactLength: 10,
                              lengthMessage:
                                  "please enter your valid pan number with digits!",
                            )) {
                              value.verifyPanNumber(context, text);
                            }
                          },
                          "bank": () {
                            if (!FieldValidator.validateField(
                              context: context,
                              value: value.accountHolderNameController.text,
                              emptyMessage: "please enter account holder name",
                            )) {
                              return;
                            }

                            if (!FieldValidator.validateField(
                              context: context,
                              value: value.accountNumberController.text,
                              emptyMessage: "please enter account number",
                              lengthMessage:
                                  "please enter your account number correctly",
                            )) {
                              return;
                            }

                            if (!FieldValidator.validateField(
                              context: context,
                              value: value.ifscCodeController.text,
                              emptyMessage: "please enter ifsc code",
                            )) {
                              return;
                            }

                            value.sendToBankDetail(
                              context,
                              value.accountHolderNameController.text,
                              value.accountNumberController.text,
                              value.ifscCodeController.text,
                            );
                          },
                          "nominee": () {
                            if (!FieldValidator.validateField(
                              context: context,
                              value: value.nomineeNameController.text,
                              emptyMessage: "please enter nominee full name",
                            )) {
                              return;
                            }

                            if (!FieldValidator.validateField(
                              context: context,
                              value: value.nomineePhoneController.text,
                              emptyMessage: "please enter nominee phone number",
                            )) {
                              return;
                            }

                            if (!FieldValidator.validateField(
                              context: context,
                              value: value.nomineeEmailController.text,
                              emptyMessage:
                                  "please enter nominee email address",
                            )) {
                              return;
                            }

                            if (!FieldValidator.validateField(
                              context: context,
                              value: value.nomineeAadhaarController.text,
                              emptyMessage:
                                  "please enter nominee aadhaar number",
                            )) {
                              return;
                            }

                            value.sendToNomineeDetail(
                              context,
                              value.nomineeNameController.text,
                              value.nomineePhoneController.text,
                              value.nomineeEmailController.text,
                              value.nomineeAadhaarController.text,
                            );
                          },
                        };
                        validators[isFrom]?.call();
                      },
                      isLoader: value.getIsLoading,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FieldValidator {
  static bool validateField({
    required BuildContext context,
    required String value,
    required String emptyMessage,
    int? exactLength,
    String? lengthMessage,
  }) {
    if (value.isEmpty) {
      AppSnackBar.show(context, message: emptyMessage);
      return false;
    }
    if (exactLength != null && value.length != exactLength) {
      AppSnackBar.show(context, message: lengthMessage ?? "Invalid length");
      return false;
    }
    return true;
  }
}
