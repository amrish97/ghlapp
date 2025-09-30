import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/dotted_border.dart';

class DocumentUploadWidget extends StatelessWidget {
  final String label;
  final String? filePath;
  final VoidCallback onUpload;

  const DocumentUploadWidget({
    Key? key,
    required this.label,
    required this.filePath,
    required this.onUpload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return filePath == null
        ? DottedBorder(
          color: AppColors.notificationCardColor,
          dash: 12,
          gap: 12,
          strokeWidth: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.documentCardColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                'assets/images/upload.png'.toImageAsset(),
                const SizedBox(height: 10),
                PrimaryText(
                  text: label,
                  size: AppDimen.textSize16,
                  weight: AppFont.semiBold,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Upload",
                  width: MediaQuery.of(context).size.width * 0.5,
                  onTap: onUpload,
                  color: AppColors.greenCircleColor,
                ),
                const SizedBox(height: 10),
                PrimaryText(
                  text: "(Upto 10MB)",
                  size: AppDimen.textSize10,
                  weight: AppFont.semiBold,
                  color: AppColors.lightGrey,
                ),
                const SizedBox(height: 10),
                Container(
                  color: AppColors.primaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: PrimaryText(
                    text: "PNG,JPEG,PDF, Are support",
                    size: AppDimen.textSize10,
                    weight: AppFont.semiBold,
                    color: AppColors.faqColor,
                  ),
                ),
              ],
            ),
          ),
        )
        : Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (filePath!.endsWith(".pdf"))
                Icon(Icons.picture_as_pdf, size: 100, color: AppColors.primary)
              else if (filePath!.startsWith("http"))
                Image.network(
                  filePath!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                )
              else
                Image.file(
                  File(filePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                ),
            ],
          ),
        );
  }
}
