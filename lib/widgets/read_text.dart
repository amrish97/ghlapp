import 'package:flutter/material.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class ReadMore extends StatelessWidget {
  final String text;
  final int trimLength;
  final int index;

  const ReadMore({
    super.key,
    required this.text,
    this.trimLength = 100,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
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
            PrimaryText(
              text: displayText,
              weight: AppFont.regular,
              size: AppDimen.textSize12,
              align: TextAlign.start,
            ),
            if (text.length > trimLength)
              GestureDetector(
                onTap: () {
                  provider.toggle(index);
                },
                child: PrimaryText(
                  text: isExpanded ? "Read less" : "Read more",
                  weight: AppFont.regular,
                  size: AppDimen.textSize12,
                  color: AppColors.primary,
                  align: TextAlign.start,
                ),
              ),
          ],
        );
      },
    );
  }
}
