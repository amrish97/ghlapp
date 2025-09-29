import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/utils/extension/extension.dart';

Widget getBackButton(BuildContext context, {GestureTapCallback? onTap}) {
  return Container(
    width: 40,
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.white,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
    child: const Icon(
      Icons.arrow_back_ios_new,
      color: AppColors.black,
      size: 20,
    ),
  ).toGesture(onTap: onTap ?? () => Navigator.pop(context));
}

void fieldFocusChange(
  BuildContext context,
  FocusNode currentFocus,
  FocusNode nextFocus,
) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
