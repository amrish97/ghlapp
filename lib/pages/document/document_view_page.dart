import 'package:flutter/material.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../../widgets/document_upload.dart';

class DocumentViewPage extends StatelessWidget {
  final String title;

  const DocumentViewPage({super.key, required this.title});

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
                      text: title,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title == "Aadhaar Card") ...[
                  DocumentUploadWidget(
                    label: "Upload Your Front Page \n $title",
                    filePath:
                        (value.frontAadhaarPath == null ||
                                value.frontAadhaarPath!.isEmpty)
                            ? null
                            : value.frontAadhaarPath,
                    onUpload: () => value.pickFrontAadhaar(),
                  ),
                  const SizedBox(height: 20),
                  DocumentUploadWidget(
                    label: "Upload Your Back Page \n $title",
                    filePath:
                        (value.backAadhaarPath == null ||
                                value.backAadhaarPath!.isEmpty)
                            ? null
                            : value.backAadhaarPath,
                    onUpload: () => value.pickBackAadhaar(),
                  ),
                ],
                if (title == "Pan Card")
                  DocumentUploadWidget(
                    label: "Upload Your $title",
                    filePath:
                        (value.panCardPath == null ||
                                value.panCardPath!.isEmpty)
                            ? null
                            : value.panCardPath,
                    onUpload: () => value.pickPanCard(),
                  ),
                if (title == "Bank Documents")
                  DocumentUploadWidget(
                    label: "Upload Your $title",
                    filePath:
                        (value.bankDocPath == null ||
                                value.bankDocPath!.isEmpty)
                            ? null
                            : value.bankDocPath,
                    onUpload: () => value.pickBankDoc(),
                  ),
                if (title == "Nominee Documents") ...[
                  DocumentUploadWidget(
                    label: "Upload Your $title \n (Aadhaar Card Front)",
                    filePath:
                        (value.nomineeFrontPath == null ||
                                value.nomineeFrontPath!.isEmpty)
                            ? null
                            : value.nomineeFrontPath,
                    onUpload: () => value.pickNomineeFront(),
                  ),
                  const SizedBox(height: 20),
                  DocumentUploadWidget(
                    label: "Upload Your $title \n (Aadhaar Card Back)",
                    filePath:
                        (value.nomineeBackPath == null ||
                                value.nomineeBackPath!.isEmpty)
                            ? null
                            : value.nomineeBackPath,
                    onUpload: () => value.pickNomineeBack(),
                  ),
                ],
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: buildDocumentButton(context, title, value),
          ),
        );
      },
    );
  }

  Widget buildDocumentButton(context, String title, ProfileProvider value) {
    bool isUploaded = false;
    String? docFront;
    String? docBack;

    switch (title) {
      case "Aadhaar Card":
        isUploaded = value.isAadhaarUploaded;
        docFront = value.frontAadhaarPath;
        docBack = value.backAadhaarPath;
        break;
      case "Pan Card":
        isUploaded = value.isPanUploaded;
        docFront = value.panCardPath;
        break;
      case "Bank Documents":
        isUploaded = value.isBankUploaded;
        docFront = value.bankDocPath;
        break;
      case "Nominee Documents":
        isUploaded = value.isNomineeUploaded;
        docFront = value.nomineeFrontPath;
        docBack = value.nomineeBackPath;
        break;
    }

    return CustomButton(
      text: isUploaded ? "Change Document" : "Submit",
      color: isUploaded ? AppColors.primary : AppColors.greenCircleColor,
      onTap: () {
        if (isUploaded) {
          switch (title) {
            case "Aadhaar Card":
              value.resetAadhaar();
              break;
            case "Pan Card":
              value.resetPan();
              break;
            case "Bank Documents":
              value.resetBank();
              break;
            case "Nominee Documents":
              value.resetNominee();
              break;
          }
        } else {
          if (docFront == null ||
              docFront.isEmpty ||
              ((title == "Aadhaar Card" || title == "Nominee Documents") &&
                  (docBack == null || docBack.isEmpty))) {
            AppSnackBar.show(
              context,
              message: "Please upload all the documents",
            );
          } else {
            value.uploadDocuments(context, title);
          }
        }
      },
    );
  }
}
