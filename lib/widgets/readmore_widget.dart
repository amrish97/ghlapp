import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class ReadMoreWidget extends StatelessWidget {
  final String text;
  final int trimLength;
  final int index;

  const ReadMoreWidget({
    super.key,
    required this.text,
    required this.index,
    this.trimLength = 100,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final isExpanded = provider.isExpanded(index);

    final plainText = text.replaceAll(RegExp(r'<[^>]*>'), '');
    final displayText =
        isExpanded || plainText.length <= trimLength
            ? text
            : "${plainText.substring(0, trimLength)}...";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        HtmlWidget(displayText, textStyle: AppTextStyles.bodyStyle),
        if (plainText.length > trimLength)
          InkWell(
            onTap: () => provider.toggle(index),
            child: PrimaryText(
              text: isExpanded ? "Read Less" : "Read More",
              color: AppColors.primary,
              size: AppDimen.textSize12,
              weight: AppFont.semiBold,
            ),
          ),
      ],
    );
  }
}
