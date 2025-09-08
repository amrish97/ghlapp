import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class InvestmentProgress extends StatelessWidget {
  final double investAmount;
  final double totalFund;

  const InvestmentProgress({
    super.key,
    required this.investAmount,
    required this.totalFund,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (totalFund > 0) ? (investAmount / totalFund) : 0;
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 30,
              backgroundColor: AppColors.progressGreyColor.withAlpha(40),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Center(
            child: PrimaryText(
              text: "${(progress * 100).toStringAsFixed(0)}%",
              color: AppColors.white,
              weight: AppFont.semiBold,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
