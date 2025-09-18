import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/extension/extension.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    textInputAction: TextInputAction.send,
                    style: AppTextStyles.bodyStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter a message",
                      hintStyle: AppTextStyles.hintStyle,
                      isDense: true,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: 0.8, // WhatsApp style tilt
                  child: Icon(
                    Icons.attach_file_sharp,
                    color: AppColors.primary,
                  ).toGesture(onTap: onAttach),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
        ).toGesture(onTap: onSend),
      ],
    );
  }
}
