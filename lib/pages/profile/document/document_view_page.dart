import 'package:flutter/material.dart';
import 'package:ghlapp/providers/profile_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/document_upload.dart';
import 'package:provider/provider.dart';

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
                    getBackButton(context),
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
                if (title == AppStrings.aadharCard) ...[
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
                if (title == AppStrings.panCard)
                  DocumentUploadWidget(
                    label: "Upload Your $title",
                    filePath:
                        (value.panCardPath == null ||
                                value.panCardPath!.isEmpty)
                            ? null
                            : value.panCardPath,
                    onUpload: () => value.pickPanCard(),
                  ),
                if (title == AppStrings.bankDocuments)
                  DocumentUploadWidget(
                    label: "Upload Your $title",
                    filePath:
                        (value.bankDocPath == null ||
                                value.bankDocPath!.isEmpty)
                            ? null
                            : value.bankDocPath,
                    onUpload: () => value.pickBankDoc(),
                  ),
                if (title == AppStrings.nomineeDocuments) ...[
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
                if (title == AppStrings.cmlReport) ...[
                  DocumentUploadWidget(
                    label: "Upload Your $title",
                    filePath:
                        (value.cmlReport == null || value.cmlReport!.isEmpty)
                            ? null
                            : value.cmlReport,
                    onUpload: () => value.pickCMLReport(),
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
      case AppStrings.aadharCard:
        isUploaded = value.isAadhaarUploaded;
        docFront = value.frontAadhaarPath;
        docBack = value.backAadhaarPath;
        break;
      case AppStrings.panCard:
        isUploaded = value.isPanUploaded;
        docFront = value.panCardPath;
        break;
      case AppStrings.bankDocuments:
        isUploaded = value.isBankUploaded;
        docFront = value.bankDocPath;
        break;
      case AppStrings.nomineeDocuments:
        isUploaded = value.isNomineeUploaded;
        docFront = value.nomineeFrontPath;
        docBack = value.nomineeBackPath;
        break;
      case AppStrings.cmlReport:
        isUploaded = value.isCMLUploaded;
        docFront = value.cmlReport;
        break;
    }

    return CustomButton(
      text: isUploaded ? AppStrings.changeDocument : AppStrings.submit,
      color: isUploaded ? AppColors.primary : AppColors.greenCircleColor,
      onTap: () {
        if (isUploaded) {
          switch (title) {
            case AppStrings.aadharCard:
              value.resetAadhaar();
              break;
            case AppStrings.panCard:
              value.resetPan();
              break;
            case AppStrings.bankDocuments:
              value.resetBank();
              break;
            case AppStrings.nomineeDocuments:
              value.resetNominee();
            case AppStrings.cmlReport:
              value.resetCMLReport();
              break;
          }
        } else {
          if (docFront == null ||
              docFront.isEmpty ||
              ((title == AppStrings.aadharCard ||
                      title == AppStrings.nomineeDocuments) &&
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
