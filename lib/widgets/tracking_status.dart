import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_text.dart';

class TrackingStatus extends StatelessWidget {
  final int status;

  TrackingStatus({super.key, required this.status});

  final List<String> statusList = [
    "Invested",
    "Acknowledgment Process",
    "Document Processing",
    "Soft Copy Upload",
    "Courier Process",
    "Courier Received",
  ];

  final List<String> imageListData = [
    "assets/images/inverstment.png",
    "assets/images/book.png",
    "assets/images/document_process.png",
    "assets/images/document_process.png",
    "assets/images/courier_fast.png",
    "assets/images/courier-check.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(statusList.length, (index) {
        bool isCompleted = index < status;
        bool isCurrent = index == status;
        final colorbox =
            isCompleted
                ? AppColors.black
                : (isCurrent
                    ? AppColors.greenCircleColor
                    : AppColors.notificationCardColor);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? AppColors.black
                            : (isCurrent
                                ? AppColors.greenCircleColor
                                : Colors.transparent),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isCurrent ? AppColors.greenCircleColor : Colors.grey,
                    ),
                  ),
                  child:
                      isCompleted
                          ? Image.asset("assets/images/tick.png", scale: 3)
                          : (isCurrent
                              ? Image.asset(
                                "assets/images/process-white.png",
                                scale: 3,
                              )
                              : SizedBox.shrink()),
                ),
                if (index != statusList.length - 1)
                  Container(
                    width: 1,
                    height: 50,
                    color: isCompleted ? AppColors.black : Colors.grey.shade400,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: [
                    Image.asset(
                      imageListData[index],
                      height: 20,
                      width: 20,
                      color: colorbox,
                    ),
                    const SizedBox(width: 8),
                    PrimaryText(
                      text: statusList[index],
                      size: AppDimen.textSize14,
                      weight: AppFont.semiBold,
                      color: colorbox,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
