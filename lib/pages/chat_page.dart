import 'package:flutter/material.dart';
import 'package:ghlapp/constants.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/chat_view.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    context.read<HomeProvider>().getMessages(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.screenBgColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: AppColors.white,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 30),
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                    SizedBox(width: 10),
                    PrimaryText(
                      text:
                          aadhaarName.toString().isEmpty
                              ? "User"
                              : aadhaarName.toString(),
                      color: AppColors.black,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize18,
                      align: TextAlign.start,
                    ),
                    Spacer(),
                    Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        Icons.question_mark,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ).toGesture(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              value.messages.isEmpty
                  ? Center(
                    child: Column(
                      children: [
                        Image.asset("assets/images/no_message.png", scale: 6),
                        SizedBox(height: 10),
                        PrimaryText(
                          text: "No Messages yet ",
                          weight: AppFont.semiBold,
                          size: AppDimen.textSize14,
                        ),
                      ],
                    ),
                  )
                  : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: value.messages.length,
                      itemBuilder: (context, index) {
                        final msg = value.messages[index];
                        return Align(
                          alignment:
                              msg.isSender
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child:
                              msg.text.isNotEmpty
                                  ? Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          msg.isSender
                                              ? AppColors.primary
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: PrimaryText(
                                      text: msg.text,
                                      align: TextAlign.start,
                                      weight: AppFont.semiBold,
                                      color:
                                          msg.isSender
                                              ? AppColors.white
                                              : AppColors.black,
                                      size: AppDimen.textSize14,
                                    ),
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        msg.attachment,
                                        fit: BoxFit.cover,
                                        height: 90,
                                        width: 90,
                                      ),
                                    ),
                                  ),
                        );
                      },
                    ),
                  ),
            ],
          ),
          bottomNavigationBar: ChatInput(
            controller: value.chatMessageController,
            onAttach: () async {
              final file = await value.pickImage();
              if (file != null) {
                await value.uploadImageOnChatPage(file.path, context);
              }
            },
            onSend: () {
              final text = value.chatMessageController.text.trim();
              if (text.isEmpty) {
                AppSnackBar.show(context, message: "Please enter a message");
                return;
              }
              Provider.of<HomeProvider>(
                context,
                listen: false,
              ).sendMessage(text, context);
              value.chatMessageController.clear();
            },
          ),
        );
      },
    );
  }
}
